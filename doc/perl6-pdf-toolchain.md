# Perl 6 PDF Tool-chain Overview

## Table of Contents

- [SECTION I: Introduction](#section-i-introduction)
   - [Modules Overview](#modules-overview)
       - [PDF Modules](#pdf-modules)
       - [Styling Modules](#styling-modules)
       - [Low Level Modules](#low-level-modules)
   - [Status](#status)
       - [Released: PDF::Grammar, PDF, CSS::Declarations.](#released-pdfgrammar-pdf-cssdeclarations)
       - [Pending: PDF::API6, PDF::Lite, PDF::Content](#pending-pdfapi6-pdflite-pdfcontent)
       - [Held Back: Lib::PDF](#held-back-libpdf)
       - [Experimental: HTML::Canvas::To::PDF, PDF::Style, PDF::Style::Font](#experimental-htmlcanvastopdf-pdfstyle-pdfstylefont)
   - [Alternatives](#alternatives)
       - [Cairo](#cairo)
- [SECTION II:  PDF Layers](#section-ii-pdf-layers)
   - [PDF (layer I - data)](#pdf-layer-i---data)
   - [PDF::Lite (layer II - graphics)](#pdflite-layer-ii---graphics)
       - [Graphics](#graphics)
       - [High Level Graphics (PDF::Content)](#high-level-graphics-pdfcontent)
       - [Overview](#overview)
       - [Images & Forms](#images--forms)
       - [Paths and Painting](#paths-and-painting)
       - [Patterns and Colors](#patterns-and-colors)
   - [PDF::API6 (layer III - auxillary)](#pdfapi6-layer-iii---auxillary)
- [SECTION III: Auxillary Modules](#section-iii-auxillary-modules)
   - [PDF::Style](#pdfstyle)
   - [HTML::Canvas::To::PDF](#htmlcanvastopdf)
   - [CSS::Declarations](#cssdeclarations)
- [SECTION IV: Low Level Modules](#section-iv-low-level-modules)
   - [PDF](#pdf)
   - [PDF::Grammar](#pdfgrammar)
   - [PDF::Content](#pdfcontent)
   - [Lib::PDF](#libpdf)
- [APPENDIX: Graphics Operators and Variables](#appendix-graphics-operators-and-variables)
   - [Appendix I: Graphics](#appendix-i-graphics)
       - [Graphic Operators](#graphic-operators)
       - [Graphics State](#graphics-state)
       - [Text Operators](#text-operators)
       - [Path Construction](#path-construction)
       - [Path Painting Operators](#path-painting-operators)
       - [Path Clipping](#path-clipping)
       - [Graphics Variables](#graphics-variables)
   - [Appendix II: TODO](#appendix-ii-todo)
       - [Fonts](#fonts)
       - [Pod::To::PDF](#podtopdf)
   - [Appendix III: Experimental Components](#appendix-iii-experimental-components)
       - [PDF::Zen](#pdfzen)
       - [PDF::Render::Cairo](#pdfrendercairo)

# SECTION I: Introduction

This document overviews the Perl 6 PDF Tool-chain, including PDF::API6, PDF::Lite. Also covered are the styling modules HTML::Canvas and PDF::Style.

Both this documentation and the PDF tool-chain modules are in the early stages of development and are expected to grow together as the tool-chain matures.

## Modules Overview

here's a quick run-down of the tool-chain modules (top to bottom):
```
                                [Lib::PDF]
                         -----------------------------
    [PDF::API6]              |                  |
         |           |       V                  V
         V           |   [PDF::Content]    <-- [PDF]   <-- [PDF::Grammar]
    [PDF::Lite]   <--|       ^          
                             |          
                         ---------------
                         [HTML::Canvas]   <--| [PDF::Style::Font]
                         [PDF::Style]     <--| [CSS::Declarations]
```

### PDF Modules

#### [PDF::Lite](https://github.com/p6-pdf/PDF-Lite-p6)

A minimalist module for manipulating PDF documents. Focused on authoring and basic content manipulation only.

#### [PDF::API6](https://github.com/p6-pdf/PDF-API6-p6)

Inherits from, and further extends PDF::Lite

The aim is general purpose support for reading and writing PDF files, including Forms, Meta-data, Accessibility and Font manipulation. This module is at
a prototype stage.

### Styling Modules

PDF::Style, HTML::Canvas::To::PDF and CSS::Declarations are optional modules for HTML and CSS driven PDF creation.

#### [HTML::Canvas::To::PDF](https://github.com/p6-pdf/HTML-Canvas-p6)

Implements the HTML5 Canvas 2D API. For simple text, graphics and images.

```
use v6;
# Create a simple Canvas. Save as PDF

use PDF::Lite;
use HTML::Canvas;
use HTML::Canvas::To::PDF;

my HTML::Canvas $canvas .= new;

# render to a PDF page
my PDF::Lite $pdf .= new;
my $gfx = $pdf.add-page.gfx;
my $feed = HTML::Canvas::To::PDF.new: :$gfx, :$canvas;

$canvas.context: -> \ctx {
    ctx.save; {
        ctx.fillStyle = "orange";
        ctx.fillRect(10, 10, 50, 50);

        ctx.fillStyle = "rgba(0, 0, 200, 0.3)";
        ctx.fillRect(35, 35, 50, 50);
    }; ctx.restore;

    ctx.font = "18px Arial";
    ctx.fillText("Hello World", 40, 75);
}

# save canvas as PDF
$pdf.save-as: "t/canvas-demo.pdf";
```

#### [PDF::Style](https://github.com/p6-pdf/PDF-Style-p6)

Allows composition with HTML positioning and CSS Styling rules and box model. Text. Images and HTML::Canvas elements are positioned onto a view-port (class PDF::Style::Viewport). The view-port is then rendered to a PDF Graphical object; a page, XObject form or pattern.

##### Styled Text

```
use v6;
use PDF::Lite;
use PDF::Style::Viewport;
use PDF::Style::Element;
use CSS::Declarations;
use CSS::Declarations::Units :pt, :ops;

my $pdf = PDF::Lite.new;
my $vp = PDF::Style::Viewport.new: :width(420pt), :height(595), :style("background-color: blue; opacity: 0.2;");
my $page = $vp.add-page($pdf);

my $css = CSS::Declarations.new: :style("font-family:Helvetica; width:250pt; height:80pt; top:20pt; left:20pt; border: 1pt dashed green; padding: 2pt");

my $text = q:to"--ENOUGH!!--".lines.join: ' ';
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
    ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.
    --ENOUGH!!--

my PDF::Style::Element $elem = $vp.element( :$text, :$css );

$elem.render($page);
$pdf.save-as: "t/example.pdf";
```

##### Styled Forms and Images

```
use PDF::Style::Viewport;
use CSS::Declarations;
use PDF::Lite;

# also dump to HTML, for comparison

my $vp = PDF::Style::Viewport.new;
my $css = CSS::Declarations.new: :style("font-family:Helvetica; height:250pt; position:absolute; top:20pt; left:20pt; border: 5px solid rgba(0,128,0,.2)");
my @Html = '<html>', '<body>', $vp.html-start;

my $pdf = PDF::Lite.new;
my $page = $vp.add-page($pdf);

my $image = "t/images/snoopy-happy-dance.jpg";

my $elem = $vp.element( :$css, :$image );
$elem.render($page);
$pdf.save-as: "test.pdf";
```

### Low Level Modules

#### [PDF::Content](https://github.com/p6-pdf/PDF-Content-p6) - Roles for manipulating text, graphics and images.

Put to work by PDF::Lite and PDF::API6.

#### [PDF](https://github.com/p6-pdf/PDF-p6) - for PDF manipulation, including compression, encryption and reading and writing of PDF data.

The king-pin of the PDF tool-chain. Handles physical access to PDF files, including reading, writing, compression and encryption.

#### [PDF::Grammar](https://github.com/p6-pdf/PDF-Grammr-p6)

A collection of grammars for parsing PDF elements and content

#### [Lib::PDF](https://github.com/p6-pdf/libpdf-p6) library of decoding and encoding functions, etc.

An optional library of encoding and decoding routines, written in C for
performance. At this stage, only a few select filters are available.

## Status

### Released: PDF::Grammar, PDF, CSS::Declarations.

### Pending: PDF::API6, PDF::Lite, PDF::Content

### Held Back: Lib::PDF

This module could really do with CPAN Testers style smoke testing. Also
would like to see more work on Rakudo JIT. It so far implements some of
the more obvious bottlenecks

### Experimental: HTML::Canvas::To::PDF, PDF::Style, PDF::Style::Font

These have helped to drive development of the above modules.

Fonts need to be developed a bit more. Could be we need a Font::FreeType module;
and to integrate Cairo glyph fonts.

Some possible overlap with p6-css projects. Could be we need a top-level
Style name-space with PDF and Cairo back-ends. Similar to structure of
HTML::Canvas (with HTML::Canvas::To::Cairo and HTML::Canvas::To::PDF
back-ends).

Possibly need a top-down markdown or POD rendering project to pull this all together.


## Alternatives

### Cairo

# SECTION II:  PDF Layers

## PDF (layer I - data)

PDF is the lowest level module. This allows physical access to the PDF for reading, update and writing. 

## PDF::Lite (layer II - graphics)

### Graphics

The [PDF::Content] module implements the PDF Graphics model, including a high-level view of variables and graphics operators.

### High Level Graphics (PDF::Content)

### Overview

#### Text, Fonts and Text Blocks

.say, .print, .text-blocks

### Images & Forms

.do

### Paths and Painting

.paint

### Patterns and Colors



## PDF::API6 (layer III - auxiliary)



# SECTION III: Supplementary Modules

## PDF::Style

## HTML::Canvas::To::PDF

## CSS::Declarations


# SECTION IV: Low Level Modules

## PDF::Grammar

## PDF::Content

## Lib::PDF



## Appendix II: TODO

### Fonts
### Pod::To::PDF

## Appendix III: Experimental Components

As much as anything these modules exist to exercise the rest of the tool-chain

### PDF::Zen

### PDF::Render::Cairo


