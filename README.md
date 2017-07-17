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
                                [Lib::PDF]
                         -----------------------------
                             |                  |
[PDF::Zen]        <--|       V                  V
                     |   [PDF::Content]    <-- [PDF]   <-- [PDF::Grammar]
    [PDF::Lite]   <--|       ^          
                             |          
                         ---------------
                         [HTML::Canvas]   <--| [PDF::Style::Font]
                         [PDF::Style]     <--| [CSS::Declarations]
```

## Pure PDF Modules

### [PDF::Lite](https://github.com/p6-pdf/PDF-Lite-p6) - Focused on authoring and basic content manipulation only.

Lightweight subset of PDF::Zen.

### [PDF::Zen](https://github.com/p6-pdf/PDF-Zen-p6) - A general purpose high-level PDF manipulation library.

The aim is general purpose support for reading and writing PDF files, including Forms, Meta-data, Accessibility and Font manipulation. This module is at
a prototype stage.

## PDF/HTML Suite

PDF::Style[::Font], HTML::Canvas[::To::PDF] and CSS::Declarations are designed to work together for higher level HTML/CSS flavoured PDF creation.

### [HTML::Canvas](https://github.com/p6-pdf/HTML-Canvas-p6)

Implements the HTML5 Canvas 2D API. For simple text, graphics and images.

### [PDF::Style](https://github.com/p6-pdf/PDF-Style-p6)

A companion module to HTML::Canvas. Allows composition with HTML positioning and CSS Styling rules and box model.

### [CSS::Declarations](https://github.com/p6-css/CSS-Declarations-p6)

Top of the CSS tool-chain. An important companion to HTML::Canvas and PDF::Style.

## Low Level Modules

### [PDF::Content](https://github.com/p6-pdf/PDF-Content-p6) - Roles for manipulating text, graphics and images.

Put to work by PDF::Lite and (eventually) PDF::Zen.

### [PDF](https://github.com/p6-pdf/PDF-p6) - for PDF manipulation, including compression, encryption and reading and writing of PDF data.

The king-pin of the PDF tool-chain. Handles physical access to PDF's, including reading, writing, compression and encryption.

### [PDF::Grammar](https://github.com/p6-pdf/PDF-Grammr-p6)

A collection of grammars for parsing PDF elements and content

### [Lib::PDF](https://github.com/p6-pdf/libpdf-p6) library of decoding and encoding functions, etc.

An optional library of encoding and decoding routines, written in C for
performance. At this stage, only a few select filters are available.

## Status

### Released: PDF::Grammar, PDF, CSS::Declarations.

### Pending: PDF::Lite, PDF::Content

### Held Back: Lib::PDF

This module could really do with CPAN Testers style smoke testing. Also
would like to see more work on Rakudo JIT. It so far implements some of
the more obvious bottlenecks

### Experimental: HTML::Canvas::To::PDF, PDF::Style, PDF::Style::Font

These have helped to drive development of the above modules.

Fonts need to be developed a bit more. Could be we need a Font::FreeType module;
and to integrate Cairo glyph fonts.

Some possible overlap with p6-css projects. Could be we need a top-level
Style namespace with PDF and Cairo backends. Similar to structure of
HTML::Canvas (with HTML::Canvas::To::Cairo and HTML::Canvas::To::PDF
backends).

Possibly need a top-down markdown or POD rendering project io pull this
all together.

Todo:

- Complete README.md doco
- More source-level POD
- Work on building HTML/PDF from source/READMEs (ideally, not an absolute blocker)

Todo:

- More doco
- Look at Windows testing via Appveyor?

### Prototype: PDF::Zen, PDF::Render::Cairo

The start of a pretty big module. Mostly exists to keep the structure and
balance of the tool-chain on track. Just being regressed at this stage.
Some tests not working at the moment, due to precomp issues etc.

PDF::Render::Cairo is a renderer based on PDF::Zen. It's in the early
stages of development, but has been used to generate some simple, but
useful PDF previews.
