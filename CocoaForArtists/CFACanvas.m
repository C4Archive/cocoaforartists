//
//  ___PROJECTNAME___
//	A Cocoa For Artists project
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

#import "CFACanvas.h"
@interface CFACanvas (private)
CFAString *a, *b, *c;
BOOL pdf;
@end


@implementation CFACanvas

-(void)setup {
	pdf = NO;
//	[self drawStyle:EVENTBASED];
	[self windowWidth:1000 andHeight:400];
//	a = [CFAString stringWithString:@"the first string"];
//	b = [CFAString stringWithString:@"the second string"];
//	c = [CFAString stringWithFormat:@"%@ plus %@",a,b];
	a = [CFAString stringWithString:@"L"];
}

-(void)draw {
	[self setupPDF];
	[self background:1];

	[CFAString font:[NSFont fontWithName:@"LocatorDisplay" size:30.0f]];
	[a drawAtPoint:NSMakePoint(10, 0)];
	[a drawAtPoint:NSMakePoint(10, 50)];
	[a drawAtPoint:NSMakePoint(10, 100)];
	[self endPDF];
}

-(void)mousePressed {
	pdf = YES;
}

@end