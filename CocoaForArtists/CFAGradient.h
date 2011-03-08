//
//  CFAGradient.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

@interface CFAGradient : CFAObject {
	@private
	CGGradientRef gradient;
}

+(void)linearGradientFromPointA:(NSPoint)pointA toPointB:(NSPoint)pointB usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB inShape:(CGMutablePathRef)shape;
+(void)linearGradientFromPointA:(NSPoint)pointA toPointB:(NSPoint)pointB toPointC:(NSPoint)pointC usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB andColorC:(CFAColor*)colorC inShape:(CGMutablePathRef)shape;
+(void)radialGradientFromCenter:(NSPoint)center toRadiusA:(CGFloat)radiusA andRadiusB:(CGFloat)radiusB usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB inShape:(CGMutablePathRef)shape;
+(void)radialGradientFromCenter:(NSPoint)center toRadiusA:(CGFloat)radiusA andRadiusB:(CGFloat)radiusB andRadiusC:(CGFloat)radiusC usingColorA:(CFAColor *)colorA andColorB:(CFAColor *)colorB andColorC:(CFAColor *)colorC inShape:(CGMutablePathRef)shape;

@end