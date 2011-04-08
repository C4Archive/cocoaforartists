//
//  CFAMath.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

#pragma mark Constants
#define HALF_PI		pi/2
#define	PI			pi
#define QUARTER_PI	pi/4
#define	TWO_PI		pi*2
#define eCONSTANT	2.71828182845904523536

@interface CFAMath : CFAObject {
	
}

#pragma mark Singleton
-(id)_init;
+(CFAMath *)sharedManager;

#pragma mark Calculation
+(NSInteger)abs:(NSInteger)value;
+(CGFloat)absf:(CGFloat)value;
+(NSInteger)ceil:(CGFloat)value;
+(NSInteger)constrain:(NSInteger)value min:(NSInteger)min max:(NSInteger)max;
+(CGFloat)constrainf:(CGFloat)value min:(CGFloat)min max:(CGFloat)max;
+(CGFloat)exp:(CGFloat)value;
+(NSInteger)floor:(CGFloat)value;
+(CGFloat)lerpBetweenA:(CGFloat)a andB:(CGFloat)b byAmount:(CGFloat)amount;
+(CGFloat)log:(CGFloat)value;
+(CGFloat)map:(CGFloat)value fromMin:(CGFloat)min1 max:(CGFloat)max1 toMin:(CGFloat)min2 max:(CGFloat)max2;
+(CGFloat)maxOfA:(CGFloat)a andB:(CGFloat)b;
+(CGFloat)maxOfA:(CGFloat)a B:(CGFloat)b andC:(CGFloat)c;
+(CGFloat)minOfA:(CGFloat)a andB:(CGFloat)b;
+(CGFloat)minOfA:(CGFloat)a B:(CGFloat)b andC:(CGFloat)c;
+(CGFloat)norm:(CGFloat)value fromMin:(CGFloat)min toMax:(CGFloat)max;
+(CGFloat)pow:(CGFloat)value raiseTo:(CGFloat)degree;
+(CGFloat)round:(CGFloat)value;
+(CGFloat)square:(CGFloat)value;
+(CGFloat)sqrt:(CGFloat)value;

#pragma mark Trigonometry
+(CGFloat)acos:(CGFloat)value;
+(CGFloat)asin:(CGFloat)value;
+(CGFloat)atan:(CGFloat)value;
+(CGFloat)atan2Y:(CGFloat)y X:(CGFloat)x;
+(CGFloat)cos:(CGFloat)value;
+(CGFloat)degrees:(CGFloat)value;
+(CGFloat)radians:(CGFloat)value;
+(CGFloat)sin:(CGFloat)value;
+(CGFloat)tan:(CGFloat)value;

#pragma mark Random
+(NSInteger)randomInt:(NSInteger)value;
+(NSInteger)randomIntBetweenA:(NSInteger)a andB:(NSInteger)b;

#pragma mark Unused
//+(CGFloat)distFromX:(CGFloat)x1 Y:(CGFloat)y1 toX:(CGFloat)x2 Y:(CGFloat)y2;
//+(CGFloat)magPoint:(NSPoint)p;
//+(CGFloat)magX:(CGFloat)x Y:(CGFloat)y;
//+(CGFloat)maxOfArray:(NSArray *)array;
//+(CGFloat)minOfArray:(NSArray *)array;
//+(CGFloat)distanceFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2;
//+(CGFloat)distanceFromX:(CGFloat)x1 Y:(CGFloat)y1 toX:(CGFloat)x2 Y:(CGFloat)y2;

@end
