//
//  EntryCell.h
//  Logbook
//
//  Created by Dulio Denis on 3/28/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LogEntry;

@interface EntryCell : UITableViewCell

+ (CGFloat)heightForEntry:(LogEntry *)logEntry;
- (void)configureCellForEntry:(LogEntry *)logEntry;

@end
