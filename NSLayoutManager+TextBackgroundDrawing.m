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

#import "NSLayoutManager+TextBackgroundDrawing.h"
#import <objc/runtime.h>

@implementation NSLayoutManager (TextBackgroundDrawing)

void kxdxSwizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
		method_exchangeImplementations(origMethod, newMethod);
}

+(void)load {
    kxdxSwizzle(self, @selector(fillBackgroundRectArray:count:forCharacterRange:color:), @selector(sleightOfHandLayoutManagerSwizzleFillBackgroundRectArray:count:forCharacterRange:color:));
}

- (void)sleightOfHandLayoutManagerSwizzleFillBackgroundRectArray:(NSRectArray)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(NSColor *)color {
    NSRange theGlyphRange = [self glyphRangeForCharacterRange:charRange actualCharacterRange:nil];
    NSUInteger theEnd = NSMaxRange(theGlyphRange);
    while (theGlyphRange.location < theEnd) { // If for some reason the glyph range spans multiple text containers, only one of them can be drawn at any given time, but I still need to determine if the text view has focus and don't know which I'm drawing in. This extra effort is not necessary if glyph range is guaranteed to be fully in one text container.
        //NSLog(@"fillBackground glyphRange:%@; color:%@;",NSStringFromRange(theGlyphRange),color);
        NSRange nextRange;
        NSTextContainer *theTextContainer = [self textContainerForGlyphAtIndex:theGlyphRange.location effectiveRange:&nextRange];
        NSColor *theCorrectColor;
        //BOOL isFirstResponder = [self layoutManagerOwnsFirstResponderInWindow:theTextContainer.textView.window]; // If text view loses focus, this is incorrect until there is a change, perhaps when glyphs are laid out again.
        BOOL isFirstResponder = ([theTextContainer.textView.window firstResponder] == theTextContainer.textView);
        if (isFirstResponder) theCorrectColor = [NSColor selectedTextBackgroundColor];
        else theCorrectColor = [NSColor secondarySelectedControlColor];
        [theCorrectColor set]; // Doesn't seem necessary, but docs say the passed color is for informational purposes only, and the correct color is already set in the graphics context. Perhaps the passed color is actually set in the default implementation.
        [self sleightOfHandLayoutManagerSwizzleFillBackgroundRectArray:rectArray count:rectCount forCharacterRange:charRange color:theCorrectColor];
        NSUInteger theMaxRange = MIN(NSMaxRange(nextRange),theEnd);
        theGlyphRange = NSMakeRange(theMaxRange, theEnd-theMaxRange);
    }
    [color set]; // Docs say you must restore color.
}
@end
