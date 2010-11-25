//
//  CFAFoundation.h
//  CocoaForArtists
//
//  Created by Travis Kirton on 10-09-12.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CFAFoundation : NSObject {
	
}

#pragma mark Singleton
-(id)_init;
+(CFAFoundation *)sharedManager;

#pragma mark Foundation 
void CFALog(NSString *logString,...);

@end
