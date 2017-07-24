# The Perl 6 PDF Tool-chain

## Table of Contents

   - [1. Introduction](#1-introduction)
   - [2. Overview](#2-overview)
       - [PDF Modules](#pdf-modules)
       - [PDF/HTML Suite](#pdfhtml-suite)
       - [Low Level Modules](#low-level-modules)
       - [Status](#status)
       - [Alternatives](#alternatives)
   - [3. PDF Manipulation Modules](#3-pdf-manipulation-modules)
       - [PDF::Lite](#pdflite)
       - [PDF::API6](#pdfapi6)
   - [4. The PDF Graphics Model xx](#4-the-pdf-graphics-model)
       - [Graphics Summary](#graphics-summary)
   - [5. CSS and HTML Flavored Composition](#5-css-and-html-flavored-composition)
   - [98 .Low level Modules](#98-low-level-modules)
   - [99. Todo](#99-todo)
       - [Experimental Components](#experimental-components)

## 1. Introduction

This is the documentation for the Perl 6 PDF Tool-chain.

It overviews the modules that comprise the tool-chain and gives a basic background and references to the PDF standard where needed.

Both this documentation and the PDF tool-chain are in the early stages of development and are expected to grow together as the tool-chain matures.

## 2. Overview

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

#### [PDF::Lite](https://github.com/p6-pdf/PDF-Lite-p6) - Focused on authoring and basic content manipulation only.

#### [PDF::API6](https://github.com/p6-pdf/PDF-API6-p6) - Inherits from, and further extends PDF::Lite

The aim is general purpose support for reading and writing PDF files, including Forms, Meta-data, Accessibility and Font manipulation. This module is at
a prototype stage.

### PDF/HTML Suite

PDF::Style[::Font], HTML::Canvas[::To::PDF] and CSS::Declarations are designed to work together for higher level HTML/CSS flavoured PDF creation.

#### [HTML::Canvas](https://github.com/p6-pdf/HTML-Canvas-p6)

Implements the HTML5 Canvas 2D API. For simple text, graphics and images.

#### [PDF::Style](https://github.com/p6-pdf/PDF-Style-p6)

A companion module to HTML::Canvas. Allows composition with HTML positioning and CSS Styling rules and box model.

#### [CSS::Declarations](https://github.com/p6-css/CSS-Declarations-p6)

Top of the CSS tool-chain. An important companion to HTML::Canvas and PDF::Style.

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

### Status

#### Released: PDF::Grammar, PDF, CSS::Declarations.

#### Pending: PDF::API6, PDF::Lite, PDF::Content

#### Held Back: Lib::PDF

This module could really do with CPAN Testers style smoke testing. Also
would like to see more work on Rakudo JIT. It so far implements some of
the more obvious bottlenecks

#### Experimental: HTML::Canvas::To::PDF, PDF::Style, PDF::Style::Font

These have helped to drive development of the above modules.

Fonts need to be developed a bit more. Could be we need a Font::FreeType module;
and to integrate Cairo glyph fonts.

Some possible overlap with p6-css projects. Could be we need a top-level
Style name-space with PDF and Cairo back-ends. Similar to structure of
HTML::Canvas (with HTML::Canvas::To::Cairo and HTML::Canvas::To::PDF
back-ends).

Possibly need a top-down markdown or POD rendering project to pull this
all together.


### Alternatives

#### Cairo

## 3. PDF Manipulation Modules

### PDF::Lite

### PDF::API6



## 4. The PDF Graphics Model

The [PDF::Content] module implements the PDF Graphics model, including a high-level view of variables and graphics operators.

### Graphics Summary

#### Graphics Operators

Variable | Description | Domain | Default
--- | --- | --- | ---
LineWidth | Stroke line-width | 0.0 .. 1.0| 1.0
LineCap | Line-ending style | PDF::Content::Ops :LineCap|LineCap::ButtCaps (0)
LineJoin | Line-joining style | PDF::Content::Ops::LineJoin | LineJoin::MitreJoin (0)
DashPattern | Line-dashing pattern | [[$on-1, $off-1, ...], $phase] | [[], 0]
StrokeColor | Stroke colorspace and color | :DeviceRGB[$r,$g,$b], :DeviceCMYK[$c,$m,$y,$k], DeviceGray[$a], ... etc| :DeviceGray[0.0]
FillColor | Fill colorspace and color | (same as stroke-color)  | :DeviceGray[0.0]
RenderingIntent | Color Adjustments | 'AbsoluteColorimetric', 'RelativeColormetric', 'Saturation', 'Perceptual' | 'RelativeColormetric'

...

#### Graphics Variables

...

## 5. CSS and HTML Flavored Composition

#### PDF::Style

#### HTML::Canvas

#### CSS::Declarations



## 98 .Low level Modules

#### PDF

#### PDF::Grammar

#### PDF::Content

#### Lib::PDF


## 99. Todo

#### Fonts
#### Pod::To::PDF

### Experimental Components

As much as anything these modules exist to exercise the rest of the tool-chain

#### PDF::Zen

#### PDF::Render::Cairo

