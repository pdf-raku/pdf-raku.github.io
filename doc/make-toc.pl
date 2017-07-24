use v6;

# quick and dirty TOC generator

sub MAIN(Str $md-file = "perl6-pdf-toolchain.md", Int :$max-level = 3) {
    for $md-file.IO.lines {
        if /:s^ $<hdr>='#'+ $<text>=.*?  $/ {
            my UInt $level = $<hdr>.chars;

            if $level <= $max-level {
                my Str $text = ~ $<text>;
                my $anchor = ~$text.lc;
                $anchor ~~ s:g/\s+/-/;
                $anchor ~~ s:g/<- [a..z 0..9 _ -]>//;
                my $indent = ' ' xx (2 * ($level-1));
                say '%s- [%s](#%s)'.sprintf($indent,$text,$anchor);
            }
        }
    }
}
