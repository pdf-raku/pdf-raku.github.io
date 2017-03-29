Using Perl 6 Native types & NativeCall
-------------------------------------

Lib::PDF - A library of optimised PDF functions
- PDF processing requires 'bit-crunching'
- Perl 5
  - only has strings (realistically) + vec()
- Perl6
  - is expressive, but (c2017) not fast
  - has built in native-types and C interface
  - makes it easy write critical code in C
  - which is fast and easy to integrate with Perl 6
  - NativeCall and Native Types rock

---

A Perl 5 example (from PDF::API2)
-------

```
    my $string;
    # ...
    } elsif($filter==3) {
        foreach my $x (0..length($line)-1) {
            vec($clear,$x,8) = (vec($line,$x,8)
                    + floor((vec($clear,$x-$bpp,8)
                    + vec($prev,$x,8))/2)) % 256;
        }
    } elsif($filter==4) {
    # ...
```

- arrays aren't used much (high overheads)
- mostly uses pack/unpack to marshall to binary strings
- `vec` is used for bit-level manipulation
- PDF data tends to be byte or word orientated

---

Perl 6 has Native Types
------
This is the same, coded in Perl 6:
```
    my uint8 @out;
    # ...
    when  3 { # Average
        for 0 ..^ $row-size -> $i {
            my \left = $i < $colors
                ?? 0
                !! @out[$n - $colors];
            my \up = $row ?? @out[$n - $row-size] !! 0;
            @out[$n++] = ($buf[$idx++]
                       + ( (left + up) div 2 )) +& mask;
            }
        }
        
    # ...
```
- `@out` is a compact array of unsigned bytes
- it can mostly be used like an Int array

---

Perl 6 Gradual Typing
-----
Variables are untyped (type Any) by default:
```
my $v = 37 + 5;
$v = "hi";
```
Can declare typed scalar variables:
```
my Int $v = 37 + 5;
$v = "hi"; # Type check failed in assignment to $v...
```
Also typed Arrays, Hashes (and other containers):
```
my UInt @a = 3, 5, 7, 9; # array of positive integers
@a.push: -99; # Type check failed in assignment ...
````
---

Perl 6 Native Types
------
```
my uint8 $i = 248; # unsigned byte
$i += 42;
say $i; # 34
```

These are distinguished by their lowercase names:

`int`, `uint`, `int8`, `int16`, `num` (float), `str`, ...etc

Native arrays. ```my uint8 @state = 0..255;```

Native arrays are compact and contain just one data-type. Similar to arrays in languages such as C#, Java or C.

Can have 2-D "shaped" arrays:

```
my uint8 @matrix[2;3] Z= 1 .. 6;
say @matrix[1;2]; # 5
```

---

Buf's and Blobs
---------------

One more thing to mention are Buf's and Blobs.

These are typically used to read and write binary data.

- They may be used to create and save Unicode strings in different encodings (utf-8, utf-16, etc).

- For our purposes they are used to pass data to native functions.

```
    my uint8 @data = 1..10, 27, 99;
    my buf8 $buf .= new(@data);
    do-stuff-quickly($buf);
```

---

PDF Streams
------
Data often has multiple packing levels. From an actual PDF.
```
13 0 obj <<
  /Type /XRef
  /Filter /FlateDecode
  /DecodeParms <<
    /Columns 5
    /Predictor 12
  >>
  / W[1 3 1]
  % .. plus other entries
>>
stream
% ... binary data follows
```
- `/Filter` - Flate Compression
- `/Columns` - Blocks of 5 x 8 bits (bytes)
- `/Predictor` - Data is post-processed using PNG predictors
- `/W [1 3 1]` - grouped as 1, 3 and 1 byte values

---

Need to handle the above to support PDF 1.5
------
Both Perl 5 and 6 have a Flate compression library. But need to code for Predictors and W sampling.

- This is what C is designed for
- A bit more of a challenge in Perl 5
- Looks pretty in Perl 6, but not fast (c2017)

Perl has good native data types. These help somewhat, with the processing and keeping memory pressure down.

But not enough. This is critical code. Probably 90-95% of an average PDF is compressed stream data 

Perl 6 has a great NativeCall interface. Easy to code this in C. Should be faster.

---

Coding in pure Perl
------

Let's consider the final decoding stage; Applying the `W` array.

Use this to unpack variable length words as a 32 bit longs.

With `/W [1 3 1]`:

Bytes ```[1,  0, 0, 2,  3,   10,  0, 1, 7,  20]```

Decodes to: ```[[1, 2, 3,], [10, 262, 20]]```

(A 2-d 'shaped' array)

---

```
    #| variable resampling, e.g. to decode:
    #|   obj 123 0 << /Type /XRef /W [1, 3, 1]
    multi sub resample( $nums!, 8, Array $W!)  {
        my uint $i = 0;
        my uint $j = 0;
        my uint32 @out;
        my $out-len = (+$nums * +$W) div $W.sum;
        my uint $w_len = +$W;

        @out[$out-len - 1] = 0
            if +$nums;

        while $i < +$nums {
            my uint32 $v = 0;
            my $n = $W[$j % $w_len];
            for 1 .. $n {
                $v +<= 8;
                $v += $nums[$i++];
            }
            @out[$j++] = $v;
        }
        my uint32 @shaped[+@out div +$W;$W] Z= @out;
        @shaped;
    }

```

---
Factoring out the inner Loop:
-------
```
#| variable resampling, e.g. to decode/encode:
#|   obj 123 0 << /Type /XRef /W [1, 3, 1]
multi method resample( $in!, 8, Array $W!)  {
    my uint32 $in-len = +$in;
    my buf8 $in-buf .= new($in);
    my buf8 $W-buf .= new($W);
    my $out-buf := buf32.new;
    my $out-len = ($in-len * +$W) div $W.sum;
    $out-buf[$out-len - 1] = 0
       if $out-len;
    pdf_buf_unpack_32_W($in-buf, $out-buf,
                        $in-len, $W-buf, +$W);
    uint32 @shaped[$out-len div +$W;+$W] Z= $out-buf;
    @shaped;
}
```
---
And coding pdf_buf_unpack_32_W in C:
-----
```
extern void pdf_buf_unpack_32_W(
              uint8_t *in, uint32_t *out, size_t in_len,
              uint8_t *w, size_t w_len) {

  size_t i;
  uint32_t j = 0;

  for (i = 0; i < in_len;) {
    uint32_t v = 0;
    uint8_t n = w[j % w_len];
    uint8_t k;

    for (k = 0; k < n; k++) {
      v <<= 8;
      v += in[i++];
    }
    out[j++] = v;
  }
}
```

---

Registering the function
------

C definition [pdf_buf.h]:

```
extern void pdf_buf_unpack_32_W(
    uint8_t *in, uint32_t *out, size_t in_len,
    uint8_t *w, size_t w_len);
```

Corresponding Perl 6 definition [Buf.pm]:

```
    use NativeCall;
    use Lib::PDF :libpdf;
    # ...
    sub pdf_buf_pack_32_W(
                    Blob, Blob, size_t,
                    Blob, size_t)
                is native(
                &libpdf) { * }
```


