Raku PDF Project Overview
----

### API Modules

#### [PDF::Lite](https://pdf-raku.github.io/PDF-Lite-raku/) - Basic PDF Manipulation

Suitable for simple graphics and PDF construction

#### [PDF::API6](https://pdf-raku.github.io/PDF-API6/) - Advanced Manipulation

Fully Featured API, including Outlines, Advanced Colors, Interactive Forms, Settings and Metadata.
#### [FDF](https://pdf-raku.github.io/FDF-raku/) - FDF Manipulation

### Extension Modules

Module | Description | Compatiblity
-------|-------------|------------
[PDF::Font::Loader](https://pdf-raku.github.io/PDF-Font-Loader-raku/)|Loads True-Type (`*.ttf`), OpenType (`*.otf`) and Type-1 (`*.pfb`) files.|[PDF::Lite](https://pdf-raku.github.io/PDF-Lite-raku/), [PDF::API6](https://pdf-raku.github.io/PDF-API6/) and [PDF::Class](https://pdf-raku.github.io/PDF-Class-raku/)
[PDF::Tags](https://pdf-raku.github.io/PDF-Tags-raku/)|Tagged PDF reading and writing|[PDF::API6](https://pdf-raku.github.io/PDF-API6/) and [PDF::Class](https://pdf-raku.github.io/PDF-Class-raku/)
[HTML::Canvas::To::PDF](https://pdf-raku.github.io/HTML-Canvas-To-PDF-raku/) | HTML 5 Canvas renderer |[PDF::Lite](https://pdf-raku.github.io/PDF-Lite-raku/), [PDF::API6](https://pdf-raku.github.io/PDF-API6/) and [PDF::Class](https://pdf-raku.github.io/PDF-Class-raku/)

### Tool-chain Modules

#### [PDF::Class](https://pdf-raku.github.io/PDF-Class-raku/) - PDF Object Classes
#### [PDF::Content](https://pdf-raku.github.io/PDF-Content-raku/) - PDF Content Manipulation
#### [PDF](https://pdf-raku.github.io/PDF-raku/) - Low-level PDF Manipulation
#### [PDF::Grammar](https://pdf-raku.github.io/PDF-Grammar-raku/) - PDF-related grammars
#### [Font::AFM](https://pdf-raku.github.io/Font-AFM-raku/) - AFM Font Metrics for Type-1 and core fonts
#### [Font::FreeType](https://pdf-raku.github.io/Font-FreeType-raku/) - FreeType font-library bindings
#### [PDF::ISO_32000](https://pdf-raku.github.io/PDF-ISO_32000-raku/) - Mined resources from the PDF specification, including an [XML Dump of ISO-32000 1](https://raw.githack.com/pdf-raku/PDF-ISO_32000-raku/master/gen/PDF-ISO_32000.xml)

### Experimental

#### [HarfBuzz::Subset](https://pdf-raku.github.io/HarfBuzz-Subset-raku/) - Font subsetting for [PDF::Font::Loader](https://pdf-raku.github.io/PDF-Font-Loader-raku/)



