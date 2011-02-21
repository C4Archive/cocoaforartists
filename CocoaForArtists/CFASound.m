//
//  CFASound.m
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-08.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFASound.h"


@implementation CFASound
+(void)load {
	if(VERBOSELOAD) printf("CFASound\n");
}

+(CFASound *)withName:(NSString *)fileName andType:(NSString *)extension {
	return [[[CFASound alloc] initWithName:fileName andType:extension] retain];
}

-(id)initWithName:(NSString *)fileName andType:(NSString *)extension {
	if (!(self = [super init])) {
		return nil;
	}
	if(sound) {
		[sound stop]; 
		[sound release];
	}
	sound = [[[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName
																					ofType:extension]
										byReference:YES] retain];
	return self;
}

-(CGFloat)volume {
	return (CGFloat)[sound volume];
}

-(void)setVolume:(CGFloat)volume {
	[sound setVolume:volume];
}

-(CGFloat)duration {
	return (CGFloat)[sound duration];
}

-(CGFloat)currentTime {
	return (CGFloat)[sound currentTime];
}

-(void)setCurrentTime:(CGFloat)seconds {
	[sound setCurrentTime:(NSTimeInterval)seconds];
}

-(BOOL)loops {
	return [sound loops];
}

-(void)setLoops:(BOOL)loops {
	[sound setLoops:loops];
}

-(BOOL)isPlaying {
	return [sound isPlaying];
}

-(void)pause {
	[sound pause];
}

-(void)play {
	[sound play];
}

-(void)resume {
	[sound resume];
}

-(void)stop {
	[sound stop];
}

@end
