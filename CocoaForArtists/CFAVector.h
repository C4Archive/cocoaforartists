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
	float *vec;
}

+(CGFloat)distanceBetweenA:(NSPoint)pointA andB:(NSPoint)pointB;
+(CGFloat)angleBetweenA:(NSPoint)pointA andB:(NSPoint)pointB;

+(id)vectorWithX:(float)x Y:(float)y Z:(float)z;
-(id)vectorWithX:(float)x Y:(float)y Z:(float)z;
-(void)setX:(float)x Y:(float)y Z:(float)z;
-(void)add:(CFAVector *)aVec;
-(void)addScalar:(float)scalar;
-(void)divide:(CFAVector *)aVec;
-(void)divideScalar:(float)scalar;
-(void)multiply:(CFAVector *)aVec;
-(void)multiplyScalar:(float)scalar;
-(void)subtract:(CFAVector *)aVec;
-(void)subtractScalar:(float)scalar;
-(float)distance:(CFAVector *)aVec;
-(float)dot:(CFAVector *)aVec;
-(float)magnitude;
-(float)angleBetween:(CFAVector *)aVec;
-(void)cross:(CFAVector *)aVec;
-(void)normalize;
-(void)limit:(float)max;
-(NSPoint)point2D;
@property (readonly) float *vec;
@end
