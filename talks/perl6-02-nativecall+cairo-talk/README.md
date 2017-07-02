NativeCall/Cairo in Perl 6 - a case stody
--------------------------------------
David Warring                July 2017

- Cairo is a popular 2D graphics native library
- A good demonstration of the NativeCall interface
- Native Subroutine calls
- Native 'methods'
- Enumerations
- 'CPointer' Classes
- 'CStruct' Classes
- Method calls
- Perl6 Callbacks

---

Perl 6 Native Types Recap
------

Perl 6 has PHP/Ruby/Python like dynamic arrays:

```
    my @a = (42, "Hi", [3,4,5]);
    say @a[1];
```
But also C/C#/Java like compact native arrays and variables:
```
    my uint32 @b = 123, 568, 789;
    my uint8 $btyes;
```

Design goal: Native arrays faster in tight loops and critical code.

Optimisation is still a work in progress (JIT).

Perl 6 does has an affinity to native libraries.

---

Cairo - helloworld in C
-------

```
#include <cairo.h>

int
main (int argc, char *argv[])
{
    cairo_surface_t *image = cairo_image_surface_create(
        CAIRO_FORMAT_ARGB32, 240, 80);
    cairo_t *ctx = cairo_create ();

    cairo_move_to (ctx, 10.0, 50.0);
    cairo_show_text (ctx, "Hello, world");

    cairo_destroy (ctx);
    cairo_surface_write_to_png (image, "hello.png");
    cairo_surface_destroy (image);
    return 0;
}
```
---
Definitions from /usr/include/cairo/cairo.h
----

```
typedef struct _cairo cairo_t;
typedef struct _cairo_surface cairo_surface_t;

cairo_public cairo_status_t
cairo_surface_write_to_png (cairo_surface_t *surface,
			    const char *filename);
typedef enum _cairo_format {
    CAIRO_FORMAT_INVALID   = -1,
    CAIRO_FORMAT_ARGB32    = 0,
    CAIRO_FORMAT_RGB24     = 1,
    /* ... */
} cairo_format_t;

cairo_public cairo_surface_t *
cairo_image_surface_create (cairo_format_t format,
			    int	width,
			    int	height);
                cairo_public void
cairo_move_to (cairo_t *cr, double x, double y);
cairo_public void
cairo_show_text (cairo_t *cr, const char *utf8);
                
```

---
Hello World in  Perl 6
------------
```
use Cairo;

my Cairo::Image $img .= create( Cairo::FORMAT_ARGB32,
                                128, 128);
my Cairo::Context $ctx .= new($img);

$ctx.move_to(10, 50);
$ctx.show_text: "Hello world";

$img.write_png: "hello.png"
```
![hello.png 250%](hello.png)

---

Minimal NativeCall bindings
---

Define a Perl 6 `Cairo` module that bind to `cairo` and defines just enough to run our 'hello world' example.

```
unit module Cairo;
my $cairolib;
BEGIN {
    $cairolib = ('cairo', v2);
}
use NativeCall;

our enum Format (
     FORMAT_INVALID => -1,
    "FORMAT_ARGB32"   ,
    "FORMAT_RGB24"    ,
    # ...
);

```
---
```
class cairo_surface_t is repr('CPointer') {
    method write_to_png(Str $filename)
        returns int32
        is native($cairolib)
        is symbol('cairo_surface_write_to_png')
        {*}
}
class Surface {
    has cairo_surface_t $.surface
        handles <write_to_png>;
}
class Image is Surface {
    sub cairo_image_surface_create(int32 $format,
                          int32 $width, int32 $height)
        returns cairo_surface_t
        is native($cairolib) {*}

     method create(Int(Format) $format,
                   Int(Cool) $width,
                   Int(Cool) $height) {
        my $surface = cairo_image_surface_create(
             $format, $width, $height)
        return self.new: :$surface;
    }
}

```
---
```
our class cairo_t is repr('CPointer') {
    method show_text(Str $utf8)
        is native($cairolib)
        is symbol('cairo_show_text')
        {*}
    method move_to(num64 $x, num64 $y)
        is native($cairolib)
        is symbol('cairo_move_to')
        {*}
}

class Context {
    sub cairo_create(cairo_surface_t $surface)
        returns cairo_t
        is native($cairolib)
        {*}

    has cairo_t $.context handles <show_text>;

    method new(Surface $surface) {
        my $context = cairo_create($surface.surface);
        self.bless(:$context);
    }

    multi method move_to(Num(Cool) $x, Num(Cool) $y) {
        $!context.move_to($x, $y);
    }
 }

```
---
