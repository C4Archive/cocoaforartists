//
//  CFADateTime.h
//  CocoaForArtists
//
//  Created by Travis Kirton on 10-09-12.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CFADateTime : NSObject {
	@private
	uint64_t start;
}

#pragma mark Singleton
-(id)_init;
+(CFADateTime *)sharedManager;

#pragma mark Date & Time
+(int)day;
+(NSString *)dayString;
+(int)hour;
+(NSString *)hourString;
+(int)minute;
+(NSString *)minuteString;
+(int)month;
+(int)millis;
+(NSString *)monthString;
+(int)second;
+(NSString *)secondString;
+(int)year;

+(NSString *)dayName;
+(NSString *)monthName;

@end
