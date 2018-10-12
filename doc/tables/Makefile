## Makefile to desseminate tables from PDF Specification
## as referenced throughout the Perl 6 PDF Tool-chain.
## Used for documentation and automated cross-checking
## Notes:
## - Doing them one at a time. Pretty slow
## - Would be good to generate them all in one run,
##   but that takes a lot of memory.
## - Could batch a few at a time, with a bit more work

PDF_SPEC=../../etc/PDF32000_2008.pdf
define table-to-html
    (echo '<Html><Head/><Body>' && perl6 ../../bin/pdf-struct-dump.p6 --/atts --max-depth=8 --search-tag=Table --page=$(1) $(PDF_SPEC) && echo '</Body></Html>')
endef

all : tables
tables : Table-5-Stream_dictionaries.html Table-6-Standard_filters.html Table-8-LZW_and_Flate_filter_params.html Table-11-CCITTFax_filter_params.html Table-15-File_trailer_entries.html Table-16-Object_stream_entries.html Table-17-Cross_reference_stream_dict_entries.html Table-18-19-Cross_reference_stream_entries.html Table-20-Encryption_entries.html Table-21-Additional_encryption_entries.html Table-22-User_access_permissions.html Table-28-Catalog_entries.html Table-29-Pages_entries.html Table-30-Page_entries.html Table-31-Catalog_Name_entries.html Table-33-Resource_entries.html Table-34-PDF_data_types.html Table-35-String_object_data_types.html Table-36-Name_tree_node_entries.html Table-37-Number_tree_node_entries.html Table-38-Function_common_entries.html Table-39-Type-0-function_entries.html Table-40-Type-2-function_entries.html Table-41-Type-3-function_entries.html Table-42-Type-4-function_operators.html

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

Table-20-Encryption_entries.html :
	$(call table-to-html,64) > $@

Table-21-Additional_encryption_entries.html :
	$(call table-to-html,68) > $@

Table-22-User_access_permissions.html :
	$(call table-to-html,69) > $@

Table-28-Catalog_entries.html :
	$(call table-to-html,81) > $@

Table-29-Pages_entries.html :
	$(call table-to-html,84) > $@

Table-30-Page_entries.html :
	$(call table-to-html,85) > $@

Table-31-Catalog_Name_entries.html :
	$(call table-to-html,89) > $@

Table-33-Resource_entries.html :
	$(call table-to-html,91) > $@

Table-34-PDF_data_types.html :
	$(call table-to-html,93) > $@

Table-35-String_object_data_types.html :
	$(call table-to-html,94) > $@

Table-36-Name_tree_node_entries.html :
	$(call table-to-html,97) > $@

Table-37-Number_tree_node_entries.html :
	$(call table-to-html,99) > $@

Table-38-Function_common_entries.html :
	$(call table-to-html,101) > $@

Table-39-Type-0-function_entries.html :
	$(call table-to-html,102) > $@

Table-40-Type-2-function_entries.html :
	$(call table-to-html,104) > $@

Table-41-Type-3-function_entries.html :
	$(call table-to-html,105) > $@

Table-42-Type-4-function_operators.html :
	$(call table-to-html,106) > $@
