//
//  CFACanvas.h
//  CodeSamples
//
//	A Cocoa For Artists project
//  Created by Travis Kirton
//

#import "CFACanvas.h"
@implementation CFACanvas
-(void)setup {
	[self windowWidth:931 andHeight:1660];
}
-(void)draw {
	[self setupPDF];
	[self background:1];
	for(int i = 0; i < 1000; i++){
		[CFAShape strokeRed:FLOAT_FROM_255([CFAMath randomInt:255]) green:FLOAT_FROM_255([CFAMath randomInt:255]) blue:FLOAT_FROM_255([CFAMath randomInt:255])];
		[CFAShape lineFromX:[CFAMath randomInt:931] Y:0 toX:[CFAMath randomInt:931] Y:1660];
	}
	[self endPDF];
}
@end