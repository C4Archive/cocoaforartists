//
//  CFAGradient.m
//  Created by Travis Kirton
//

#import "CFAGradient.h"

@implementation CFAGradient

+(void)load {
	if(VERBOSELOAD) printf("CFAGradient\n");
}

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

	CGFloat midDist = [CFAVector distanceBetweenA:pointA andB:pointB];
	CGFloat maxDist = [CFAVector distanceBetweenA:pointA andB:pointC];
	CGFloat locations[3] = {0.0,midDist/maxDist,1.0};
	
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear), colorArrayRef, locations);
	
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	CGContextAddPath(context, shape);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, NSPointToCGPoint(pointA), NSPointToCGPoint(pointC), 0);
	CGContextRestoreGState(context);	
	
}

+(void)radialGradientFromCenter:(NSPoint)center toRadiusA:(CGFloat)radiusA andRadiusB:(CGFloat)radiusB usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB inShape:(CGMutablePathRef)shape {
	const void *colors[2] = {[colorA cgColor],[colorB cgColor]};
	CFArrayRef colorArrayRef = CFArrayCreate(kCFAllocatorDefault, colors, 2, &kCFTypeArrayCallBacks);
	
	CGFloat locations[2] = {0.0,1.0};
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear), colorArrayRef, locations);
	
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	CGContextAddPath(context, shape);
	CGContextClip(context);
	CGContextDrawRadialGradient(context, gradient, NSPointToCGPoint(center), radiusA, NSPointToCGPoint(center), radiusB, 0);
	CGContextRestoreGState(context);
}

+(void)radialGradientFromCenter:(NSPoint)center toRadiusA:(CGFloat)radiusA andRadiusB:(CGFloat)radiusB andRadiusC:(CGFloat)radiusC usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB andColorC:(CFAColor *)colorC inShape:(CGMutablePathRef)shape {
	const void *colors[3] = {[colorA cgColor],[colorB cgColor],[colorC cgColor]};
	
	CFArrayRef colorArrayRef = CFArrayCreate(kCFAllocatorDefault, colors, 3, &kCFTypeArrayCallBacks);
	
	NSPoint outerB = NSMakePoint(center.x+radiusB, center.y+radiusB);
	CGFloat midDist = [CFAVector distanceBetweenA:center andB:outerB]; //distFromX:center.x Y:center.y toX:center.x+radiusB Y:center.y+radiusB];
	
	NSPoint outerC = NSMakePoint(center.x+radiusC, center.y+radiusC);
	CGFloat maxDist = [CFAVector distanceBetweenA:center andB:outerC]; //distFromX:center.x Y:center.y toX:center.x+radiusB Y:center.y+radiusB];
		CGFloat locations[3] = {0.0,midDist/maxDist,1.0};
	
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear), colorArrayRef, locations);
	
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	CGContextAddPath(context, shape);
	CGContextClip(context);
	CGContextDrawRadialGradient(context, gradient, NSPointToCGPoint(center), radiusA, NSPointToCGPoint(center), radiusC, 0);
	CGContextRestoreGState(context);
}

-(void)updateContext {
}
@end