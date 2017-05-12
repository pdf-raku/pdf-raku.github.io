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
[PDF::Doc]        <--|       V                  V
                     |   [PDF::Content]    <-- [PDF]   <-- [PDF::Grammar]
    [PDF::Lite]   <--|       ^          
                             |          
                         ---------------
                         [HTML::Canvas]   <--| [PDF::Style::Font]
                         [PDF::Style]     <--| [CSS::Declarations]
```

## High Level Modules

### [PDF::Doc](https://github.com/p6-pdf/PDF-Doc-p6) - A general purpose high-level PDF manipulation manipulation library.

The aim is general purpose manipulation of a wide range of PDF features, including Forms, Meta-data, Accessibility and Font manipulation. This module is at
a prototype stage.

### [PDF::Lite](https://github.com/p6-pdf/PDF-Lite-p6) - Focused on content manipulation only.

Less structured lightweight alternative to PDF::Doc.

### [HTML::Canvas]

Implements the HTML5 Canvas 2D API. For simple text, graphics and images.

### [PDF::Style]

A companion module to PDF::Style. Allows composition with HTML positioning and CSS Styling rules and box model.

### [CSS::Declarations]

Top of the CSS tool-chain. An important companion to HTML::Canvas and PDF::Style.

## Low Level Modules

### [PDF::Content](https://github.com/p6-pdf/PDF-Content-p6) - Roles for manipulating text, graphics and images.

Put to work by PDF::Lite and (eventually) PDF::Doc

### [PDF](https://github.com/p6-pdf/PDF-p6) - for PDF manipulation, including compression, encryption and reading and writing of PDF data.

The king-pin of the PDF tool-chain. Handles physical access to PDF's, including reading, writing, compression and encryption.

### [PDF::Grammar]

A collection of grammars for parsing PDF elements and content

### [Lib::PDF] library of decoding and encoding functions, etc.

An optional library of encoding and decoding routines, written in C for
performance. At this stage, only a few select filters are available.

## Status

### Released: PDF::Grammar, PDF, CSS::Declarations.

### Pending: PDF::Lite, PDF::Content, HTML::Canvas, PDF::Style, PDF::Style::Font

This set of modules are reasonably stable. The main release blocker is documentation, in particular, for PDF::Lite.

I'm in a little bit of a quandary as to whether to go down the mark-down or
POD route. Flavoring markdown at the moment.

Todo:

- Complete README.md doco
- More source-level POD
- Work on building HTML/PDF from source/READMEs (ideally, not an absolute blocker)

### Held Back: Lib::PDF

This module could really do with CPAN Testers style smoke testing. Also
would like to see more work on Rakudo JIT. It so far implements some of
the more obvious bottlenecks

Todo:

- More doco
- Look at Windows testing via Appveyor?

### Prototype: PDF::Doc

The start of a pretty big module. Just being regressed at this stage.
Some tests not working at the moment, due to precomp issues etc.