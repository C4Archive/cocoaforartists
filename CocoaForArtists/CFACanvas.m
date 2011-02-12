//
//  ___PROJECTNAME___
//	A Cocoa For Artists projec
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

#import "CFACanvas.h"
@interface CFACanvas (private)
CFATuio *tuio;
@end

@implementation CFACanvas

-(void)setup {
	[self drawStyle:ANIMATED];
	[CFAShape fill:1];
	[CFAShape stroke:0];
	[CFAShape stroke];
	[self windowWidth:200 andHeight:400];
}

-(void)draw {
	[self background:1 alpha:0.05f];
	NSArray *tuioCursors = [[CFATuio tuioCursors] copy];
	for(TuioCursor *tc in tuioCursors) {
		[CFAShape circleAt:tc.origin radius:5];
	}
}

@end