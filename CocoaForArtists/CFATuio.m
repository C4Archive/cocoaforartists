//
//  CFATuio.m
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-07.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFATuio.h"
static CFATuio *cfaTuio;

@interface CFATuio (private)
NSComparator tuioCursorComparator = ^(id cursor1, id cursor2) {
    if (((TuioCursor*)cursor1).sessionID > ((TuioCursor*)cursor2).sessionID) {
		return (NSComparisonResult)NSOrderedDescending;
	}
	
	if (((TuioCursor*)cursor2).sessionID > ((TuioCursor*)cursor1).sessionID) {
		return (NSComparisonResult)NSOrderedAscending;
	}
	return (NSComparisonResult)NSOrderedSame;
};
@end

@implementation CFATuio
GENERATE_SINGLETON(CFATuio, cfaTuio);

@synthesize tuioFrameRate;

-(id)_init {
	return self;
}

+(void)initWithOpenGLContext:(NSOpenGLContext *)openGLContext pixelFormat:(NSOpenGLPixelFormat *)pixelFormat {
	[[self sharedManager] initWithOpenGLContext:openGLContext pixelFormat:pixelFormat];
}

-(void)initWithOpenGLContext:(NSOpenGLContext *)openGLContext pixelFormat:(NSOpenGLPixelFormat *)pixelFormat {
	if(renderer) {
		[self stop];
		[renderer release];
	}
	renderer = [[[QCRenderer alloc] initWithOpenGLContext:openGLContext pixelFormat:pixelFormat file:[[NSBundle mainBundle] pathForResource:@"TuioClient" ofType:@"qtz"]] retain];
	tuioCursors = [[[NSMutableArray alloc] initWithCapacity:0] retain];
	[self setFrameRate:30.0f];
}

-(void)setFrameRate:(CGFloat)aRate {
	if (aRate >= 0.001f && self.tuioFrameRate != aRate) {
		self.tuioFrameRate = aRate;
		if(tuioTimer) [tuioTimer invalidate];
		tuioTimer = [NSTimer timerWithTimeInterval:1.0f/self.tuioFrameRate target:self selector:@selector(update) userInfo:nil repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:tuioTimer forMode:NSDefaultRunLoopMode];
	}
}

-(void)stop {
	if([tuioTimer isValid]) [tuioTimer invalidate];
}

-(void)resume {
	if(![tuioTimer isValid]) [self setFrameRate:self.tuioFrameRate];
}

-(void)update {
	[renderer renderAtTime:[NSDate timeIntervalSinceReferenceDate] arguments:nil];
}

-(NSArray *)tuioCursors {
	//get a list of cursors
	NSDictionary *cursorDictionary = [[[NSDictionary alloc] initWithDictionary:[renderer valueForOutputKey:@"TuioCursors"]] autorelease];
	NSArray *sortedArray = [[NSArray alloc] init];
	if([cursorDictionary count] > 0) {
		//get keys (names) for each cursor in the list 
		NSArray *cursorDictionaryKeys = [cursorDictionary allKeys];
		//for each cursor in the list, iterate through it's variables
		NSMutableArray *liveKeys = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
		for(NSString *cursorObjectKey in cursorDictionaryKeys){
			NSArray *cursorObjectKeys = [cursorDictionary objectForKey:cursorObjectKey];// sortedArrayUsingComparator:tuioCursorComparator] ;
			NSUInteger	cID = [[cursorObjectKeys valueForKey:@"c_id"] integerValue];
			NSUInteger	sID = [[cursorObjectKeys valueForKey:@"s_id"] integerValue];
			CGFloat		mAccel = [[cursorObjectKeys valueForKey:@"maccel"] floatValue];
			NSPoint		origin = NSMakePoint([[cursorObjectKeys valueForKey:@"xpos"] floatValue],
											 [[cursorObjectKeys valueForKey:@"ypos"] floatValue]);
			
			NSPoint		speed = NSMakePoint([[cursorObjectKeys valueForKey:@"xpos"] floatValue],
											[[cursorObjectKeys valueForKey:@"ypos"] floatValue]);
			
			origin.x += 1.0f;
			origin.x *= viewSize.width/2.0f;
			
			origin.y *= viewSize.width/viewSize.height;
			origin.y += 1.0f;
			origin.y *= viewSize.height/2.0f;			
			
			[liveKeys addObject:[[TuioCursor alloc] initWithSessionId:sID
															 objectID:cID
															   origin:origin
																speed:speed 
															   maccel:mAccel]];
		}
		
		sortedArray = [liveKeys sortedArrayUsingComparator:tuioCursorComparator];
	}	
	return [sortedArray copy];
}

-(BOOL)tuioCursorExistsForID:(NSUInteger)cursorID {
	for(TuioCursor *tc in tuioCursors) {
		if(tc.objectID == cursorID) return YES;
	}
	return NO;
}

-(void)setSize:(NSSize)size {
	viewSize = size;
}

+(void)setFrameRate:(CGFloat)aRate {
	[self.sharedManager setFrameRate:aRate];
}

+(void)stop {
	[self.sharedManager stop];
}

+(void)resume {
	[self.sharedManager resume];
}

+(void)update {
	[self.sharedManager update];
}

+(NSArray *)tuioCursors {
	return [self.sharedManager tuioCursors];
}
+(void)setSize:(NSSize)size {
	[self.sharedManager setSize:size];
}

@end