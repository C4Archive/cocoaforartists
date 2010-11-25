//
//  CFATransform.m
//  CodeSamples
//
//  Created by Travis Kirton on 10-09-29.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import "CFATransform.h"

static CFATransform *cfaTransform;

@implementation CFATransform
NSAffineTransform *transform;

GENERATE_SINGLETON(CFATransform, cfaTransform);

-(id)_init {
	return self;
}

+(void)begin{
	[[NSGraphicsContext currentContext] saveGraphicsState];
	transform = [[NSAffineTransform transform] retain];
}

+(void)concat{
	[transform concat];
}

+(void)end {
	[transform release];
	transform = nil;
	[[NSGraphicsContext currentContext] restoreGraphicsState];
}

+(void)translateBy:(NSPoint)point {
	[self translateByX:point.x andY:point.y];
}

+(void)translateByX:(int)x andY:(int)y {
	[transform translateXBy:x yBy:y];
}

+(void)rotateByAngle:(float)angle {
	[transform rotateByDegrees:angle];
}
@end
