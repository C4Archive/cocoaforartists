//
//  CFACanvas.h
//  CodeSamples
//
//	A Cocoa For Artists project
//  Created by Travis Kirton
//

#import "CFACanvas.h"

@interface CFACanvas (private)
@end

@implementation CFACanvas

-(void)setup {
	[self drawStyle:ANIMATED];
	[self windowWidth:200 andHeight:200];
}

-(void)draw {
	[[CFAImage imageName:@"CFATest" andType:@"jpg"] drawAt:mousePos];
}

@end