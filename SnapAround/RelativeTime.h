//
//  RelativeTime.h
//  RelativeTime
//
//  Created by Karim Benhmida on 15/06/2014.
//

#import <Foundation/Foundation.h>

@interface RelativeTime : NSObject

+ (NSString*)stringFromDate:(NSDate*) date;

+ (NSDate *)beginningOfDay:(NSDate *)date;
+ (NSDate *)beginningOfWeek:(NSDate *)date;
+ (NSDate *)beginningOfMonth:(NSDate *)date;

@end