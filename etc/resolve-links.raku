constant DocRoot = "https://pdf-raku.github.io";

# Map to the best documentation source
# At this stage, only FDF and PDF::Tags has a docs folder
# with detailed per-class doco. Others link to top-level README

# -- Projects with docs/ folder --
multi sub resolve-class(@path ( 'PDF', 'Tags', *@)) { %( :repo<PDF-Tags-raku>, :@path ) }
multi sub resolve-class(@path ( 'FDF', *@)) { %( :repo<FDF-raku>, :@path ) }
multi sub resolve-class(@path ( 'Font', 'FreeType', *@)) { %( :repo<Font-FreeType-raku>, :@path ) }
multi sub resolve-class(@path ( 'HarfBuzz', *@)) { %( :repo<HarfBuzz-raku>, :@path ) }

# -- Projects with top-level README --
multi sub resolve-class(@ ( 'PDF', 'API6', *@path)) { %( :repo<PDF-API6> ) }
multi sub resolve-class(@ ( 'PDF', 'Content', *@path)) { %( :repo<PDF-Content-raku> ) }
multi sub resolve-class(@ ( 'PDF', 'Grammer', *@path)) { %( :repo<PDF-Grammer-raku> ) }
multi sub resolve-class(@ ( 'PDF', 'Lite', *@path)) { %( :repo<PDF-Lite-raku> ) }
multi sub resolve-class(@ ( 'PDF', 'Font', 'Loader', *@path)) { %( :repo<PDF-Font-Loader-raku> ) }
multi sub resolve-class(@ ( 'PDF' )) { %( :repo<PDF-raku> )}
multi sub resolve-class(@ ( 'PDF', $p1 where 'COS'|'IO'|'Reader'|'Writer', *@path)) { %( :repo<PDF-raku> )}
multi sub resolve-class(@ ( 'PDF', *@path)) { %( :repo<PDF-Class-raku> )}

multi sub resolve-class(@_) {
    warn "unknown path: {@_}";
    @_;
}

sub link-to-url(Str() $class-name) {
    my %info = resolve-class($class-name.split('::'));
    my @path = DocRoot;
    @path.push: %info<repo>;
    @path.append(.list) with %info<path>;
    @path.join: '/';
}

sub breadcrumb(Str $url is copy, @path, UInt $n = +@path, :$top) {
    my $name = $top ?? @path[0 ..^ $n].join('::') !! @path[$n-1];
    $url ~= '/' ~ @path[0..^ $n].join('/');
    my $sep = $top ?? '/' !! '::';
    say " $sep [$name]($url)";
}

INIT {
    with %*ENV<TRAIL> {
        # build a simple breadcrumb trail
        my $url = DocRoot;
        say "[[Raku PDF Project]]({$url})";
        my %info = resolve-class(.split('/'));
        my $repo = %info<repo>;
        $url ~= '/' ~ $repo;

        my @mod = $repo.split('-');
        @mod.pop if @mod.tail ~~ 'raku';
        my $mod = @mod.join: '-';
        say " / [[$mod Module]]({$url})";

        with %info<path> {
            my @path = .list;
            my $n = @path[0..^+@mod] == @mod ?? +@mod !! 2;
            breadcrumb($url, @path, $n, :top);
            breadcrumb($url, @path, $_)
                for $n ^.. @path;
        }
        say '';
    }
}

s:g:s/ '](' ([PDF|FDF|Font|HarfBuzz]['::'*%%<[a..z A..Z 0..9 _ -]>+]) ')'/{'](' ~ link-to-url($0) ~ ')'}/;
