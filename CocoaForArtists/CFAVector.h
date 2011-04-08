//
//  CFAVector.h
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-12.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Accelerate/Accelerate.h>

@interface CFAVector : CFAObject {
@private
	float vec3[3];
	float pVec3[3];
	float *vec;
}

+(CGFloat)distanceBetweenA:(NSPoint)pointA andB:(NSPoint)pointB;
+(CGFloat)angleBetweenA:(NSPoint)pointA andB:(NSPoint)pointB;

+(id)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
-(id)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
-(void)setX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
-(void)add:(CFAVector *)aVec;
-(void)addScalar:(float)scalar;
-(void)divide:(CFAVector *)aVec;
-(void)divideScalar:(float)scalar;
-(void)multiply:(CFAVector *)aVec;
-(void)multiplyScalar:(float)scalar;
-(void)subtract:(CFAVector *)aVec;
-(void)subtractScalar:(float)scalar;
-(CGFloat)distance:(CFAVector *)aVec;
-(CGFloat)dot:(CFAVector *)aVec;
-(CGFloat)magnitude;
-(CGFloat)angleBetween:(CFAVector *)aVec;
-(void)cross:(CFAVector *)aVec;
-(void)normalize;
-(void)limit:(CGFloat)max;
-(NSPoint)point2D;
-(CGFloat)heading;
-(CGFloat)x;
-(CGFloat)y;
-(CGFloat)z;
@property (readonly) float *vec;
@end
