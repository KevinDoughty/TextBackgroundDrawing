TextBackgroundDrawing
=====================

This is a drop in fix for background drawing issues with NSLayoutManager.
For example you might notice text selection drawing, or
addAttribute:NSBackgroundColorAttributeName on NSTextStorage, or direct calls to
- (void)fillBackgroundRectArray:(NSRectArray)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(NSColor *)color
do not perform as expected, drawing wrong color or incorrectly or not at all.
No other modification to your code or project is required other than adding this category.

Screenshots at:
http://kxdx.org/text-background-drawing/