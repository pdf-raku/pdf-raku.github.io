Binary data in Perl 6 - a quick look
--------------------------------------
David Warring                March 2017

Native types, Blobs/Bufs and NativeCall

- Native types are built into Perl 6
- Native arrays - compact and efficient
- Also has Bufs/Blobs for binary access
- NativeCall (extern functions)
  - Integration of third party libraries
  - Extension functions

---

Perl 6 Gradual Typing
-----

Untyped Perl 6 scalars are similar to Perl 5. They can hold just about anything:
```
my $v = 37 + 5;
$v = "hi";
```
But in Perl 6 we can declare types:
```
my Int $v = 37 + 5;
$v = "hi"; # Type check failed in assignment to $v...
```
We can also declare type on Arrays, Hashes (and other containers). These are applied to individual elements:
```
my UInt @a = 3, 5, 7, 9; # array of positive integers
@a.push: -99; # Type check failed in assignment ...
````
---

Perl 6 Native Types
------
Native types are built into Perl 6. They have lowercase names:

```
my uint8 $i = 248; # unsigned byte
$i += 42;
say $i; # 34
```
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

These are typically used to read and write binary data.

- They may be used to create and save Unicode strings in different encodings (utf-8, utf-16, etc).

- For our purposes they are commonly used to pass data to native functions.

```
    my uint8 @data = 1..10, 27, 99;
    my buf8 $buf .= new(@data);
    do-stuff($buf, +$buf);
```

This should be reasonably efficient. `do-stuff` could be either pure Perl or a native (extern) routine.

---
NativeCall
-----
A simple example from the ecosystem:

`OpenSSL::Digest` from the `OpenSSL` distribution:

```
use OpenSSL::NativeLib;
use NativeCall;

unit module OpenSSL::Digest;

our constant MD5_DIGEST_LENGTH    = 16;

sub MD5( Blob, size_t, Blob )
    is native(&gen-lib)    { ... }

sub md5(Blob $msg) is export {
     my $digest = buf8.new(0 xx MD5_DIGEST_LENGTH);
     MD5($msg, $msg.bytes, $digest);
     $digest;
}

# also sha1, sha256

```
---
To use this module:

```
use OpenSSL::Digest;

my Buf $msg-buf = "foo bar".encode("latin-1");
my Buf $digest = md5($test-buf);
my Str $hex-chars = $digest.listÃƒâ€šÃ‚Â».fmt: "%02x";
say $hex-chars; # fbc1a9f858ea9e177...
```

10x+ speedup (Rakudo 2017.03) from using a native function.

---

Case Study - Decoding PDF Data
------
Data often has multiple encoding levels. From an actual PDF.
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

Perl 5 Binary Data (from PDF::API2)
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
Generally:
- arrays are avoided (high overheads)
- binary strings are used instead
- `vec` is used for bit-level manipulation

---

Equivalent Perl 6
------
Native types make this easier to express:
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
`@out` is a compact VM array of unsigned bytes
`uint8` is a sub-type of Int

But not fast (Rakudo 2017.03).

We at least have the option of coding this natively.

---

`W` Decoding - Requirement
------

Let's consider the final decoding stage; Applying the `W` array.

Need to unpack variable length words as a 32 bit longs.

With `/W [1 3 1]`:

Bytes ```[1, 0,0,2, 3,  10, 0,1,7, 20]```

Decodes to: ```[[1, 2, 3,], [10, 262, 20]]```

(A 2-d 'shaped' array)

---
```
#| variable re-sampling, e.g. to decode/encode:
#|   obj 123 0 << /Type /XRef /W [1, 3, 1]
multi method resample( $in!, 8, Array $W!)  {
    my uint32 $in-len = $in.bytes;
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
Inner Function in Perl 6:
---
```
sub pdf_buf_pack_32_W(
    buf8 $in,
    buf8 $out,
    uint32 $in-len,
    buf8 $W,
    int $w-len) {
    uint $i = 0;
    uint $j = 0;

    while $i < $in-len {
        my uint32 $v = 0;
        my $n = $W[$j % $w-len];
        for 1 .. $n {
            $v +<= 8;
            $v += $in[$i++];
        }
        $in[$j++] = $v;
    }
}
```

---

Inner function in C:
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

C prototype [pdf_buf.h]:

```
extern void pdf_buf_unpack_32_W(
    uint8_t *in, uint32_t *out, size_t in_len,
    uint8_t *w, size_t w_len);
```

Corresponding Perl 6 prototype [Buf.pm]:

```
    use NativeCall;
    use Lib::PDF :libpdf;
    # ...
    sub pdf_buf_pack_32_W(
                    Blob, Blob, size_t,
                    Blob, size_t)
                is native(&libpdf) { * }
```

---
Configuration
-----
- Uses the Perl 6 LibraryMake module
- Configuration inherited from Rakudo
- Makefile generated from hand-coded Makefile.in
- perl6-valgrind-m for memory checking

---
Conclusions
-----

- Easier/Safer handling of binary data
- Easy integration of third party libraries
- Critical code can be optimized in C
- East to mix Perl 6 and C

Further Considerations:
- Advanced NativeCall (structs, unions, allocation, callbacks,..)
- Other languages
