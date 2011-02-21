//
//  CFASpeech.m
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-02.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFAVoice.h"


@implementation CFAVoice
+(void)load {
	if(VERBOSELOAD) printf("CFAVoice\n");
}

-(id)init {
	if(!(self = [super init])){
		return nil;
	}
	synth = [[[NSSpeechSynthesizer alloc] init] retain];
	[synth setUsesFeedbackWindow:NO];
	return self;
}

-(id)initWithVoice:(id)voice {
	if(!(self = [super init])){
		return nil;
	}
	synth = [[[NSSpeechSynthesizer alloc] init] retain];
	[synth setUsesFeedbackWindow:NO];
	
	[synth setVoice:[CFAString nsStringFromObject:voice]];
	return self;
}

+(CFAVoice *)initWithVoice:(id)voice {
	return [[CFAVoice alloc] initWithVoice:voice];
}

-(CFAString *)voice {
	return [CFAString stringWithString:[synth voice]];
}

-(void)setVoice:(id)voice {
	[synth setVoice:[CFAString nsStringFromObject:voice]];
}

-(CGFloat)rate {
	return synth.rate;
}

-(void)setRate:(CGFloat)rate {
	synth.rate = rate;
}

-(CGFloat)volume {
	return synth.volume;
}

-(void)setVolume:(CGFloat)volume {
	synth.volume = volume;
}

+(NSArray *)availableVoices {
	return [NSArray arrayWithObjects:@"AGNES",@"ALBERT",@"ALEX",@"BADNEWS",@"BAHH",@"BELLS",@"BOING",
			@"BRUCE",@"BUBBLES",@"CELLOS",@"DERANGED",@"FRED",@"GOODNEWS",@"HYSTERICAL",@"JUNIOR",@"KATHY",
			@"ORGAN",@"PRINCESS",@"RALPH",@"TRINOIDS",@"VICKI",@"VICTORIA",@"WHISPER",@"ZARVOX",nil];
}

+(BOOL)isAnyApplicationSpeaking {
	return [NSSpeechSynthesizer isAnyApplicationSpeaking];
}

+(void)speak:(id)sentence {
	CFAVoice *temporarySynth = [[[CFAVoice alloc] init] autorelease];
	[temporarySynth speak:sentence];
}

+(void)speak:(id)sentence withVoice:(id)voice {
	CFAVoice *temporarySynth = [[[CFAVoice alloc] initWithVoice:voice] autorelease];
	[temporarySynth speak:sentence];
}

-(void)speak:(id)sentence {
	[synth startSpeakingString:[CFAString nsStringFromObject:sentence]];
}

-(void)speak:(id)sentence withVoice:(id)voice {
	[self setVoice:voice];
	[synth startSpeakingString:[CFAString nsStringFromObject:sentence]];
}

-(BOOL)isSpeaking {
	return [synth isSpeaking];
}

-(void)pause:(int)pauseBoundary {
	[synth pauseSpeakingAtBoundary:pauseBoundary];
}

-(void)continueSpeaking {
	[synth continueSpeaking];
}

-(void)stop {
}

-(void)stop:(int)stopBoundary  {
	[synth stopSpeakingAtBoundary:stopBoundary];
}

@end
