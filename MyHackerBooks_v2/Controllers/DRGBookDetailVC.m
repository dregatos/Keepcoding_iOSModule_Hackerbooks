//
//  DRGBookVC.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGBookDetailVC.h"
#import "DRGDownloadManager.h"
#import "DRGBook.h"
#import "DRGLibrary.h"
#import "NotificationKeys.h"

#import "DRGPDFReaderVC.h"
#import "ReaderDocument.h"

@interface DRGBookDetailVC () <ReaderViewControllerDelegate>

@property (nonatomic, readwrite) DRGBook *book;
@property (nonatomic, readwrite) DRGLibrary *library;

@end

@implementation DRGBookDetailVC

#pragma mark - Init

- (id)initWithBook:(DRGBook *)aBook ofLibrary:(DRGLibrary *)aLibrary {

    if (self = [super init]) {
        _book = aBook;
        _library = aLibrary;
    }
    
    return self;
}

#pragma mark - Notification

- (void)dealloc {
    [self unregisterForNotifications];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyLibraryDidChange:)
                                                 name:LIBRARY_DID_CHANGE_NOTIFICATION_NAME
                                               object:self.library];
}

- (void)unregisterForNotifications {
    // Clear out _all_ observations that this object was making
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// LIBRARY_DID_CHANGE_NOTIFICATION_NAME
- (void)notifyLibraryDidChange:(NSNotification *)notification {
    
    // Get updated book
    DRGLibrary *updatedLibrary = notification.userInfo[LIBRARY_KEY];
    // Update model
    self.library = updatedLibrary;
    for (DRGBook *book in self.library.bookList) {
        if ([book isEqual:self.book]) { // (= same title, but updated information)
            self.book = book;
            break;
        }
    }
    // Update content view
    [self updateViewContent];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // If we are in a UISplit, then add a displayModeButtonItem
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

#pragma mark - IBActions

- (IBAction)readThisBookBtnPressed:(UIButton *)sender {
    
    /** 1. Download OR Load pdf */
    // NOTE: We must call downloadPDFForBook:ofLibrary: even if we are not using pdfData
    //       because this method updates the value of PDFFileURL.
    NSData *pdfData = [DRGDownloadManager downloadPDFForBook:self.book ofLibrary:self.library];
    if (!pdfData) {
        NSLog(@"Sorry. This book is not available.");
        return;
    }
    
    /** 2. Read book */
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    NSString *filePath = [self.book.PDFFileURL path];
    NSLog(@"PDF filePath for ReaderDocument: %@", filePath);
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    /** 3. Push ReaderViewController */
    if (document != nil) { // Must have a valid ReaderDocument object in order to proceed with things
        
        DRGPDFReaderVC *pdfVC = [[DRGPDFReaderVC alloc] initWithReaderDocument:document];
        
        pdfVC.delegate = self; // Set the ReaderViewController delegate to self
        [self.navigationController pushViewController:pdfVC animated:YES];
        
    } else  {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}

- (IBAction)favoriteBtnPressed:(UIButton *)sender {
    
    // update book
    [self.book toggleFavoriteStatus];
    // update library
    [self.library didUpdateBookContent:self.book];
    // sync view - model
    /** Updated through LIBRARY_DID_CHANGE_NOTIFICATION_NAME */
}

#pragma mark - Utils

- (void)updateViewContent {
    
    self.title = @"Book Information";
    
    self.titleLbl.text = self.book.title;
    self.authorListLbl.text = [self.book.authorList componentsJoinedByString:@","];
    self.tagListLbl.text = [self.book.tagList componentsJoinedByString:@","];
    self.coverImageView.image = [DRGDownloadManager downloadCoverImageForBook:self.book ofLibrary:self.library];
    self.favoriteBtn.selected = self.book.isFavorite;
    [self.readBtn setTitle:@"Read Book" forState:UIControlStateSelected];
    [self.readBtn setTitle:@"Download Book" forState:UIControlStateNormal];
    self.readBtn.selected = [self.book isPDFLocallyStored];
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
    // Is splitVC's table visible?
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
        // NOTE: BarBtn item is provided by the splitVC
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - DRGLibraryTableVCDelegate

- (void)libraryTableVC:(DRGLibraryTableVC *)libraryTableVC didSelectCharacter:(DRGBook *)book {
    self.book = book;
    [self updateViewContent];
}

#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
