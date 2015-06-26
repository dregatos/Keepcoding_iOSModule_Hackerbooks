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

@property (nonatomic, strong) DRGBook *book;
@property (nonatomic, strong) ReaderViewController *readerVC;

@end

@implementation DRGPDFReaderVC

#pragma mark - Init

- (instancetype)initWithBook:(DRGBook *)aBook {
    if (self = [super init]) {
        _book = aBook;
    }
    return self;
}


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
    
    // Get updated book
    self.book = notification.userInfo[BOOK_KEY];
    
    [self updateViewContent];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self updateViewContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
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

#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helpers

- (void)updateViewContent {
    // Get pdf
    NSData *pdfData = [DRGDownloadManager downloadPDFForBook:self.book];
    if (!pdfData) {
        NSLog(@"Sorry. This book is not available.");
        [[[UIAlertView alloc]initWithTitle:@"Sorry. This book is not available."
                                   message:nil
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];
        return;
    }
    
    // Create  ReaderDocument
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    NSString *filePath = [self.book.PDFFileURL path];
    NSLog(@"PDF filePath for ReaderDocument: %@", filePath);
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    // Update content view
    [self.readerVC.view removeFromSuperview];
    if (document != nil) { // Must have a valid ReaderDocument object in order to proceed with things
        
        self.readerVC = nil;
        self.readerVC = [[ReaderViewController alloc] initWithReaderDocument:document];
        self.readerVC.delegate = self;
        self.readerVC.view.frame = self.view.frame;
        
        [self.view addSubview:self.readerVC.view];
        
    } else  {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}

@end
