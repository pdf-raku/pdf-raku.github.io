constant DocRoot = "https://pdf-raku.github.io";

# Map to the best documentation source
# At this stage, only FDF and PDF::Tags has a docs folder
# with detailed per-class doco. Others link to top-level README

# -- Projects with docs/ folder --
multi sub class-glob(@ ( 'PDF', 'Tags', *@p)) { 'PDF-Tags-raku', @p }
multi sub class-glob(@ ( 'FDF', *@p)) { 'FDF-raku', @p }
multi sub class-glob(@ ( 'Font', 'FreeType', *@p)) { 'Font-FreeType-raku', @p }

# -- Projects with top-level README --
multi sub class-glob(@ ( 'PDF', 'API6', *@p)) { 'PDF-API6', }
multi sub class-glob(@ ( 'PDF', 'Content', *@p)) { 'PDF-Content-raku', }
multi sub class-glob(@ ( 'PDF', 'Grammer', *@p)) { 'PDF-Grammer-raku', }
multi sub class-glob(@ ( 'PDF', 'Lite', *@p)) { 'PDF-Lite-raku', }
multi sub class-glob(@ ( 'PDF', 'Font', 'Loader', *@p)) { 'PDF-Font-Loader-raku', }
multi sub class-glob(@ ( 'PDF' )) { 'PDF-raku' }
# 
multi sub class-glob(@ ( 'PDF', $p1 where 'COS'|'IO'|'Reader'|'Writer', *@p)) { 'PDF-raku' }
multi sub class-glob(@ ( 'PDF', *@p)) { 'PDF-Class-raku' }

multi sub class-glob(@_) {
    warn "unknown path: {@_}";
    @_;
}

sub doco-path(Str() $class) {
    my @path = $class.split('::');
    @path = flat class-glob(@path);
    @path.unshift: DocRoot;
    @path.join: '/';
}

INIT {
    with %*ENV<TRAIL> {
        # build a simple breadcrumb trail
        my $path = DocRoot;
        say "[[Raku PDF Project]]({$path})";
        my $n;
        my $sep = '/';

        for class-glob(.split('/')) -> $here {
            $path ~= '/' ~ $here;
            if ++$n == 1 {
                $path ~= '-raku';
            }
            say " $sep [{$here}]({$path})";
            $sep = '::';
        }
    }
    say '';
}

s:g:s/ '](' ([PDF|FDF|Font]['::'*%%<[a..z A..Z 0..9 _ -]>+]) ')'/{'](' ~ doco-path($0) ~ ')'}/;
