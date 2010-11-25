//
//  CFAColor.h
//  CFADevelop
//
//  Created by Travis Kirton on 10-09-13.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CFAColor : NSObject {
	@private
	CGFloat components[4];
}

+(NSColor*)colorFromIntValuesRed:(int)red green:(int)green blue:(int)blue;
+(NSColor*)colorFromIntValuesRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;

+(CGColorRef)cgColorFromIntValuesRed:(int)red green:(int)green blue:(int)blue;
+(CGColorRef)cgColorFromIntValuesRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;

-(id)initWithIntValuesRed:(int)red green:(int)green blue:(int)blue;
-(id)initWithIntValuesRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;

-(CGColorRef)cgColor;
-(NSColor *)nsColor;
@end
