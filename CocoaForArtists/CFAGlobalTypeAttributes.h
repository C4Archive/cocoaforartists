//
//  CFAGlobalTypeAttributes.h
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-01-30.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CFAGlobalTypeAttributes : NSObject {
	@private
	NSMutableDictionary	*attributes;
}

-(id)_init;
+(CFAGlobalTypeAttributes *)sharedManager;

-(void)setObject:(id)object forKey:(NSString *)key;
-(void)setValue:(id)object forKey:(NSString *)key;
-(void)removeObjectForKey:(NSString *)key;

@property(readwrite, retain) NSMutableDictionary *attributes;

@end