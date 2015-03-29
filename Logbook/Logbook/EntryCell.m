 //
//  EntryCell.m
//  Logbook
//
//  Created by Dulio Denis on 3/28/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "EntryCell.h"
#import "LogEntry.h"

@interface EntryCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@end

@implementation EntryCell

+ (CGFloat)heightForEntry:(LogEntry *)logEntry {
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 80.0f;
    const CGFloat minHeight = 106.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGRect boundingBox = [logEntry.body boundingRectWithSize:CGSizeMake(202, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}


- (void)configureCellForEntry:(LogEntry *)logEntry {
    self.bodyLabel.text = logEntry.body;
    self.locationLabel.text = logEntry.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:logEntry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if (logEntry.image) {
        self.mainImageView.image = [UIImage imageWithData:logEntry.image];
    } else {
        self.mainImageView.image = [UIImage imageNamed:@"noImage"];
    }
    
    if (logEntry.mood == kLogEntryMoodGood) {
        self.moodImageView.image = [UIImage imageNamed:@"happy"];
    } else if (logEntry.mood == kLogEntryMoodAverage) {
        self.moodImageView.image = [UIImage imageNamed:@"average"];
    } else if (logEntry.mood == kLogEntryMoodBad) {
        self.moodImageView.image = [UIImage imageNamed:@"bad"];
    }
}

@end
