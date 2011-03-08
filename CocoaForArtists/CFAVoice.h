//
//  CFASpeech.h
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-02.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CFAVoice : CFAObject {
	NSSpeechSynthesizer *synth;
}

-(id)init;
-(id)initWithVoice:(id)voice;
+(CFAVoice *)initWithVoice:(id)voice;

-(CFAString *)voice;
-(void)setVoice:(id)voice;
-(CGFloat)rate;
-(void)setRate:(CGFloat)rate;
-(CGFloat)volume;
-(void)setVolume:(CGFloat)volume;

+(NSArray *)availableVoices;
+(BOOL)isAnyApplicationSpeaking;

+(void)speak:(id)sentence;
+(void)speak:(id)sentence withVoice:(id)voice;
-(void)speak:(id)sentence;
-(void)speak:(id)sentence withVoice:(id)voice;
-(BOOL)isSpeaking;
-(void)pause:(int)pauseBoundary;
-(void)continueSpeaking;
-(void)stop;
-(void)stop:(int)stopBoundary;
@end


/*
 – phonemesFromText:
 */