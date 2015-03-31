//
//  DRGSimplePDFVC.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGSimplePDFVC.h"
#import "DRGBook.h"
#import "NotificationKeys.h"
#import "DRGDownloadManager.h"
#import "DRGLibrary.h"
#import "DRGBookDetailVC.h"

@interface DRGSimplePDFVC ()

@property (nonatomic, readwrite) DRGBook *book;

@end

@implementation DRGSimplePDFVC

#pragma mark - Init

- (id)initWithBook:(DRGBook *)aBook {
    if (self = [super init]) {
        _book = aBook;
        self.title = aBook.title;
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
    DRGBook *newBook = notification.userInfo[BOOK_KEY];
    // Update model
    self.book = newBook;
    // Update content view
    [self updateViewContent];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Assign delegates
    self.webView.delegate = self;
    
    [self updateViewContent];
    
    // Notifications **********************
    [self registerForNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unregisterForNotifications];   //optionally we can unregister a notification when the view disappears
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)updateViewContent {
    self.title = self.book.title;
    
    DRGBookDetailVC *parentVC = (DRGBookDetailVC *)[self.navigationController.viewControllers firstObject];
    DRGLibrary *library = parentVC.library;
    NSData *pdfData = [DRGDownloadManager downloadPDFForBook:self.book ofLibrary:library];
    if (!pdfData) {
        NSLog(@"Sorry. This book is not available.");
        return;
    }
    // Start loading PDF
    [self.webView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
}


#pragma mark - UIWebViewDelegate


@end
