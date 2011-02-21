//
//  CFASound.h
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-08.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CFASound : NSObject {
	@private
	NSSound *sound;
}

+(CFASound *)withName:(NSString *)file andType:(NSString *)extension;
-(id)initWithName:(NSString *)file andType:(NSString *)extension;

-(CGFloat)volume;
-(void)setVolume:(CGFloat)volume;

-(CGFloat)duration;
-(CGFloat)currentTime;
-(void)setCurrentTime:(CGFloat)seconds;

-(BOOL)loops;
-(void)setLoops:(BOOL)loops;

-(BOOL)isPlaying;
-(void)pause;
-(void)play;
-(void)resume;
-(void)stop;
@end