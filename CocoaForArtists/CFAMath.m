//
//  CFAMath.m
//  Created by Travis Kirton
//

#import "CFAMath.h"

static CFAMath *cfaMath;

@implementation CFAMath
GENERATE_SINGLETON(CFAMath, cfaMath);

#pragma mark Initialization

+(void)load {
	if(VERBOSELOAD) printf("CFAMath\n");
}

-(id)_init {
	return self;
}

#pragma mark Calculation
+(int)abs:(int)value {
	return abs(value);
}

+(float)absf:(float)value {
	return fabsf(value);
}

+(int)ceil:(float)value {
	return ceilf(value);
}

+(int)constrain:(int)value min:(int)min max:(int)max {
	return [self constrainf:value min:min max:max];
}

+(float)constrainf:(float)value min:(float)min max:(float)max {
	if (min < value && value < max) return value;
	else if (value <= min) return min;
	else return max;
}

+(float)exp:(float)value {
	return [self pow:eCONSTANT raiseTo:value];
}

+(int)floor:(float)value {
	return floor((double)value);
}

+(float)lerpBetweenA:(float)a andB:(float)b byAmount:(float)amount {
	return 0;
}

+(float)log:(float)value {
	return logf(value);
}

+(float)map:(float)value fromMin:(float)min1 max:(float)max1 toMin:(float)min2 max:(float)max2 {
	/* NEED TO FIX THIS PROPERLY */
	float rangeLength1 = max1-min1;
	float rangeLength2 = max2-min2;
	float multiplier = rangeLength2/rangeLength1;
	return value*multiplier;
}

+(float)maxOfA:(float)a andB:(float)b {
	float max = a > b ? a : b;
	return max;
}

+(float)maxOfA:(float)a B:(float)b andC:(float)c {
	return [self maxOfA:[self maxOfA:a andB:b] andB:c];
}


+(float)minOfA:(float)a andB:(float)b {
	float min = a < b ? a : b;
	return min;
}

+(float)minOfA:(float)a B:(float)b andC:(float)c {
	return [self minOfA:[self minOfA:a andB:b] andB:c];
}

+(float)norm:(float)value fromMin:(float)min toMax:(float)max {
	return 0;
}

+(float)pow:(float)value raiseTo:(float)degree {
	return powf(value,degree);
}

+(float)round:(float)value {
	return roundf(value);
}

+(float)square:(float)value {
	return powf(value, 2);
}

+(float)sqrt:(float)value {
	return sqrtf(value);
}

#pragma mark Trigonometry
+(float)acos:(float)value {
	return acosf(value);
}

+(float)asin:(float)value {
	return asinf(value);
}

+(float)atan:(float)value {
	return atanf(value);
}

+(float)atan2Y:(float)y X:(float)x {
	return atan2f(y,x);
}

+(float)cos:(float)value {
	return cosf(value);
}

+(float)degrees:(float)value {
	return RADIANS_TO_DEGREES(value);
}

+(float)radians:(float)value {
	return DEGREES_TO_RADIANS(value);
}

+(float)sin:(float)value {
	return sinf(value);
}

+(float)tan:(float)value {
	return tanf(value);
}
#pragma mark Random
+(int)randomInt:(int)value {
	srandomdev();
	return random()%value;
}

#pragma mark arithmetic
+(int)randomIntBetweenA:(int)a andB:(int)b{
	if (a == b) return a;
	
	int max = a > b ? a : b;
	int min = a < b ? a : b;
	
	srandomdev();
	return (random()%(max-min) + min);
}

#pragma mark Unused
/*
 
 NOTE
 Took out methods that calculate distances between points.
 Leaving this for the CFAVector class...
 Is this a good idea (consistent), or should these still be included in CFAMath?
 */

// +(float)distFromX:(float)x1 Y:(float)y1 toX:(float)x2 Y:(float)y2 {
// return (sqrt(pow(x2-x1,2)+pow(y2-y1,2)));
// }
 
// +(float)magPoint:(NSPoint)p {
// return [self magX:p.x Y:p.y];
// }
 
// +(float)magX:(float)x Y:(float)y {
// return [self distFromX:0 Y:0 toX:x Y:y];
// }
 
// +(float)maxOfArray:(NSArray *)array {
// return 0;
// } 
 
// +(float)minOfArray:(NSArray *)array {
// return 0;
// }

// +(float)distanceFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 {
// return [self distanceFromX:p2.x Y:p2.y toX:p1.x Y:p1.y];
// }
 
// +(float)distanceFromX:(float)x1 Y:(float)y1 toX:(float)x2 Y:(float)y2 {
// return (sqrt(pow(x2-x1,2)+pow(y2-y1,2)));
// }

@end