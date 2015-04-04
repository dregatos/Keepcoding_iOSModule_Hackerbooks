//
//  DRGPDFReaderVC.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 02/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGPDFReaderVC.h"
#import "DRGBook.h"
#import "NotificationKeys.h"
#import "DRGDownloadManager.h"
#import "DRGLibrary.h"
#import "DRGBookDetailVC.h"
#import "ReaderViewController.h"

@interface DRGPDFReaderVC () <ReaderViewControllerDelegate>

@end

@implementation DRGPDFReaderVC

#pragma mark - Notification

- (void)dealloc {
    [self unregisterForNotifications];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifySelectedBookDidChange:)
                                                 name:BOOK_WAS_SELECTED_NOTIFICATION_NAME
                                               object:nil];
}

- (void)unregisterForNotifications {
    // Clear out _all_ observations that this object was making
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// BOOK_WAS_SELECTED_NOTIFICATION_NAME
- (void)notifySelectedBookDidChange:(NSNotification *)notification {
    
    /*
    // Get updated book
    DRGBook *newBook = notification.userInfo[BOOK_KEY];

    // Update model
    DRGBookDetailVC *parentVC = (DRGBookDetailVC *)[self.navigationController.viewControllers firstObject];
    DRGLibrary *library = parentVC.library;
    NSData *pdfData = [DRGDownloadManager downloadPDFForBook:newBook ofLibrary:library];
    if (!pdfData) {
        NSLog(@"Sorry. This book is not available.");
        return;
    }
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    NSString *filePath = [newBook.PDFFileURL path];
    NSLog(@"PDF filePath for ReaderDocument: %@", filePath);
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];

    // Update content view
    if (document != nil) { // Must have a valid ReaderDocument object in order to proceed with things
        
        // NOTE: I could't find any method to reload the view's content...
        
    } else  {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
     */
    
    [self.delegate dismissReaderViewController:self];
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationController.navigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self updateViewContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Notifications **********************
    [self registerForNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
    [self unregisterForNotifications];   //optionally we can unregister a notification when the view disappears
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)updateViewContent {
    
}

@end
