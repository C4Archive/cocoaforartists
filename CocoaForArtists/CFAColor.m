//
//  CFAColor.m
//  Created by Travis Kirton
//

#import "CFAColor.h"

@implementation CFAColor

+(void)load {
	if(VERBOSELOAD) printf("CFAColor\n");
}

+(CFAColor *)colorWithGrey:(CGFloat)grey {
	return [self colorWithRed:grey green:grey blue:grey alpha:1.0f];
}

+(CFAColor *)colorWithGrey:(CGFloat)grey alpha:(CGFloat)alpha {
	return [self colorWithRed:grey green:grey blue:grey alpha:alpha];
}

+(CFAColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
	return [self colorWithRed:red green:green blue:blue alpha:1.0f];
}
																			
+(CFAColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	CFAColor *newColor = [[CFAColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
	return newColor;
}

+(NSColor *)colorFromObject:(id)aColor {
	NSColor *newColor;
	if ([aColor isKindOfClass:[NSColor class]]) {
		newColor = (NSColor *)aColor;
	} else if ([aColor isKindOfClass:[CFAColor class]]) {
		newColor = (NSColor *)[(CFAColor *)aColor nsColor];
	} else {
		CFALog(@"color object must be NSColor or CFAColor");
		return nil;
	}
	return newColor;
}

-(id)init {
	if(![super init]) {
		return nil;
	}

	//default to black
	color = [[NSColor blackColor] retain];
	return self;
}

-(id)initWithGrey:(CGFloat)grey {
	return [self initWithRed:grey green:grey blue:grey alpha:1.0f];
}

-(id)initWithGrey:(CGFloat)grey alpha:(CGFloat)alpha {
	return [self initWithRed:grey green:grey blue:grey alpha:alpha];
}

-(id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
	return [self initWithRed:red green:green blue:blue alpha:1.0f];
}

-(id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	[color release];
	color = [[NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha] retain];
	return self;
}

-(void)set {
	[color set];
}

-(CGColorRef)cgColor {
	return CGColorCreateGenericRGB([color redComponent], [color greenComponent], [color blueComponent], [color alphaComponent]);
}

-(NSColor *)nsColor {
	return color;
}

-(CGFloat)redComponent {
	return [color redComponent];
}

-(CGFloat)greenComponent {
	return [color greenComponent];
}

-(CGFloat)blueComponent {
	return [color blueComponent];
}


+(CGColorRef)NSColorToCGColor:(NSColor *)aColor {
	aColor = [aColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	CGFloat colorComponents[4];
	colorComponents[0] = [aColor redComponent];
	colorComponents[1] = [aColor greenComponent];
	colorComponents[2] = [aColor blueComponent];
	colorComponents[3] = [aColor alphaComponent];
	return CGColorCreate(CGColorSpaceCreateDeviceRGB(), colorComponents);
}
@end