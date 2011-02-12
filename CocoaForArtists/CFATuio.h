//
//  CFATuio.h
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-07.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "TuioCursor.h"

@interface CFATuio : NSObject {
	@private
	NSMutableArray *tuioCursors, *tuioObjects;
	NSArray *tuioCursorKeys, *tuioObjectKeys;
	QCRenderer *renderer;
	NSTimer *tuioTimer;
	CGFloat tuioFrameRate;
	NSSize viewSize;
}

#pragma mark Singleton
-(id)_init;
+(CFATuio *)sharedManager;

#pragma mark public functions

+(void)initWithOpenGLContext:(NSOpenGLContext *)openGLContext pixelFormat:(NSOpenGLPixelFormat *)pixelFormat;
+(void)stop;
+(void)resume;
+(void)update;
+(void)setFrameRate:(CGFloat)aRate;
+(NSArray *)tuioCursors;
+(void)setSize:(NSSize)size;

-(void)initWithOpenGLContext:(NSOpenGLContext *)openGLContext pixelFormat:(NSOpenGLPixelFormat *)pixelFormat;
-(void)stop;
-(void)resume;
-(void)update;
-(void)setFrameRate:(CGFloat)aRate;
-(NSArray *)tuioCursors;
-(void)setSize:(NSSize)size;

@property CGFloat tuioFrameRate;
@end