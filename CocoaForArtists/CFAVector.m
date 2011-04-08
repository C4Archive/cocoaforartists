//
//  CFAVector.m
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-12.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFAVector.h"

/*
	uses a combination of cblas, veclib and straight calcluations
	confirmed values calculated to those produced by Processing
 */

@implementation CFAVector

@synthesize vec;

+(id)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
	return [[[CFAVector alloc] vectorWithX:x Y:y Z:z] autorelease];
}

-(id)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
	if(!(self = [super init])) {
		return nil;
	}
	
	vec3[0] = x;
	vec3[1] = y;
	vec3[2] = z;
	
	pVec3[0] = 0;
	pVec3[1] = 0;
	pVec3[2] = 0;
	return self;
}

-(void)setX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
	vec3[0] = x;
	vec3[1] = y;
	vec3[2] = z;
}

-(void)add:(CFAVector *)aVec {
	vDSP_vadd(vec3, 1, aVec.vec, 1, vec3, 1, 3);
}

-(void)addScalar:(float)scalar {
	vDSP_vsadd(vec3, 1, &scalar, vec3, 1, 3);
}

-(void)divide:(CFAVector *)aVec {
	vDSP_vdiv(aVec.vec, 1, vec3, 1, vec3, 1, 3);
}

-(void)divideScalar:(float)scalar {
	vDSP_vsdiv(vec3, 1, &scalar, vec3, 1, 3);
}

-(void)multiply:(CFAVector *)aVec {
	vDSP_vmul(vec3, 1, aVec.vec, 1, vec3, 1, 3);
}

-(void)multiplyScalar:(float)scalar {
	vDSP_vsmul(vec3, 1, &scalar, vec3, 1, 3);
}

-(void)subtract:(CFAVector *)aVec {
	vDSP_vsub(vec3, 1, aVec.vec, 1, vec3, 1, 3);
}

-(void)subtractScalar:(float)scalar {
	[self addScalar:-1*scalar];
}

-(CGFloat)distance:(CFAVector *)aVec {
	return sqrt(pow(vec3[0]-(aVec.vec)[0], 2)+pow(vec3[1]-(aVec.vec)[1], 2)+pow(vec3[2]-(aVec.vec)[2], 2));
}

-(CGFloat)dot:(CFAVector *)aVec {
	return cblas_sdot(3, vec3, 1, aVec.vec, 1);
}

-(CGFloat)magnitude {
	return sqrt(pow(vec3[0], 2)+pow(vec3[1], 2)+pow(vec3[2], 2));
}

-(CGFloat)angleBetween:(CFAVector *)aVec {
	float dotProduct = [self dot:aVec];
	float cosTheta = dotProduct/([self magnitude]*[aVec magnitude]);
	return acosf(cosTheta);
}

-(void)cross:(CFAVector *)aVec {
	float newVec[3];
	newVec[0] = vec3[1]*(aVec.vec)[2] - vec3[2]*(aVec.vec)[1];
	newVec[1] = vec3[2]*(aVec.vec)[0] - vec3[0]*(aVec.vec)[2];
	newVec[2] = vec3[0]*(aVec.vec)[1] - vec3[1]*(aVec.vec)[0];
	vec3[0] = newVec[0];
	vec3[1] = newVec[1];
	vec3[2] = newVec[2];
}

-(void)normalize {
	[self limit:1.0f];
}

-(void)limit:(CGFloat)max {
	cblas_sscal(3, max/cblas_snrm2(3, vec3, 1), vec3, 1);
}

-(float*)vec {
	return vec3;
}

-(NSPoint)point2D {
	return NSMakePoint(vec3[0], vec3[1]);
}

-(NSString *)description {
	return [NSString stringWithFormat:@"vec(%4.2f,%4.2f,%4.2f)",vec3[0],vec3[1],vec3[2]];
}

+(CGFloat)distanceBetweenA:(NSPoint)pointA andB:(NSPoint)pointB {
	CFAVector *a = [[CFAVector vectorWithX:pointA.x Y:pointA.y Z:0] autorelease];
	CFAVector *b = [[CFAVector vectorWithX:pointB.x Y:pointB.y Z:0] autorelease];
	return [a distance:b];
}

+(CGFloat)angleBetweenA:(NSPoint)pointA andB:(NSPoint)pointB {
	CFAVector *a = [[CFAVector vectorWithX:pointA.x Y:pointA.y Z:0] autorelease];
	CFAVector *b = [[CFAVector vectorWithX:pointB.x Y:pointB.y Z:0] autorelease];
	return [a angleBetween:b];
}

-(CGFloat)x {
	return vec3[0];
}

-(CGFloat)y {
	return vec3[1];
}

-(CGFloat)z {
	return vec3[2];
}

-(CGFloat)heading {
    CGFloat angle = [CFAMath atan2Y:-1*vec3[1] X:vec3[0]];
    return -1*angle;
}

-(void)updatePVec {
	pVec3[0] = vec3[0];
	pVec3[1] = vec3[1];
	pVec3[2] = vec3[2];
}
@end
