//
//  CFATransform.m
//  Created by Travis Kirton
//

#import "CFATransform.h"

static CFATransform *cfaTransform;

@implementation CFATransform

GENERATE_SINGLETON(CFATransform, cfaTransform);

@synthesize transformArray;

+(void)load {
	if(VERBOSELOAD) printf("CFATransform\n");
}

-(id)_init {
	transformArray = [[NSMutableArray alloc] initWithCapacity:0];
	return self;
}

+(void)begin{
	[[CFATransform sharedManager] begin];
}

+(void)concat{
	[[CFATransform sharedManager] concat];
}

+(void)end {
	[[CFATransform sharedManager] end];
}

+(void)translateBy:(NSPoint)point {
	[[CFATransform sharedManager] translateBy:point];
}

+(void)translateByX:(NSInteger)x andY:(NSInteger)y {
	[[CFATransform sharedManager] translateByX:x andY:y];
}

+(void)rotateByAngle:(CGFloat)angle {
	[[CFATransform sharedManager] rotateByAngle:angle];
}

-(void)begin{
	[[NSGraphicsContext currentContext] saveGraphicsState];
	[transformArray addObject:[NSAffineTransform transform]];
}

-(void)concat{
	[[transformArray lastObject] concat];
}

-(void)end {
	int count = [transformArray count];
	if(count > 1) [[transformArray objectAtIndex:count-2] prependTransform:[transformArray lastObject]];
	[transformArray removeLastObject];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
}

-(void)translateBy:(NSPoint)point {
	[[CFATransform sharedManager] translateByX:point.x andY:point.y];
}

-(void)translateByX:(NSInteger)x andY:(NSInteger)y {
	[[transformArray lastObject] translateXBy:x yBy:y];
}

-(void)rotateByAngle:(CGFloat)angle {
	[[transformArray lastObject] rotateByDegrees:angle];
}
@end
