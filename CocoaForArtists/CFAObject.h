//
//  CFAObject.h
//  ___PROJECTNAME___
//
//  Created by moi on 11-02-20.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CFAObject : NSObject {

}

-(void)listenFor:(NSString *)aNotification andRunMethod:(NSString *)aMethodName;
-(void)stopListeningFor:(NSString *)aMethodName;
-(void)postNotification:(NSString *)aNotification;

@end
