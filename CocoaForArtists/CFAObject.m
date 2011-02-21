//
//  CFAObject.m
//  ___PROJECTNAME___
//
//  Created by moi on 11-02-20.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFAObject.h"

@implementation CFAObject

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

-(void)listenFor:(NSString *)aNotification andRunMethod:(NSString *)aMethodName{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(aMethodName) name:aNotification object:nil];
}

-(void)stopListeningFor:(NSString *)aMethodName {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:aMethodName object:nil];
}

-(void)postNotification:(NSString *)aNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:aNotification object:self];
}
@end
