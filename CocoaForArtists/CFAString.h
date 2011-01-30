//
//  CFAString.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

/*
 eventually it might be nice to integrate with CFString, for drawing...
 advice from cocoa-dev: change method names, change CFA prefix...
 */

/*
 

 NEEEEEED
 to fix drawing to PDFContext...
 the position defaults to 0,0
 
 
 */

@interface CFAString : NSObject {
	NSString		*string;
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
-(CFAString *)substringFromIndex:(NSUInteger)index;
-(CFAString *)substringToIndex:(NSUInteger)index;
-(CFAString *)stringByReplacingOccurencesOfString:(id)aString withString:(id)bString;
-(NSArray *)componentsSeparatedByString:(id)aString;

-(BOOL)hasPrefix:(id)aString;
-(BOOL)hasSuffix:(id)aString;
-(void)capitalizedString;
-(void)lowercaseString;
-(void)uppercaseString;

-(int) length;

-(double)doubleValue;
-(float)floatValue;
-(int)intValue;
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
-(void)fill:(float)grey;
-(void)fill:(float)grey alpha:(float)alpha;
-(void)fillRed:(float)red green:(float)green blue:(float)blue;
-(void)fillRed:(float)red green:(float)green blue:(float)blue alpha:(float)a;
-(void)strokeColor:(id)color;
-(void)stroke:(float)grey;
-(void)stroke:(float)grey alpha:(float)alpha;
-(void)strokeRed:(float)red green:(float)green blue:(float)blue;
-(void)strokeRed:(float)red green:(float)green blue:(float)blue alpha:(float)a;
-(void)strokeWidth:(float)width;
-(void)underlineColor:(id)color;
-(void)underlineStyle:(int)style;
-(void)strikethroughColor:(id)color;
-(void)strikethroughStyle:(int)style;
-(void)backgroundColor:(id)color;
-(void)baselineOffset:(float)value;
-(void)kern:(float)value;

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
+(void)fill:(float)grey;
+(void)fill:(float)grey alpha:(float)alpha;
+(void)fillRed:(float)red green:(float)green blue:(float)blue;
+(void)fillRed:(float)red green:(float)green blue:(float)blue alpha:(float)a;
+(void)strokeColor:(id)color;
+(void)stroke:(float)grey;
+(void)stroke:(float)grey alpha:(float)alpha;
+(void)strokeRed:(float)red green:(float)green blue:(float)blue;
+(void)strokeRed:(float)red green:(float)green blue:(float)blue alpha:(float)a;
+(void)strokeWidth:(float)width;
+(void)underlineColor:(id)color;
+(void)underlineStyle:(int)style;
+(void)strikethroughColor:(id)color;
+(void)strikethroughStyle:(int)style;
+(void)backgroundColor:(id)color;
+(void)baselineOffset:(float)value;
+(void)kern:(float)value;
+(void)noFill;
+(void)noStroke;

+(void)beginDrawStringsToPDFContext:(CGContextRef)context;
+(void)endDrawStringsToPDFContext;

@property(readwrite, retain) NSString *string;
@property(readwrite, retain) NSMutableDictionary *attributes;
@end