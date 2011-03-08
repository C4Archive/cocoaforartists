//
//  ___PROJECTNAME___
//	A Cocoa For Artists project
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

#import "___PROJECTNAMEASIDENTIFIER___AppDelegate.h"

@implementation ___PROJECTNAMEASIDENTIFIER___AppDelegate

@synthesize window;

+(void)load {
	if(VERBOSELOAD) printf("___PROJECTNAMEASIDENTIFIER___AppDelegate\n");
}


-(void)applicationWillFinishLaunching:(NSNotification *)notification {
	[cfaCanvas setupRect];
}

- (void)awakeFromNib {
	/* create instances of singletons */
	cfaOpenGLView	= [[[CFAOpenGLView alloc] _init] retain];
	cfaDateTime		= [[[CFADateTime alloc] _init] retain];
	cfaFoundation	= [[[CFAFoundation alloc] _init] retain];
	cfaMath			= [[[CFAMath alloc] _init] retain];
	cfaShape		= [[[CFAShape alloc] _init] retain];
	cfaTransform	= [[[CFATransform alloc] _init] retain];
	cfaGlobalTypeAttributes = [[[CFAGlobalTypeAttributes alloc] _init] retain];
	cfaNoise		= [[[CFANoise alloc] _init] retain];
}

@end