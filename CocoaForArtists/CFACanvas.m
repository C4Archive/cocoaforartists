//
//  CFACanvas.h
//  CodeSamples
//
//	A Cocoa For Artists project
//  Created by Travis Kirton
//

#import "CFACanvas.h"
#import "Particle.h"

@interface CFACanvas (private)
Particle *particles[1000];
BOOL saving;
@end 

@implementation CFACanvas
-(void)setup {
	[self windowWidth:1024 andHeight:768];
	[self drawStyle:ANIMATED];
	[self flipCoordinates];
	saving = NO;
	for(int i = 0; i < 1000; i++) {
		particles[i] = [[Particle alloc] initWithVector:[CFAVector vectorWithX:100 Y:self.canvasHeight-100 Z:0]];
	}
}

-(void)draw {
	[self background:1];
	[CFAShape stroke:0 alpha:0.4];
	for(int i = 0; i < 1000; i++) {
		[particles[i] update];
		[particles[i] draw];
	}
}
@end