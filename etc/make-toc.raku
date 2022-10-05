use v6;

# quick and dirty markdown TOC generator
# To seed the table of contents, place the line
# '- Toc here' somehwere near the top of the markdown file

sub text-to-anchor(Str() $text) {
    my $anchor = ~$text.lc;
    $anchor ~~ s:g/\s+/-/;
    $anchor ~~ s:g/<- [a..z 0..9 _ -]>//;
    $anchor;
}

sub MAIN(Str:D $md-file, Int :$min-level=1, Int :$max-level = 3) {
    my Bool $code = False;
    my $doc = $md-file.IO.slurp;

    my %anchors;
    my %refs;

    $doc  ~~ /^ $<waffle>=.*? +%% ["```" \n? $<code>=.*? "```" \n?] $/
         or die "$md-file parse failed";

    my @toc = gather {
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
                        take '%s- [%s](#%s)'.sprintf($indent,$text,$anchor)
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
    }

   # do the doc subsitution
   print $doc.subst(/^^[[\s*"-"\N*\n]+]/, @toc.join: "\n");

   for %refs.keys.grep({!(%anchors{$_}:exists)}) {
       warn "unresolved internal reference: \#$_";
   }

}
