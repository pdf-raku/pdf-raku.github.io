constant Repo = "https://pdf-raku.github.io";

# Map to the best documentation source
# At this stage, only FDF and PDF::Tags has a docs folder
# with detailed per-class doco. Others link to top-level README

# -- Projects with docs/ folder --
multi sub class-ref(@ ( 'PDF', 'Tags', *@p)) { 'PDF-Tags-raku', @p }
multi sub class-ref(@ ( 'FDF', *@p)) { 'FDF-raku', @p }
multi sub class-ref(@ ( 'Font', 'FreeType', *@p)) { 'Font-FreeType-raku', @p }

# -- Projects with top-level README --
multi sub class-ref(@ ( 'PDF', 'API6', *@p)) { 'PDF-API6', }
multi sub class-ref(@ ( 'PDF', 'Content', *@p)) { 'PDF-Content-raku', }
multi sub class-ref(@ ( 'PDF', 'Grammer', *@p)) { 'PDF-Grammer-raku', }
multi sub class-ref(@ ( 'PDF', 'Lite', *@p)) { 'PDF-Lite-raku', }
multi sub class-ref(@ ( 'PDF', 'Font', 'Loader', *@p)) { 'PDF-Font-Loader-raku', }
multi sub class-ref(@ ( 'PDF' )) { 'PDF-raku' }
# 
multi sub class-ref(@ ( 'PDF', $p1 where 'COS'|'IO'|'Reader'|'Writer', *@p)) { 'PDF-raku' }
multi sub class-ref(@ ( 'PDF', *@p)) { 'PDF-Class-raku' }

multi sub class-ref(@_) {
    warn "unknown path: {@_}";
    @_;
}

sub doco-path(Str() $class) {
    my @path = $class.split('::');
    @path = flat class-ref(@path);
    @path.unshift: Repo;
    @path.join: '/';
}

s:g:s/ '](' ([PDF|FDF|Font]['::'*%%<[a..z A..Z 0..9 _ -]>+]) ')'/{'](' ~ doco-path($0) ~ ')'}/;
