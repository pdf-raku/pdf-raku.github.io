use v6;

module Lib::Buf::Raw {
    use LibraryMake;
    # Find our compiled library.
    sub libbuf is export(:libbuf) {
        state $ = do {
            my $so = get-vars('')<SO>;
            ~(%?RESOURCES{"lib/libbuf$so"});
        }
    }

}
