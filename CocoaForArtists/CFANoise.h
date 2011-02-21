//
//  CFANoise.h
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-13.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CFANoise : NSObject {
}
-(id)_init;
+(CFANoise *)sharedManager;

+(CGFloat)noise1:(float)arg;
+(CGFloat)noise2:(float*)vec;
+(CGFloat)noise2UsingPoint:(NSPoint)pt;
+(CGFloat)noise2UsingVector:(CFAVector*)vector;
+(CGFloat)noise3:(float*)vec;
+(CGFloat)noise3UsingVector:(CFAVector*)vector;
+(CGFloat)turbulence:(float*)vec LowFreq:(CGFloat)lofreq HiFreq:(CGFloat)hifreq;
+(CGFloat)turbulenceUsingVector:(CFAVector*)vector LowFreq:(CGFloat)lofreq HiFreq:(CGFloat)hifreq;
+(CGFloat)noise2_naX:(CGFloat)x Y:(CGFloat)y;
+(CGFloat)noise2_naXUsingPoint:(NSPoint)pt;
+(CGFloat)noise2_naXUsingVector:(CFAVector *)vector;
+(CGFloat)noise3_naX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
+(CGFloat)noise3_naXUsingVector:(CFAVector *)vector;

@end

@interface CFANoise (private)

-(CGFloat)noise1:(float)arg;
-(CGFloat)noise2:(float*)vec;
-(CGFloat)noise2UsingPoint:(NSPoint)pt;
-(CGFloat)noise2UsingVector:(CFAVector*)vector;
-(CGFloat)noise3:(float*)vec;
-(CGFloat)noise3UsingVector:(CFAVector*)vector;
-(CGFloat)turbulence:(float*)vec LowFreq:(CGFloat)lofreq HiFreq:(CGFloat)hifreq;
-(CGFloat)turbulenceUsingVector:(CFAVector*)vector LowFreq:(CGFloat)lofreq HiFreq:(CGFloat)hifreq;
-(CGFloat)noise2_naX:(CGFloat)x Y:(CGFloat)y;
-(CGFloat)noise2_naXUsingPoint:(NSPoint)pt;
-(CGFloat)noise2_naXUsingVector:(CFAVector *)vector;
-(CGFloat)noise3_naX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
-(CGFloat)noise3_naXUsingVector:(CFAVector *)vector;

@end

