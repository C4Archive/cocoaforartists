//
//  ___PROJECTNAME___
//	A Cocoa For Artists project
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

#import "___PROJECTNAMEASIDENTIFIER___AppDelegate.h"

@implementation ___PROJECTNAMEASIDENTIFIER___AppDelegate

@synthesize window;

+(void)load {
	if(VERBOSELOAD) printf("CFADevelopAppDelegate\n");
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	cfaColor		= [[[CFAColor alloc] initWithRed:0 green:0 blue:0 alpha:0] retain];
	cfaDateTime		= [[[CFADateTime alloc] _init] retain];
	cfaFoundation	= [[[CFAFoundation alloc] _init] retain];
	cfaMath			= [[[CFAMath alloc] _init] retain];
	cfaShape		= [[[CFAShape alloc] _init] retain];
	cfaTransform	= [[[CFATransform alloc] _init] retain];
	cfaString		= [[[CFAString alloc] init] retain];
	cfaGlobalTypeAttributes = [[[CFAGlobalTypeAttributes alloc] _init] retain];
}

@end