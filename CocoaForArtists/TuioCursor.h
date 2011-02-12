//
//  TuioCursor.h
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-07.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TuioCursor : NSObject {
	NSUInteger	sessionID;
	NSUInteger	objectID;
	NSPoint		origin;
	CGFloat		angle, xSpeed, ySpeed, mAccel;
}

-(id)initWithSessionId:(NSUInteger)sID 
			  objectID:(NSUInteger)oID 
				origin:(NSPoint)orig 
				 speed:(NSPoint)spd
				maccel:(CGFloat)maccel;

-(void)updateOrigin:(NSPoint)orig 
			  speed:(NSPoint)spd
			 maccel:(CGFloat)maccel;

@property (readonly)	NSUInteger sessionID;
@property (readonly)	NSUInteger objectID;
@property (readonly)	NSPoint origin;
@property (readonly)	NSPoint speed;
@property (readonly)	CGFloat angle;
@property (readonly)	CGFloat mAccel;
@end
