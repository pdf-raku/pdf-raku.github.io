## Would be good to generate them all in one run,
## but that takes a lot of memory.
## Do them one at a time. Pretty slow, as we need
## to reload index, struct-trees, etc

PDF_SPEC=../../etc/PDF32000_2008.pdf
define table-to-html
    (echo '<Html><Head/><Body>' && perl6 ../../bin/pdf-struct-dump.p6 --/atts --max-depth=8 --search-tag=Table --page=$(1) $(PDF_SPEC) && echo '</Body></Html>')
endef

all : tables
tables : Table-5-Stream_dictionaries.html Table-6-Standard_filters.html Table-8-LZW_and_Flate_filter_params.html Table-11-CCITTFax_filter_params.html Table-15-File_trailer_entries.html Table-16-Object_stream_entries.html Table-17-Cross_reference_stream_dict_entries.html Table-18-19-Cross_reference_stream_entries.html

Table-5-Stream_dictionaries.html :
	$(call table-to-html,28) > $@

Table-6-Standard_filters.html :
	$(call table-to-html,31) > $@

Table-8-LZW_and_Flate_filter_params.html :
	$(call table-to-html,35) > $@

Table-11-CCITTFax_filter_params.html :
	$(call table-to-html,38) > $@

Table-15-File_trailer_entries.html :
	$(call table-to-html,51) > $@

Table-16-Object_stream_entries.html :
	$(call table-to-html,54) > $@

Table-17-Cross_reference_stream_dict_entries.html :
	$(call table-to-html,58) > $@

Table-18-19-Cross_reference_stream_entries.html :
	$(call table-to-html,59) > $@
