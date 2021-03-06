//
//  CFAString.m
//  Created by Travis Kirton
//

#import "CFAString.h"
@interface CFAString (private)
CGContextRef pdfContext;
BOOL drawStringsToPDF = NO;
BOOL isClean;
-(NSColor *)colorFromObject:(id)color;
-(CFDictionaryRef)CFDictionaryRefFrom:(NSDictionary *)dictionary;
@end

@implementation CFAString

@synthesize string, attributes;

+(void)load {
	if(VERBOSELOAD) printf("CFAString\n");
}

-(id)init {
	if(![super init]){
		return nil;
	}
	return self;
}

-(id)initWithString:(id)aString {

	if(!(self = [super init])) {
		return nil;
	}
	if([aString isKindOfClass:[NSString class]]) {
		self.string = (NSString *)aString;
		self.attributes = [[[NSMutableDictionary alloc] initWithCapacity:0] retain];
	}
	else if ([aString isKindOfClass:[CFAString class]]) {
		self.string = ((CFAString *)aString).string;
		self.attributes = ((CFAString *)aString).attributes;
	}
	else {
		CFALog(@"Type is not CFAString or NSString");
		return nil;
	}
	return self;
}

-(id)initWithFormat:(NSString *)aFormatString, ... {
	NSString *finalString;

	va_list args;
	va_start (args, aFormatString);
		finalString = [[[NSString alloc] initWithFormat:aFormatString arguments:args] autorelease];
	va_end (args);
	
	return [self initWithString:finalString];
}

-(void)dealloc {
	[self setString:nil];
	[self setAttributes:nil];
	[super dealloc];
}

-(CFAString *)stringByAppendingString:(id)aString {
	NSString *newString;
	if([aString isKindOfClass:[NSString class]]) {
		newString = (NSString *)aString;
	}
	else if ([aString isKindOfClass:[CFAString class]]) {
		newString = ((CFAString *)aString).string;
	}
	else {
		CFALog(@"Type is not CFAString or NSString");
		return nil;
	}
	return [CFAString stringWithString:newString];
}

-(CFAString *)stringByAppendingFormat:(NSString *)aFormatString, ... {
	NSString *newString;
	
	va_list args;
	va_start (args, aFormatString);
	newString = [[[NSString alloc] initWithFormat:aFormatString arguments:args] autorelease];
	va_end (args);

	NSString *s = [self.string stringByAppendingString:newString];
	return [CFAString stringWithString:s];
}

-(NSInteger)length {
	return [self.string length];
}			

-(NSArray *)componentsSeparatedByString:(id)aString {
	NSString *separatorString;
	if([aString isKindOfClass:[NSString class]]) {
		separatorString = (NSString *)aString;
	}
	else if ([aString isKindOfClass:[CFAString class]]) {
		separatorString = ((CFAString *)aString).string;
	}
	else {
		CFALog(@"Type is not CFAString or NSString");
		return nil;
	}
	NSArray *components = [self.string componentsSeparatedByString:separatorString];
	NSMutableArray *newArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	for(NSString *s in components){
		[newArray addObject:[CFAString stringWithString:s]];
	}
	
	return (NSArray *)newArray;
}

-(CFAString *)stringByReplacingOccurencesOfString:(id)aString withString:(id)bString {
	NSString *firstString;

	if([aString isKindOfClass:[NSString class]]) {
		firstString = (NSString *)aString;
	}
	else if ([aString isKindOfClass:[CFAString class]]) {
		firstString = ((CFAString *)aString).string;
	}

	NSString *secondString;
	if([bString isKindOfClass:[NSString class]]) {
		secondString = (NSString *)bString;
	}
	else if ([bString isKindOfClass:[CFAString class]]) {
		secondString = ((CFAString *)bString).string;
	}
	
	NSString *newString = [self.string stringByReplacingOccurrencesOfString:firstString withString:secondString];
	return [CFAString stringWithString:newString];
}


-(CFAString *)substringFromIndex:(NSInteger)index {
	return [self substringWithRange:NSMakeRange(index, [self length]-index)];
}

