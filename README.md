p6-pdf.github.io
================

Documentation for the Perl 6 PDF tool-chain.

Very much a work on progress. This repo will assemble and publish documentation
to HTML and PDF. As much as possible, the tool-chain itself will be used to
publish to PDF.

The individual README.md files from each of the module repos will be used, along
with additional markdown files.

For now, here's a quick run-down of the tool-chain modules (top to bottom):
```
  [PDF::Font::Loader]           [Lib::PDF]
 --------------------    -----------------------------
                             |                  |
    [PDF::Lite]   <--|       V                  V
                     |   [PDF::Content]    <-- [PDF]   <-- [PDF::Grammar]
    [PDF::Class]  <--|       ^          
         ^                   |          
         |               ---------------
    [PDF::API6]          [HTML::Canvas]   <--| [CSS::Properties]
                         [PDF::Style]     <--|
```

## Pure PDF Modules

### [PDF::Lite](https://github.com/p6-pdf/PDF-Lite-p6) - Focused on authoring and basic content manipulation only.

### [PDF::Class](https://github.com/p6-pdf/PDF-Class-p6) - Implements classes for
the internal structure of a PDF

### [PDF::API6](https://github.com/p6-pdf/PDF-API6) - MOre fully featured PDF manipulation library

## PDF/HTML Suite

PDF::Style[::Font], HTML::Canvas[::To::PDF] and CSS::Declarations are designed to work together for higher level HTML/CSS flavoured PDF creation.

### [HTML::Canvas](https://github.com/p6-pdf/HTML-Canvas-p6)

Implements the HTML5 Canvas 2D API. For simple text, graphics and images.

### [PDF::Style](https://github.com/p6-pdf/PDF-Style-p6)

A companion module to HTML::Canvas. Allows composition with HTML positioning and CSS Styling rules and box model.

### [CSS::Properties](https://github.com/p6-css/CSS-Properties-p6)

Top of the CSS tool-chain. An important companion to HTML::Canvas and PDF::Style.

## Low Level Modules

### [PDF::Content](https://github.com/p6-pdf/PDF-Content-p6) - Roles for manipulating text, graphics and images.

Put to work by PDF::Lite and PDF::Class

### [PDF](https://github.com/p6-pdf/PDF-p6) - for PDF manipulation, including compression, encryption and reading and writing of PDF data.

The king-pin of the PDF tool-chain. Handles physical access to PDF's, including reading, writing, compression and encryption.

### [PDF::Grammar](https://github.com/p6-pdf/PDF-Grammr-p6)

A collection of grammars for parsing PDF elements and content

### [Lib::PDF](https://github.com/p6-pdf/libpdf-p6) library of decoding and encoding functions, etc.

An optional library of encoding and decoding routines, written in C for
performance. At this stage, only a few select filters are available.

## Status

### Released: PDF::Grammar, PDF, CSS::Properties, PDF::Lite, PDF::Content

### Held Back: Lib::PDF

Needs more development and bench-marking

### Experimental: HTML::Canvas::To::PDF, PDF::Style

These have helped to drive development of the above modules.

Fonts need to be developed a bit more. Could be we need a Font::FreeType module;
and to integrate Cairo glyph fonts.

Todo:

- Complete README.md doco
- More source-level POD
- Work on building HTML/PDF from source/READMEs (ideally, not an absolute blocker)

Todo:

- More doco
- Look at Windows testing via Appveyor?

### Prototype: PDF::To::Cairo

The start of a pretty big module. Mostly exists to excercise other modules

