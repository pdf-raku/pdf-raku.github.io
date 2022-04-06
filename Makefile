TaggedPDFDtD=dtd/tagged-pdf.dtd

all : dtd

dtd : $(TaggedPDFDtD)

$(TaggedPDFDtD) : etc/make-tagged-pdf-dtd.raku $(wildcard src/*.csv)
	raku etc/make-tagged-pdf-dtd.raku > $@
