//
//  CFAString.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

/*
 advice from cocoa-dev: change method names, change CFA prefix...
 
 NOT TOO SERIOUS
 CFAttributedString objects have problems in drawing underlines and strikthrough.
 
 In particular, there are NO strikethrough options for drawing and the underline objects appear over top of one another.
 I wonder if Apple will fix these in the future... Not entirely essential...
 
 */

@interface CFAString : CFAObject {
	NSString			*string;
	NSMutableDictionary	*attributes;
}
/*
 Instance Methods
 */
-(id)initWithString:(id)aString;
-(id)initWithFormat:(NSString *)aFormatString, ...;
-(CFAString *)stringByAppendingString:(id)aString;
-(CFAString *)stringByAppendingFormat:(NSString *)aFormatString, ...;
-(CFAString *)substringWithRange:(NSRange)range;
-(CFAString *)substringFromIndex:(NSInteger)index;
-(CFAString *)substringToIndex:(NSInteger)index;
-(CFAString *)stringByReplacingOccurencesOfString:(id)aString withString:(id)bString;
-(NSArray *)componentsSeparatedByString:(id)aString;

-(BOOL)hasPrefix:(id)aString;
-(BOOL)hasSuffix:(id)aString;
-(void)capitalizedString;
-(void)lowercaseString;
-(void)uppercaseString;

-(NSInteger) length;

-(double)doubleValue;
-(CGFloat)floatValue;
-(NSInteger)intValue;
-(NSInteger)integerValue;
-(BOOL)boolValue;

-(void)drawAtPoint:(NSPoint)point;
-(void)drawAtPoint:(NSPoint)point withAttributes:(NSDictionary *)attribs;
-(void)drawInRect:(NSRect)rect;
-(void)drawInRect:(NSRect)rect withAttributes:(NSDictionary *)attribs;


-(NSSize)size;
-(NSSize)sizeWithAttributes:(NSDictionary *)attribs;

-(void)font:(id)font;

-(void)fillColor:(id)color;
-(void)fill:(CGFloat)grey;
-(void)fill:(CGFloat)grey alpha:(CGFloat)alpha;
-(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
-(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)a;
-(void)strokeColor:(id)color;
-(void)stroke:(CGFloat)grey;
-(void)stroke:(CGFloat)grey alpha:(CGFloat)alpha;
-(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
-(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)a;
-(void)strokeWidth:(CGFloat)width;
-(void)underlineColor:(id)color;
-(void)underlineStyle:(NSInteger)style;
-(void)strikethroughColor:(id)color;
-(void)strikethroughStyle:(NSInteger)style;
-(void)backgroundColor:(id)color;
-(void)baselineOffset:(CGFloat)value;
-(void)kern:(CGFloat)value;

-(void)noFill;
-(void)noStroke;

/*
 Class Methods
 */
+(CFAString *)stringWithString:(id)aString;
+(CFAString *)stringWithFormat:(NSString *)aFormatString, ...;

// change global settings in GlobalTypeAttributes
+(void)font:(id)font;
+(void)fillColor:(id)color;
+(void)fill:(CGFloat)grey;
+(void)fill:(CGFloat)grey alpha:(CGFloat)alpha;
+(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)a;
+(void)strokeColor:(id)color;
+(void)stroke:(CGFloat)grey;
+(void)stroke:(CGFloat)grey alpha:(CGFloat)alpha;
+(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)a;
+(void)strokeWidth:(CGFloat)width;
+(void)underlineColor:(id)color;
+(void)underlineStyle:(NSInteger)style;
+(void)strikethroughColor:(id)color;
+(void)strikethroughStyle:(NSInteger)style;
+(void)backgroundColor:(id)color;
+(void)baselineOffset:(CGFloat)value;
+(void)kern:(CGFloat)value;
+(void)noFill;
+(void)noStroke;

+(CFAString *)globalAttributes;

+(void)beginDrawStringsToPDFContext:(CGContextRef)context;
+(void)endDrawStringsToPDFContext;

+(NSString *)nsStringFromObject:(id)object;

@property(readwrite, retain) NSString *string;
@property(readwrite, retain) NSMutableDictionary *attributes;
@end