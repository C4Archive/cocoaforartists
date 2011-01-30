//
//  CFAFoundation.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

@interface CFAFoundation : NSObject {
}

#pragma mark Singleton
-(id)_init;
+(CFAFoundation *)sharedManager;

#pragma mark Foundation 
void CFALog(NSString *logString,...);
NSInteger basicSort(id obj1, id obj2, void *context);

@end
