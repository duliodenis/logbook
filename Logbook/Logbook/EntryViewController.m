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

@interface EntryViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) enum LogEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic) UIImage *pickedImage;
@end

@implementation EntryViewController


#pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date;
    
    if (self.logEntry) {
        self.textView.text = self.logEntry.body;
        self.pickedMood = self.logEntry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.logEntry.date];
        if (self.logEntry.image) {
            self.pickedImage = [UIImage imageWithData:self.logEntry.image];
        }
    } else {
        self.pickedMood = kLogEntryMoodGood;
        date = [NSDate date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    self.textView.inputAccessoryView = self.accessoryView;
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame) / 2.0f;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}


- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Image Source Methods

- (void)promptForSource {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Image Source"
                                                                             message:@"Please select which source you prefer"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Camera", @"Camera action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self promptForCamera];
                                   }];
    UIAlertAction *photoRollAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Photo Roll", @"Photo Roll action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self promptForPhotoRoll];
                                   }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoRollAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.pickedImage = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
     [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)setPickedImage:(UIImage *)pickedImage {
    _pickedImage = pickedImage;
    
    if (!pickedImage) {
        [self.imageButton setImage:[UIImage imageNamed:@"noImage"] forState:UIControlStateNormal];
    } else {
        NSLog(@"Set the image");
        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
    }
}


#pragma mark - Core Data Methods

- (void)insertLogEntry {
    CoreDataStack *cds = [CoreDataStack defaultStack];
    LogEntry *log = [NSEntityDescription insertNewObjectForEntityForName:@"LogEntry" inManagedObjectContext:cds.managedObjectContext];
    log.body = self.textView.text;
    log.date = [[NSDate date] timeIntervalSince1970];
    log.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    [cds saveContext];
}


- (void)updateLogEntry {
    self.logEntry.body = self.textView.text;
    self.logEntry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    
    CoreDataStack *cds = [CoreDataStack defaultStack];
    [cds saveContext];
}


- (void)setPickedMood:(enum LogEntryMood)pickedMood {
    _pickedMood = pickedMood;
    
    self.badButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    
    switch (pickedMood) {
        case kLogEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
            
        case kLogEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
            
        case kLogEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
            
        default:
            break;
    }
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


- (IBAction)badWasPressed:(id)sender {
    self.pickedMood = kLogEntryMoodBad;
}


- (IBAction)averageWasPressed:(id)sender {
    self.pickedMood = kLogEntryMoodAverage;
}


- (IBAction)goodWasPressed:(id)sender {
    self.pickedMood = kLogEntryMoodGood;
}


- (IBAction)imageButtonWasPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}




@end
