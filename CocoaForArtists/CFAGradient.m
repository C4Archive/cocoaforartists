//
//  CFAGradient.m
//  Created by Travis Kirton
//

#import "CFAGradient.h"

@implementation CFAGradient

-(id)init {
	if(![super init]) return nil;
	return self;
}

+(void)linearGradientFromPointA:(NSPoint)pointA toPointB:(NSPoint)pointB usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB inShape:(CGMutablePathRef)shape{	
	const void *colors[2] = {[colorA cgColor],[colorB cgColor]};	
	
	CFArrayRef colorArrayRef = CFArrayCreate(kCFAllocatorDefault, colors, 2, &kCFTypeArrayCallBacks);	
	
	CGFloat locations[2] = {0.0,1.0};
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear), colorArrayRef, locations);
	
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	CGContextAddPath(context, shape);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, NSPointToCGPoint(pointA), NSPointToCGPoint(pointB), 0);
	CGContextRestoreGState(context);
}

+(void)linearGradientFromPointA:(NSPoint)pointA toPointB:(NSPoint)pointB toPointC:(NSPoint)pointC usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB andColorC:(CFAColor *)colorC inShape:(CGMutablePathRef)shape{	
	const void *colors[3] = {[colorA cgColor],[colorB cgColor],[colorC cgColor]};	
	CFArrayRef colorArrayRef = CFArrayCreate(kCFAllocatorDefault, colors, 3, &kCFTypeArrayCallBacks);	

	CGFloat midDist = [CFAMath distFromX:pointA.x Y:pointA.y toX:pointB.x Y:pointB.y];
	CGFloat maxDist = [CFAMath distFromX:pointA.x Y:pointA.y toX:pointC.x Y:pointC.y];
	CGFloat locations[3] = {0.0,midDist/maxDist,1.0};
	
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear), colorArrayRef, locations);
	
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	CGContextAddPath(context, shape);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, NSPointToCGPoint(pointA), NSPointToCGPoint(pointC), 0);
	CGContextRestoreGState(context);	
	
}
@end