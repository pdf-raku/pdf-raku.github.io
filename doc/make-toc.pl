use v6;

# quick and dirty TOC generator

sub MAIN(Str $md-file = "perl6-pdf-toolchain.md", Int :$min-level=1, Int :$max-level = 3) {
    my Bool $code = False;
    my $doc = $md-file.IO.slurp;

    $doc  ~~ /^ $<waffle>=.*? +%% ["```" \n? $<code>=.*? "```" \n?] $/
         or die "$md-file parse failed";

    for @<waffle> {
        for .lines {
            if /:s^ $<hdr>='#'+ $<text>=.*?  $/ {
                my UInt $level = $<hdr>.chars;

                if $min-level <= $level <= $max-level {
                    my Str $text = ~ $<text>;
                    my $anchor = ~$text.lc;
                    $anchor ~~ s:g/\s+/-/;
                    $anchor ~~ s:g/<- [a..z 0..9 _ -]>//;
                    my $indent = ' ' xx (2 * ($level-1));
                    say '%s- [%s](#%s)'.sprintf($indent,$text,$anchor)
                        unless $anchor eq 'table-of-contents';
                }
            }
        }
    }
}
