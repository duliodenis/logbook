//
//  NewEntryViewController.m
//  Logbook
//
//  Created by Dulio Denis on 3/27/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "NewEntryViewController.h"
#import "LogEntry.h"
#import "CoreDataStack.h"

@interface NewEntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation NewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)insertLogEntry {
    CoreDataStack *cds = [CoreDataStack defaultStack];
    LogEntry *log = [NSEntityDescription insertNewObjectForEntityForName:@"LogEntry" inManagedObjectContext:cds.managedObjectContext];
    log.body = self.textField.text;
    log.date = [[NSDate date] timeIntervalSince1970];
    [cds saveContext];
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneWasPressed:(id)sender {
    [self insertLogEntry];
    [self dismissSelf];
}
- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}

@end
