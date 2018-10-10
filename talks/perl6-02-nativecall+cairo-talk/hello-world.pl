use Cairo;

my Cairo::Image $img .= create(Cairo::FORMAT_ARGB32, 128, 128);
my Cairo::Context $ctx .= new($img);

$ctx.move_to(10, 50);
$ctx.show_text: "Hello world";

$ctx.line_width = 1;
$ctx.rgb(.5,.5,.5);
$ctx.rectangle(0,0,128,128);
$ctx.stroke;
$img.write_png: "hello.png";
