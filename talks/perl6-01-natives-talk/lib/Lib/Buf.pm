use v6;

class Lib::Buf {

    use NativeCall;
    use Lib::Buf::Raw :libbuf;

    sub buf_unpack_1(Blob, Blob, size_t)  is native(&libbuf) { * }
    sub buf_unpack_2(Blob, Blob, size_t)  is native(&libbuf) { * }
    sub buf_unpack_4(Blob, Blob, size_t)  is native(&libbuf) { * }
    sub buf_unpack_16(Blob, Blob, size_t) is native(&libbuf) { * }
    sub buf_unpack_24(Blob, Blob, size_t) is native(&libbuf) { * }
    sub buf_unpack_32(Blob, Blob, size_t) is native(&libbuf) { * }
    sub buf_unpack_32_W(Blob, Blob, size_t, Blob, size_t) is native(&libbuf) { * }

    sub buf_pack_1(Blob, Blob, size_t)  is native(&libbuf) { * }
    sub buf_pack_2(Blob, Blob, size_t)  is native(&libbuf) { * }
    sub buf_pack_4(Blob, Blob, size_t)  is native(&libbuf) { * }
    sub buf_pack_16(Blob, Blob, size_t) is native(&libbuf) { * }
    sub buf_pack_24(Blob, Blob, size_t) is native(&libbuf) { * }
    sub buf_pack_32(Blob, Blob, size_t) is native(&libbuf) { * }
    sub buf_pack_32_W(Blob, Blob, size_t, Blob, size_t) is native(&libbuf) { * }

    my subset PackingSize where 1|2|4|8|16|24|32;
    sub alloc($type, $len) {
        my $buf = Buf[$type].new;
        $buf[$len-1] = 0 if $len;
        $buf;
    }
    sub container(PackingSize $bits) {
        $bits <= 8 ?? uint8 !! ($bits > 16 ?? uint32 !! uint16)
    }
    
    sub do-packing($n, $m, $in is copy, &pack) {
        my uint32 $in-len = $in.elems;
        $in = Buf[container($n)].new($in)
            unless $in.isa(Blob);
        my $out-type = container($m);
        my $out := alloc($out-type, ($in-len * $n + $m-1) div $m);
        &pack($in, $out, $in-len);
        $out;
    }
    multi method unpack($nums!, PackingSize $n!)  {
        my $type = container($n);
        my &packer = %(
            1 => &buf_unpack_1,
            2 => &buf_unpack_2,
            4 => &buf_unpack_4,
            16 => &buf_unpack_16,
            24 => &buf_unpack_24,
            32 => &buf_unpack_32,
        ){$n};
            do-packing(8, $n, $nums, &packer);
    }
    
    multi method pack($nums!, PackingSize $n!)  {
        my $type = container($n);
        my &packer = %(
            1 => &buf_pack_1,
            2 => &buf_pack_2,
            4 => &buf_pack_4,
            16 => &buf_pack_16,
            24 => &buf_pack_24,
            32 => &buf_pack_32,
        ){$n};
        do-packing($n, 8, $nums, &packer);
    }

    #| variable resampling, e.g. to decode/encode:
    #|   obj 123 0 << /Type /XRef /W [1, 3, 1]
    multi method unpack( $in!, Array $W!)  {
        my uint32 $in-len = +$in;
        my buf8 $in-buf = $in ~~ buf8 ?? $in !! buf8.new($in);
        my buf8 $W-buf .= new($W);
        my $out-buf := buf32.new;
        my $out-len = ($in-len * +$W) div $W.sum;
        $out-buf[$out-len - 1] = 0
           if $out-len;
        buf_unpack_32_W($in-buf, $out-buf, $in-len, $W-buf, +$W);
	my uint32 @shaped[$out-len div +$W;+$W] Z= $out-buf;
        @shaped;
    }

    multi method pack( $in, Array $W!)  {
        my $rows = $in.elems;
        my $cols-in = +$W;
        my $cols-out = $W.sum;
	my $out = alloc(uint8, $rows * $cols-out);
        my buf32 $in-buf = $in ~~ buf32 ?? $in !! buf32.new($in);
        my buf8 $W-buf .= new($W);
        buf_pack_32_W($in-buf, $out, $rows * $cols-in, $W-buf, +$W);
        $out;
    }
}
