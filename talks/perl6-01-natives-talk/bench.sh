(set -x;
# all have about the same running time (.5sec)
# native int (JIT)
perl6 -e'my int $x = 0; $x++ while $x < 100_000_000; say now - INIT now';
# non-native Int
perl6 -e'my Int $x = 0; $x++ while $x < 1_200_000; say now - INIT now';
# complex loop
perl6 -e'
    # -*- setup -*-
    my $buf = buf8.new: (^255).pick xx 50_000;
    my uint $n = $buf.bytes div 2;
    my uint16 @nw[$n];
    # -*- timed -*-
    my $t = now;
    my uint $i = 0;
    my int $j = 0;
    while $j < $n {
        my uint16 $w = $buf[$i++] * 256 + $buf[$i++];
        @nw[$j++] = $w;
    };
    say now - $t;
'
# 30 - 60 MByte / sec (MoarVM)
perl6 -I lib -e'
    use Lib::Buf;
    # -*- setup -*-
    my $buf = buf8.new: (^255).pick xx 1_000_000;
    my uint $n = $buf.bytes div 2;
    # -*- timed -*-
    my $t = now;
    my buf16 $nw;
    for 1..30 {
       $nw = Lib::Buf.unpack($buf, 16);
    }
    say now - $t;
'
# 30 - 60 MByte / sec (MoarVM)
perl6 -I lib -e'
    use Lib::Buf;
    use NativeCall;
    # -*- setup -*-
    my $buf = CArray[uint8].new: (^255).pick xx 1_000_000;
    my uint $n = $buf.elems div 2;
    # -*- timed -*-
    my $t = now;
    my CArray $nw;
    for 1..30 {
       $nw = Lib::Buf.unpack($buf, 16);
    }
    say now - $t;
'
)
