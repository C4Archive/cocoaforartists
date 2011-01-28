//
//  CFAGradient.h
//  C4A
//
//  Created by Travis Kirton on 10-09-27.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CFAGradient : NSObject {
	@private
	CGGradientRef gradient;
}

+(void)linearGradientFromPointA:(NSPoint)pointA toPointB:(NSPoint)pointB usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB inShape:(CGMutablePathRef)shape;
+(void)linearGradientFromPointA:(NSPoint)pointA toPointB:(NSPoint)pointB toPointC:(NSPoint)pointC usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB andColorC:(CFAColor*)colorC inShape:(CGMutablePathRef)shape;
@end