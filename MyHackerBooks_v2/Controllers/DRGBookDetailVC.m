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
#import "DRGSimplePDFVC.h"
#import "NotificationKeys.h"

@interface DRGBookDetailVC ()

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
    
    DRGSimplePDFVC *pdfVC = [[DRGSimplePDFVC alloc] initWithBook:self.book];
    [self.navigationController pushViewController:pdfVC animated:YES];
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
    self.favoriteBtn.selected = self.book.isFavorite;
    self.coverImageView.image = [DRGDownloadManager downloadCoverImageForBook:self.book ofLibrary:self.library];
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
    // Is splitVC's table visible?
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.rightBarButtonItem = svc.displayModeButtonItem;
        // NOTE: BarBtn item is provided by the splitVC
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - DRGLibraryTableVCDelegate

- (void)libraryTableVC:(DRGLibraryTableVC *)libraryTableVC didSelectCharacter:(DRGBook *)book {
    self.book = book;
    [self updateViewContent];
}


@end
