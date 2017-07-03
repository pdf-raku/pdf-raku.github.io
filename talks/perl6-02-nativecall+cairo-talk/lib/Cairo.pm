# A small subset of the real Perl 6 Cairo module
unit module Cairo;
my $cairolib;
BEGIN {
    $cairolib = ('cairo', v2);
}
use NativeCall;

## from /usr/include/cairo/cairo.h:

=begin demo

typedef struct _cairo_surface cairo_surface_t;

cairo_public cairo_status_t
cairo_surface_write_to_png (cairo_surface_t	*surface,
			    const char		*filename);
typedef enum _cairo_format {
    CAIRO_FORMAT_INVALID   = -1,
    CAIRO_FORMAT_ARGB32    = 0,
    CAIRO_FORMAT_RGB24     = 1,
    /* ... */
} cairo_format_t;

cairo_public cairo_surface_t *
cairo_image_surface_create (cairo_format_t	format,
			    int			width,
			    int			height);

=end demo
=cut

## Surface

our class cairo_surface_t is repr('CPointer') {

    method write_to_png(Str $filename)
        returns int32
        is native($cairolib)
        is symbol('cairo_surface_write_to_png')
        {*}
}

class Surface {
    has cairo_surface_t $.surface handles <write_to_png>;
}

our enum Format (
     FORMAT_INVALID => -1,
    "FORMAT_ARGB32"   ,
    "FORMAT_RGB24"    ,
    # ...
);


class Image is Surface {
    sub cairo_image_surface_create(int32 $format, int32 $width, int32 $height)
        returns cairo_surface_t
        is native($cairolib)
        {*}


     method create(Int(Format) $format, Int(Cool) $width, Int(Cool) $height) {
        return self.new(surface => cairo_image_surface_create($format, $width, $height));
    }
}

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
