//
//  CFATransform.h
//  CodeSamples
//
//  Created by Travis Kirton on 10-09-29.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CFATransform : NSObject {
}

-(id)_init;
+(CFATransform *)sharedManager;

+(void)begin;
+(void)concat;
+(void)end;

+(void)translateByX:(int)x andY:(int)y;
+(void)translateBy:(NSPoint)point;
+(void)rotateByAngle:(float)angle;

@end
