//
//  LogEntry.h
//  Logbook
//
//  Created by Dulio Denis on 3/27/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ENUM(int16_t, LogEntryMood) {
    kLogEntryMoodGood = 0,
    kLogEntryMoodAverage = 1,
    kLogEntryMoodBad = 2
};

@interface LogEntry : NSManagedObject

@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSData * image;
@property (nonatomic) int16_t mood;
@property (nonatomic, retain) NSString * location;

@end
