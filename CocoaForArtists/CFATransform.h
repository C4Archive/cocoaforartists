//
//  CFATransform.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

@interface CFATransform : CFAObject {

}

-(id)_init;
+(CFATransform *)sharedManager;

//+(void)begin;
//+(void)concat;
//+(void)end;
//
//+(void)translateByX:(int)x andY:(int)y;
//+(void)translateBy:(NSPoint)point;
//+(void)rotateByAngle:(float)angle;

@end
