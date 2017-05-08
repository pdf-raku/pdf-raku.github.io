use v6;

use Lib::Buf;
use NativeCall;

my $buf;
my @bytes = (10, 20, 30, 40, 50, 60, 70, 80);
my $bytes := buf8.new(@bytes);
my uint32 @in1[1;3] = ([10, 1318440, 12860],);

for 1 .. 265 {
$buf = Lib::Buf.unpack($bytes, 4);

$buf = Lib::Buf.unpack($bytes,  2);
Lib::Buf.pack($buf, 2);

$buf=Lib::Buf.unpack($bytes, 16);
Lib::Buf.pack($buf, 16);

$buf=Lib::Buf.unpack($bytes[0..5], 24);
Lib::Buf.pack($buf, 24);

$buf=Lib::Buf.pack([1415192289,], 32);
$buf= Lib::Buf.pack([2 ** 32 - 1415192289 - 1,], 32);

my $idx=Lib::Buf.unpack($bytes, [1, 3, 2]);
Lib::Buf.pack($idx, [1, 3, 2]);

}

