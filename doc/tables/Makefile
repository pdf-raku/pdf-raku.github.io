## Would be good to generate them all in one run,
## but that takes a lot of memory.
## Do them one at a time. Pretty slow, as we need
## to reload index, struct-trees, etc

PDF_SPEC=../../etc/PDF32000_2008.pdf
MAKE_TABLE=perl6 ../../bin/pdf-struct-dump.p6 --/atts --max-depth=8 --search-tag=Table

all : tables

tables : Table-5-Stream_dictionaries.html Table-6-Standard_filters.html Table-8-LZW_and_Flate_filter_params.html Table-11-CCITTFax_filter_params.html Table-15-File_trailer_entries.html Table-16-Object_stream_entries.html Table-17-Cross_reference_stream_dict_entries.html Table-18-19-Cross_reference_stream_entries.html

Table-5-Stream_dictionaries.html :
	${MAKE_TABLE} --page=28 $(PDF_SPEC) > $@

Table-6-Standard_filters.html :
	${MAKE_TABLE} --page=31 $(PDF_SPEC) > $@

Table-8-LZW_and_Flate_filter_params.html :
	${MAKE_TABLE} --page=35 $(PDF_SPEC) > $@

Table-11-CCITTFax_filter_params.html :
	${MAKE_TABLE} --page=38 $(PDF_SPEC) > $@

Table-15-File_trailer_entries.html :
	${MAKE_TABLE} --page=51 $(PDF_SPEC) > $@

Table-16-Object_stream_entries.html :
	${MAKE_TABLE} --page=54 $(PDF_SPEC) > $@

Table-17-Cross_reference_stream_dict_entries.html :
	${MAKE_TABLE} --page=58 $(PDF_SPEC) > $@

Table-18-19-Cross_reference_stream_entries.html :
	${MAKE_TABLE} --page=59 $(PDF_SPEC) > $@
