//
//  CFAMath.h
//  CocoaForArtists
//
//  Created by Travis Kirton on 10-09-12.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#pragma mark Constants
#define HALF_PI		pi/2
#define	PI			pi
#define QUARTER_PI	pi/4
#define	TWO_PI		pi*2
#define eCONSTANT	2.71828182845904523536

@interface CFAMath : NSObject {
}

#pragma mark Singleton
-(id)_init;
+(CFAMath *)sharedManager;

#pragma mark Calculation
+(int)abs:(int)value;
+(float)absf:(float)value;
+(int)ceil:(float)value;
+(int)constrain:(int)value min:(int)min max:(int)max;
+(float)constrainf:(float)value min:(float)min max:(float)max;
+(float)distFromX:(float)x1 Y:(float)y1 toX:(float)x2 Y:(float)y2;
+(float)exp:(float)value;
+(int)floor:(float)value;
+(float)lerpBetweenA:(float)a andB:(float)b byAmount:(float)amount;
+(float)log:(float)value;
+(float)magPoint:(NSPoint)p;
+(float)magX:(float)x Y:(float)y;
+(float)map:(float)value fromMin:(float)min1 max:(float)max1 toMin:(float)min2 max:(float)max2;
+(float)maxOfA:(float)a andB:(float)b;
+(float)maxOfA:(float)a B:(float)b andC:(float)c;
//+(float)maxOfArray:(NSArray *)array;
+(float)minOfA:(float)a andB:(float)b;
+(float)minOfA:(float)a B:(float)b andC:(float)c;
//+(float)minOfArray:(NSArray *)array;
+(float)norm:(float)value fromMin:(float)min toMax:(float)max;
+(float)pow:(float)value raiseTo:(float)degree;
+(float)round:(float)value;
+(float)square:(float)value;
+(float)sqrt:(float)value;
+(float)distanceFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2;
+(float)distanceFromX:(float)x1 Y:(float)y1 toX:(float)x2 Y:(float)y2;

#pragma mark Trigonometry
+(float)acos:(float)value;
+(float)asin:(float)value;
+(float)atan:(float)value;
+(float)atan2Y:(float)y X:(float)x;
+(float)cos:(float)value;
+(float)degrees:(float)value;
+(float)radians:(float)value;
+(float)sin:(float)value;
+(float)tan:(float)value;

#pragma mark Random
+(int)randomInt:(int)value;
+(int)randomIntBetweenA:(int)a andB:(int)b;
@end
