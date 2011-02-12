//
//  TuioCursor.m
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-02-07.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "TuioCursor.h"

@implementation TuioCursor
@synthesize sessionID, objectID, origin, angle, speed, mAccel;
-(id)initWithSessionId:(NSUInteger)sID 
			  objectID:(NSUInteger)oID 
				origin:(NSPoint)orig 
				 speed:(NSPoint)spd
				maccel:(CGFloat)maccel{
	sessionID = sID;
	objectID = oID;
	origin = orig;
	speed = spd;
	mAccel = maccel;
	
	return self;
}

-(void)updateOrigin:(NSPoint)orig speed:(NSPoint)spd maccel:(CGFloat)maccel {
	origin = orig;
	speed = spd;
	mAccel = maccel;
}

@end
