/*
The MIT License (MIT)

Copyright (c) 2014 Kevin Doughty

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// This is a drop in fix for background drawing issues with NSLayoutManager.
// For example you might notice text selection drawing, or
// addAttribute:NSBackgroundColorAttributeName on NSTextStorage, or direct calls to
// - (void)fillBackgroundRectArray:(NSRectArray)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(NSColor *)color
// do not perform as expected, drawing wrong color or incorrectly or not at all.
// No other modification to your code or project is required other than adding this category.

#import <Cocoa/Cocoa.h>

@interface NSLayoutManager (TextBackgroundDrawing)

@end
