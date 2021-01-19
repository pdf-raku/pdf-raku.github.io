use v6;

# quick and dirty markdown TOC generator

sub text-to-anchor(Str() $text) {
    my $anchor = ~$text.lc;
    $anchor ~~ s:g/\s+/-/;
    $anchor ~~ s:g/<- [a..z 0..9 _ -]>//;
    $anchor;
}

sub MAIN(Str $md-file = "perl6-pdf-toolchain.md", Int :$min-level=1, Int :$max-level = 3) {
    my Bool $code = False;
    my $doc = $md-file.IO.slurp;

    my %anchors;
    my %refs;

    $doc  ~~ /^ $<waffle>=.*? +%% ["```" \n? $<code>=.*? "```" \n?] $/
         or die "$md-file parse failed";

    for @<waffle> {
        for .lines {
            if /:s^$<hdr>='#'+ $<text>=.*?  $/ {
                my UInt $level = $<hdr>.chars;
                my Str:D $text = ~$<text>;
                my $anchor = text-to-anchor($text);

                with %anchors{$anchor} {
                    warn "duplicate anchor: \#$anchor";
                }
                else {
                    $_ = $text;
                }

                if $min-level <= $level <= $max-level {
                    my $indent = ' ' xx (2 * ($level-1));
                    say '%s- [%s](#%s)'.sprintf($indent,$text,$anchor)
                        unless $anchor eq 'table-of-contents';
                }
            }
            else {
                if m/'](#' ~ ')' $<ref>=.*? / {
                    %refs{$<ref>}++;
                }
            }
        }
    }

   for %refs.keys.grep({!(%anchors{$_}:exists)}) {
       warn "unresolved internal reference: \#$_";
   }
}