-(CFAString *)substringToIndex:(NSInteger)index {
	return [self substringWithRange:NSMakeRange(0,index)];
}

-(CFAString *)substringWithRange:(NSRange)range {
	NSString *substring = [[self.string copy] substringWithRange:range];
	return [CFAString stringWithString:substring];
}

-(BOOL)hasPrefix:(id)aString {
	NSString *prefix;
	if([aString isKindOfClass:[NSString class]]) {
		prefix = (NSString *)aString;
	}
	else if ([aString isKindOfClass:[CFAString class]]) {
		prefix = ((CFAString *)aString).string;
	}
	return [self.string hasPrefix:prefix];
}

-(BOOL)hasSuffix:(id)aString {
	NSString *suffix;
	if([aString isKindOfClass:[NSString class]]) {
		suffix = (NSString *)aString;
	}
	else if ([aString isKindOfClass:[CFAString class]]) {
		suffix = ((CFAString *)aString).string;
	}
	return [self.string hasSuffix:suffix];
}

-(void)capitalizedString {
	self.string = [self.string capitalizedString];
}

-(void)uppercaseString {
	self.string = [self.string uppercaseString];
}

-(void)lowercaseString {
	self.string = [self.string lowercaseString];
}

-(double)doubleValue {
	return [self.string doubleValue];
}

-(CGFloat)floatValue {
	return [self.string floatValue];
}

-(NSInteger)intValue {
	return [self.string intValue];
}

-(NSInteger)integerValue {
	return [self.string integerValue];
}

-(BOOL)boolValue {
	return [self.string boolValue];
}

-(void)drawAtPoint:(NSPoint)point {
	NSDictionary *attribs;
	if([self.attributes count] == 0){
		attribs = [[CFAGlobalTypeAttributes sharedManager] attributes];
		[self drawAtPoint:point withAttributes:attribs];
		//CFALog(@"\n -- SharedManager Attributes At Draw-- \n %@ \n",[attribs description]);
	}
	else {
		[self drawAtPoint:point withAttributes:self.attributes];
		//CFALog(@"\n -- Instance Attributes At Draw-- \n %@ \n",[self.attributes description]);
	}
}

