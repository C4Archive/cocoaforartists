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
	NSColor *color;
}

+(CFAColor *)colorWithGrey:(CGFloat)grey;
+(CFAColor *)colorWithGrey:(CGFloat)grey alpha:(CGFloat)alpha;
+(CFAColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+(CFAColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

-(id)initWithGrey:(CGFloat)grey;
-(id)initWithGrey:(CGFloat)grey alpha:(CGFloat)alpha;
-(id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
-(id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

-(void)set;

-(CGColorRef)cgColor;
-(NSColor *)nsColor;

@end
