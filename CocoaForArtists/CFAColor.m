//
//  CFAColor.m
//  CFADevelop
//
//  Created by Travis Kirton on 10-09-13.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

/* WHAT THE FUCK HAVE I DONE TO COLORS???? */

#import "CFAColor.h"

@implementation CFAColor

+(void)load {
	if(VERBOSELOAD) printf("CFAColor\n");
}

-(id)init {
	return self;
}

+(NSColor*)colorFromIntValuesRed:(int)red green:(int)green blue:(int)blue {
	return [self colorFromIntValuesRed:red green:green blue:blue alpha:255];
}

+(NSColor*)colorFromIntValuesRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha{
	return [NSColor colorWithCalibratedRed:FLOAT_FROM_255(red) green:FLOAT_FROM_255(green) blue:FLOAT_FROM_255(blue) alpha:FLOAT_FROM_255(alpha)];
}

+(CGColorRef)cgColorFromIntValuesRed:(int)red green:(int)green blue:(int)blue {
	return [self cgColorFromIntValuesRed:red green:green blue:blue alpha:255];
}

+(CGColorRef)cgColorFromIntValuesRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha {
	return CGColorCreateGenericRGB(FLOAT_FROM_255(red),FLOAT_FROM_255(green),FLOAT_FROM_255(blue),FLOAT_FROM_255(alpha));
}

-(id)initWithIntValuesRed:(int)red green:(int)green blue:(int)blue {
	return [self initWithIntValuesRed:red green:green blue:blue alpha:255];
}

-(id)initWithIntValuesRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha {
	components[0] = FLOAT_FROM_255(red);
	components[1] = FLOAT_FROM_255(green);
	components[2] = FLOAT_FROM_255(blue);
	components[3] = FLOAT_FROM_255(alpha);
	return self;
}

-(CGColorRef)cgColor {
	return CGColorCreateGenericRGB(components[0], components[1], components[2], components[3]);
}

-(NSColor *)nsColor {
	return [NSColor colorWithCalibratedRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
}
@end