-(void)drawAtPoint:(NSPoint)point withAttributes:(NSDictionary *)attribs {
	[self.string drawAtPoint:point withAttributes:attribs];

	CFDictionaryRef cfAttribs = [[CFAGlobalTypeAttributes sharedManager] CFDictionaryRefFrom:attribs];
	
	if(drawStringsToPDF) {
		CFAttributedStringRef attributedString = CFAttributedStringCreate (kCFAllocatorDefault,
																		   (CFStringRef)self.string,
																		   cfAttribs);
		
		CTLineRef line = CTLineCreateWithAttributedString(attributedString);
				
		CGContextSetFillColorSpace(pdfContext,CGColorSpaceCreateDeviceRGB());
		NSColor *color = [[attribs objectForKey:NSForegroundColorAttributeName] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
		CGFloat components[4];
		[color getRed:&components[0] green: &components[1] blue: &components[2] alpha: &components[3]];		
		CGContextSetFillColor(pdfContext, components);	
		CGContextSaveGState(pdfContext);
		CGContextSetTextPosition(pdfContext,point.x,point.y);
		CTLineDraw(line,pdfContext);
		CGContextRestoreGState(pdfContext);
	}
	
	CFRelease(cfAttribs);
}

-(void)drawInRect:(NSRect)rect {
	if([self.attributes count] == 0) [self drawInRect:rect withAttributes:[[CFAGlobalTypeAttributes sharedManager] attributes]];
	else [self drawInRect:rect withAttributes:self.attributes];
}

-(void)drawInRect:(NSRect)rect withAttributes:(NSDictionary *)attribs {
	[self.string drawInRect:rect withAttributes:attribs];
}

-(NSSize)size {
	return [self.string sizeWithAttributes:self.attributes];
}

-(NSSize)sizeWithAttributes:(NSDictionary *)attribs {
	return [self.string sizeWithAttributes:attribs];
}

-(void)font:(id)font {
	NSFont *newFont;
	if([font isKindOfClass:[NSFont class]]) newFont = (NSFont *)font;
	else if([font isKindOfClass:[CFAFont class]]) newFont = ((CFAFont *)font).font;
	[self.attributes setObject:newFont forKey:NSFontAttributeName];
}

-(void)fill:(CGFloat)grey {
	[self fillRed:grey green:grey blue:grey alpha:1];
}

-(void)fill:(CGFloat)grey alpha:(CGFloat)alpha {
	[self fillRed:grey green:grey blue:grey alpha:alpha];
}

-(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
	[self fillRed:red green:green blue:blue alpha:1];
}

-(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
	NSColor *newColor = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
	[self fillColor:newColor];
}

-(void)fillColor:(id)color {
	[self.attributes setObject:[CFAColor colorFromObject:color] forKey:NSForegroundColorAttributeName];
	if ([self.attributes objectForKey:NSUnderlineStyleAttributeName] == nil) {
		[self.attributes setObject:[CFAColor colorFromObject:color] forKey:NSUnderlineColorAttributeName];
	}
	//CFALog(@"\n-- Instance Attributes AFTER FILL-- \n %@ \n",[self.attributes description]);
}

-(void)strokeColor:(id)color {
	[self.attributes setObject:[CFAColor colorFromObject:color] forKey:NSStrokeColorAttributeName];
}

-(void)stroke:(CGFloat)grey {
	[self strokeRed:grey green:grey blue:grey alpha:1];
}

-(void)stroke:(CGFloat)grey alpha:(CGFloat)alpha {
	[self strokeRed:grey green:grey blue:grey alpha:1];
}

-(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
	[self strokeRed:red green:green blue:blue alpha:1];
}

-(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
	NSColor *newColor = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
	[self.attributes setObject:newColor forKey:NSStrokeColorAttributeName];
}

-(void)strokeWidth:(CGFloat)width {
	[self.attributes setValue:[NSNumber numberWithFloat:-1*width] forKey:NSStrokeWidthAttributeName];
}

-(void)underlineColor:(id)color {
	[self.attributes setObject:[CFAColor colorFromObject:color] forKey:NSUnderlineColorAttributeName];
}

-(void)backgroundColor:(id)color {
	[self.attributes setObject:[CFAColor colorFromObject:color] forKey:NSBackgroundColorAttributeName];
}

-(void)strikethroughColor:(id)color {
	[self.attributes setObject:[CFAColor colorFromObject:color] forKey:NSStrikethroughColorAttributeName];
}

-(void)underlineStyle:(NSInteger)style {
	if(style == NONE) {
		[self.attributes removeObjectForKey:NSUnderlineStyleAttributeName];
		[self.attributes removeObjectForKey:NSUnderlineColorAttributeName];
	} else if (style == SINGLE || style == DOUBLE || style == THICK ) {
		[self.attributes setValue:[NSNumber numberWithInt:style] forKey:NSUnderlineStyleAttributeName];
		[self.attributes setObject:[self.attributes objectForKey:NSForegroundColorAttributeName]
							forKey:NSUnderlineColorAttributeName];
	} else {
		CFALog(@"underline style must be NONE, SINGLE, THICK, or DOUBLE) -> %d",style);
	}
}

-(void)strikethroughStyle:(NSInteger)style {
	if(style == NONE) {
		[self.attributes removeObjectForKey:NSStrikethroughStyleAttributeName];
		[self.attributes removeObjectForKey:NSStrikethroughColorAttributeName];
	} else if (style == SINGLE || style == DOUBLE || style == THICK ) {
		[self.attributes setValue:[NSNumber numberWithInt:style] forKey:NSStrikethroughStyleAttributeName];
	} else {
		CFALog(@"strikethrough style must be NONE, SINGLE, THICK, or DOUBLE) -> %d",style);
	}
}

-(void)baselineOffset:(CGFloat)value {
	if(value <= 0.0f) [self.attributes removeObjectForKey:NSBaselineOffsetAttributeName];
	[self.attributes setValue:[NSNumber numberWithFloat:value] forKey:NSBaselineOffsetAttributeName];
}

-(void)kern:(CGFloat)value {
	if(value <= 0.0f) [self.attributes removeObjectForKey:NSKernAttributeName];
	[self.attributes setValue:[NSNumber numberWithFloat:value] forKey:NSKernAttributeName];
}

-(void)noFill {
	[self.attributes removeObjectForKey:NSForegroundColorAttributeName];
}

-(void)noStroke {
	[self.attributes removeObjectForKey:NSStrokeWidthAttributeName];
	[self.attributes removeObjectForKey:NSStrokeColorAttributeName];
}


// change global settings in GlobalTypeAttributes
+(void)font:(id)font {
	NSFont *newFont;
	if([font isKindOfClass:[NSFont class]]) newFont = (NSFont *)font;
	else if([font isKindOfClass:[CFAFont class]]) newFont = ((CFAFont *)font).font;
	[[CFAGlobalTypeAttributes sharedManager] setObject:newFont forKey:NSFontAttributeName];
}

+(void)fill:(CGFloat)grey {
	[CFAString fillRed:grey green:grey blue:grey alpha:1.0f];
}

+(void)fill:(CGFloat)grey alpha:(CGFloat)alpha {
	[CFAString fillRed:grey green:grey blue:grey alpha:alpha];
}

+(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
	[CFAString fillRed:red green:green blue:blue alpha:1.0f];
}

+(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
	NSColor *newColor = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
	[CFAString fillColor:newColor];
}

+(void)fillColor:(id)color {
	NSColor *aColor = [CFAColor colorFromObject:color];
	[[CFAGlobalTypeAttributes sharedManager] setObject:aColor forKey:NSForegroundColorAttributeName];
	if ([[CFAGlobalTypeAttributes sharedManager] objectForKey:NSUnderlineStyleAttributeName] == nil) {
		[[CFAGlobalTypeAttributes sharedManager] setObject:[CFAColor colorFromObject:color] forKey:NSUnderlineColorAttributeName];
	}
	//CFALog(@"\n-- SharedManager Attributes At Fill-- \n %@ \n",[[CFAGlobalTypeAttributes sharedManager].attributes description]);
}

+(void)strokeColor:(id)color {
	[[CFAGlobalTypeAttributes sharedManager] setObject:[CFAColor colorFromObject:color] forKey:NSStrokeColorAttributeName];
}

+(void)stroke:(CGFloat)grey {
	[self strokeRed:grey green:grey blue:grey alpha:1];
}

+(void)stroke:(CGFloat)grey alpha:(CGFloat)alpha {
	[self strokeRed:grey green:grey blue:grey alpha:1];
}

+(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
	[self strokeRed:red green:green blue:blue alpha:1];
}

+(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
	NSColor *newColor = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
	[[CFAGlobalTypeAttributes sharedManager] setObject:newColor forKey:NSStrokeColorAttributeName];
}

+(void)strokeWidth:(CGFloat)width {
	if (width < 0.1f){
		width = 0.1f;
		NSLog(@"stroke width set to 0.1, it cannot be smaller than this");
	}
	[[CFAGlobalTypeAttributes sharedManager] setValue:[NSNumber numberWithFloat:width] forKey:NSStrokeWidthAttributeName];
}

+(void)underlineColor:(id)color {
	[[CFAGlobalTypeAttributes sharedManager] setObject:[CFAColor colorFromObject:color] forKey:NSUnderlineColorAttributeName];
}

+(void)backgroundColor:(id)color {
	[[CFAGlobalTypeAttributes sharedManager] setObject:[CFAColor colorFromObject:color] forKey:NSBackgroundColorAttributeName];
}

+(void)strikethroughColor:(id)color {
	[[CFAGlobalTypeAttributes sharedManager] setObject:[CFAColor colorFromObject:color] forKey:NSStrikethroughColorAttributeName];
}

+(void)underlineStyle:(NSInteger)style {
	if(style == NONE) {
		[[CFAGlobalTypeAttributes sharedManager] removeObjectForKey:NSUnderlineStyleAttributeName];
		[[CFAGlobalTypeAttributes sharedManager] removeObjectForKey:NSUnderlineColorAttributeName];
	}
	if(style == SINGLE || style == DOUBLE || style == THICK ) {
		[[CFAGlobalTypeAttributes sharedManager] setValue:[NSNumber numberWithInt:style] forKey:NSUnderlineStyleAttributeName];
	} else {
		CFALog(@"underline style must be NONE, SINGLE, THICK, or DOUBLE) -> %d",style);
	}

}

+(void)strikethroughStyle:(NSInteger)style {
	if(style == NONE) {
		[[CFAGlobalTypeAttributes sharedManager] removeObjectForKey:NSStrikethroughStyleAttributeName];
		[[CFAGlobalTypeAttributes sharedManager] removeObjectForKey:NSStrikethroughColorAttributeName];
	}
	else if(style == SINGLE || style == DOUBLE || style == THICK ) {
		[[CFAGlobalTypeAttributes sharedManager] setValue:[NSNumber numberWithInt:style] forKey:NSStrikethroughStyleAttributeName];
	} else {
		CFALog(@"strikethrough style must be NONE, SINGLE, THICK, or DOUBLE) -> %d",style);
	}
}

+(void)baselineOffset:(CGFloat)value {
	if(value <= 0.0f) [[CFAGlobalTypeAttributes sharedManager] removeObjectForKey:NSBaselineOffsetAttributeName];
	[[CFAGlobalTypeAttributes sharedManager] setValue:[NSNumber numberWithFloat:value] forKey:NSBaselineOffsetAttributeName];
}

+(void)kern:(CGFloat)value {
	if(value <= 0.0f) [[CFAGlobalTypeAttributes sharedManager] removeObjectForKey:NSKernAttributeName];
	[[CFAGlobalTypeAttributes sharedManager] setValue:[NSNumber numberWithFloat:value] forKey:NSKernAttributeName];
}

+(void)noFill {
	[[CFAGlobalTypeAttributes sharedManager] removeObjectForKey:NSForegroundColorAttributeName];
}

+(void)noStroke {
	[[CFAGlobalTypeAttributes sharedManager] removeObjectForKey:NSStrokeWidthAttributeName];
	[[CFAGlobalTypeAttributes sharedManager] removeObjectForKey:NSStrokeColorAttributeName];
}

+(CFAString *)stringWithString:(id)aString {
	return [[[CFAString alloc] initWithString:aString] autorelease];
}

+(CFAString *)stringWithFormat:(NSString *)aFormatString, ... {
	NSString *finalString;
	
	va_list args;
	va_start (args, aFormatString);
	finalString = [[[NSString alloc] initWithFormat:aFormatString arguments:args] autorelease];
	va_end (args);
	
	return [[CFAString stringWithString:finalString] autorelease];	
}

+(void)beginDrawStringsToPDFContext:(CGContextRef)context {
	CFALog(@"beginDrawStringsToPDFContext");
	pdfContext = context;
	CGContextRetain(pdfContext);
	drawStringsToPDF = YES;
	isClean = NO;
}

+(void)endDrawStringsToPDFContext {
	drawStringsToPDF = NO;
	CGContextRelease(pdfContext);
	isClean = YES;
	CFALog(@"endDrawStringsToPDFContext");
}

+(CFAString *)globalAttributes {
	return [[CFAGlobalTypeAttributes sharedManager] description];
}

-(NSString *)description {
	return self.string;
}

+(NSString *)nsStringFromObject:(id)object {
	if([object isKindOfClass:[NSString class]]) {
		return (NSString *)object;
	} else if ([object isKindOfClass:[CFAString class]]) {
		return ((CFAString *)object).string;
	}
	CFALog(@"object must be CFAString or NSString");
	return nil;
}

@end
