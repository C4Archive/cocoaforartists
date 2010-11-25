//
//  CFAGradient.m
//  CodeSamples
//
//  Created by Travis Kirton on 10-09-27.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import "CFAGradient.h"


@implementation CFAGradient

-(id)init {
	if(![super init]) return nil;
	return self;
}

+(void)linearGradientFromPointA:(NSPoint)pointA toPointB:(NSPoint)pointB usingColorA:(CGColorRef)colorA andColorB:(CGColorRef)colorB inShape:(CGMutablePathRef)shape{	
	const void *colors[2] = {colorA,colorB};	
	
	CFArrayRef colorArrayRef = CFArrayCreate(kCFAllocatorDefault, colors, 2, &kCFTypeArrayCallBacks);	
	
	CGFloat locations[2] = {0.0,1.0};
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear), colorArrayRef, locations);
	
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	CGContextAddPath(context, shape);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, (CGPoint)pointA, (CGPoint)pointB, 0);
	CGContextRestoreGState(context);
}

+(void)linearGradientFromPointA:(NSPoint)pointA toPointB:(NSPoint)pointB toPointC:(NSPoint)pointC usingColorA:(CGColorRef)colorA andColorB:(CGColorRef)colorB andColorC:(CGColorRef)colorC inShape:(CGMutablePathRef)shape{	
	const void *colors[3] = {colorA,colorB,colorC};	
	CFArrayRef colorArrayRef = CFArrayCreate(kCFAllocatorDefault, colors, 3, &kCFTypeArrayCallBacks);	

	CGFloat midDist = [CFAMath distFromX:pointA.x Y:pointA.y toX:pointB.x Y:pointB.y];
	CGFloat maxDist = [CFAMath distFromX:pointA.x Y:pointA.y toX:pointC.x Y:pointC.y];
	CGFloat locations[3] = {0.0,midDist/maxDist,1.0};
	
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear), colorArrayRef, locations);
	
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	CGContextAddPath(context, shape);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, (CGPoint)pointA, (CGPoint)pointC, 0);
	CGContextRestoreGState(context);	
	
}
@end