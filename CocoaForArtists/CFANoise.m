//
//  CFANoise.m
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-13.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFANoise.h"
#import "Perlin.h"

static CFANoise *cfaNoise;

@implementation CFANoise
GENERATE_SINGLETON(CFANoise, cfaNoise);

-(id)_init {
	return self;
}

+(CGFloat)noise1:(float)arg {
	return [[CFANoise sharedManager] noise1:arg];
}

+(CGFloat)noise2:(float*)vec {
	return [[CFANoise sharedManager] noise2:vec];
}


+(CGFloat)noise2UsingPoint:(NSPoint)pt {
	return [[CFANoise sharedManager] noise2UsingPoint:pt];
}


+(CGFloat)noise2UsingVector:(CFAVector*)vector {
	return [[CFANoise sharedManager] noise2UsingVector:vector];
}


+(CGFloat)noise3:(float*)vec {
	return [[CFANoise sharedManager] noise3:vec];
}


+(CGFloat)noise3UsingVector:(CFAVector*)vector {
	return [[CFANoise sharedManager] noise3UsingVector:vector];
}


+(CGFloat)turbulence:(float*)vec LowFreq:(CGFloat)lofreq HiFreq:(CGFloat)hifreq {
	return [[CFANoise sharedManager] turbulence:vec LowFreq:lofreq HiFreq:hifreq];
}


+(CGFloat)turbulenceUsingVector:(CFAVector*)vector LowFreq:(CGFloat)lofreq HiFreq:(CGFloat)hifreq {
	return [[CFANoise sharedManager] turbulenceUsingVector:vector LowFreq:lofreq HiFreq:hifreq];
}


+(CGFloat)noise2_naX:(CGFloat)x Y:(CGFloat)y {
	return [[CFANoise sharedManager] noise2_naX:x Y:y];
}

+(CGFloat)noise2_naXUsingPoint:(NSPoint)pt {
	return [[CFANoise sharedManager] noise2_naXUsingPoint:pt];
}

+(CGFloat)noise2_naXUsingVector:(CFAVector *)vector {
	return [[CFANoise sharedManager] noise2_naXUsingVector:vector];
}

+(CGFloat)noise3_naX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
	return [[CFANoise sharedManager] noise3_naX:x Y:y Z:z];
}

+(CGFloat)noise3_naXUsingVector:(CFAVector *)vector {
	return [[CFANoise sharedManager] noise3_naXUsingVector:vector];
}


-(CGFloat)noise1:(float)arg {
	return (CGFloat)noise1(arg);
}

-(CGFloat)noise2:(float*)vec {
	return (CGFloat)noise2(vec);
}


-(CGFloat)noise2UsingPoint:(NSPoint)pt {
	float vec[2] = {pt.x,pt.y};
	return (CGFloat)noise2(vec);
}


-(CGFloat)noise2UsingVector:(CFAVector*)vector {
	float vec[2] = {vector.vec[0],vector.vec[1]};
	return (CGFloat)noise2(vec);
}


-(CGFloat)noise3:(float*)vec {
	return (CGFloat)noise3(vec);
}


-(CGFloat)noise3UsingVector:(CFAVector*)vector {
	return (CGFloat)noise3(vector.vec);
}


-(CGFloat)turbulence:(float*)vec LowFreq:(CGFloat)lofreq HiFreq:(CGFloat)hifreq {
	return (CGFloat)turbulence(vec, lofreq, hifreq);
}


-(CGFloat)turbulenceUsingVector:(CFAVector*)vector LowFreq:(CGFloat)lofreq HiFreq:(CGFloat)hifreq {
	return (CGFloat)turbulence(vector.vec, lofreq, hifreq);
}


-(CGFloat)noise2_naX:(CGFloat)x Y:(CGFloat)y {
	return (CGFloat)noise2_na(x, y);
}

-(CGFloat)noise2_naXUsingPoint:(NSPoint)pt {
	return (CGFloat)noise2_na(pt.x, pt.y);
}

-(CGFloat)noise2_naXUsingVector:(CFAVector *)vector {
	return (CGFloat)noise2_na(vector.vec[0], vector.vec[1]);
}

-(CGFloat)noise3_naX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
	return (CGFloat)noise3_na(x, y, z);
}

-(CGFloat)noise3_naXUsingVector:(CFAVector *)vector {
	return (CGFloat)noise3_na(vector.vec[0], vector.vec[1], vector.vec[2]);
}

@end