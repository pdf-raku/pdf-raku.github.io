constant PDFRoot = "https://pdf-raku.github.io";
constant HarfBuzzRoot = "https://harfbuzz-raku.github.io";

# Map to the best documentation source
my subset PDFModule of Str where 'Grammar'|'Lite';
my subset PDFCore of Str where 'COS'|'IO';

proto sub resolve-class(*@) {
    my %info = {*};
    %info<proj url> = %info<repo>.starts-with("HarfBuzz")
        ?? ('HarfBuzz', HarfBuzzRoot)
        !! ('PDF', PDFRoot);
    %info;
}

multi sub resolve-class(*@path ( 'PDF', 'Content', *@)) { %( :repo<PDF-Content-raku>, :@path ) }
multi sub resolve-class(*@path ( 'PDF', 'Tags', 'Reader', *@)) { %( :repo<PDF-Tags-Reader-raku>, :@path ) }
multi sub resolve-class(*@path ( 'PDF', 'Tags', *@)) { %( :repo<PDF-Tags-raku>, :@path ) }
multi sub resolve-class(*@path ( 'PDF', 'Native', *@)) { %( :repo<PDF-Native-raku>, :@path ) }
multi sub resolve-class(*@path ( 'Font', 'FreeType', *@)) { %( :repo<Font-FreeType-raku>, :@path ) }
multi sub resolve-class(*@path ( 'FontConfig', *@)) { %( :repo<FontConfig-raku>, :@path ) }
multi sub resolve-class(*@ ('PDF', 'Font', 'Loader', 'CSS', *@)) { %( :repo<PDF-Font-Loader-CSS-raku> ) }
multi sub resolve-class(*@path ('PDF', 'Font', 'Loader', *@)) { %( :repo<PDF-Font-Loader-raku>, :@path ) }

multi sub resolve-class('Font', 'AFM') { %( :repo<Font-AFM-raku> ) }
multi sub resolve-class('PDF', 'API6', *@path) { %( :repo<PDF-API6> ) }
multi sub resolve-class(*@ ('PDF', PDFModule $mod, *@path)) { %( :repo("PDF-{$mod}-raku") ) }
multi sub resolve-class('PDF') { %( :repo<PDF-raku> )}
multi sub resolve-class('PDF', PDFCore, *@) { %( :repo<PDF-raku> )}
multi sub resolve-class('PDF', *@path) { %( :repo<PDF-Class-raku> )}

multi sub resolve-class(*@path ( 'HarfBuzz', 'Subset', *@)) { %( :repo<HarfBuzz-Subset-raku>, :@path ) }
multi sub resolve-class(*@ ( 'HarfBuzz', 'Shaper', 'Cairo', *@)) { %( :repo<HarfBuzz-Shaper-Cairo-raku> ) }
multi sub resolve-class(*@path ( 'HarfBuzz', 'Font', 'Cairo', *@)) { %( :repo<HarfBuzz-Shaper-Cairo-raku>, :@path ) }
multi sub resolve-class(*@ ( 'HarfBuzz', 'Font', 'FreeType', *@)) { %( :repo<HarfBuzz-Font-FreeType-raku> ) }
multi sub resolve-class(*@path ( 'HarfBuzz', *@)) { %( :repo<HarfBuzz-raku>, :@path ) }

multi sub resolve-class(*@path ( 'FDF', *@)) { %( :repo<FDF-raku>, :@path ) }

multi sub resolve-class(*@p) {
    warn "unknown path: {@p}";
    @p;
}

sub link-to-url(Str() $class-name) {
    my %info = resolve-class(|$class-name.split('::'));
    my @path = %info<url>;;
    @path.push: %info<repo>;
    @path.append(.list) with %info<path>;
    @path.join: '/';
}

sub breadcrumb(Str $url is copy, @path, UInt $n = +@path, :$top) {
    my @subpath =  @path[0 ..^ $n];
    my $subdir =  @subpath.join('/');
    my $name = $top ?? @subpath.join('::') !! @path[$n-1];
    my $sep = $top ?? '/' !! '::';
    if "lib/{$subdir}.rakumod".IO.e {
        $url ~= '/' ~ $subdir;
        say " $sep [$name]($url)";
    }
    else {
        say " $sep $name";
    }
}

INIT {
    with %*ENV<TRAIL> {
        # build a simple breadcrumb trail
        my %info = resolve-class(|.split('/'));
        my $url = %info<url>;
        my $proj = %info<proj>;
        say "[[Raku $proj Project]]({$url})";
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

s:g:s/ '](' ([PDF|FDF|Font[Config]?|HarfBuzz]['::'*%%<[a..z A..Z 0..9 _ -]>+]) ')'/{'](' ~ link-to-url($0) ~ ')'}/;
