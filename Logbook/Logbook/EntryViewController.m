//
//  EntryViewController.m
//  Logbook
//
//  Created by Dulio Denis on 3/27/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "EntryViewController.h"
#import "LogEntry.h"
#import "CoreDataStack.h"

@interface EntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation EntryViewController


#pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.logEntry) {
        self.textField.text = self.logEntry.body;
    }
}


- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Core Data Methods

- (void)insertLogEntry {
    CoreDataStack *cds = [CoreDataStack defaultStack];
    LogEntry *log = [NSEntityDescription insertNewObjectForEntityForName:@"LogEntry" inManagedObjectContext:cds.managedObjectContext];
    log.body = self.textField.text;
    log.date = [[NSDate date] timeIntervalSince1970];
    [cds saveContext];
}


- (void)updateLogEntry {
    self.logEntry.body = self.textField.text;
    
    CoreDataStack *cds = [CoreDataStack defaultStack];
    [cds saveContext];
}


- (IBAction)doneWasPressed:(id)sender {
    if (self.logEntry) {
        [self updateLogEntry];
    } else {
        [self insertLogEntry];
    }
    [self dismissSelf];
}


- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}

@end
