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
#import "DRGSimplePDFVC.h"
#import "NotificationKeys.h"

@interface DRGBookDetailVC ()

@property (nonatomic, readwrite) DRGBook *book;

@end

@implementation DRGBookDetailVC

#pragma mark - Init

- (id)initWithBook:(DRGBook *)aBook {

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
                                             selector:@selector(notifyBookFavoriteStatusDidChange:)
                                                 name:BOOK_FAVORITE_STATUS_DID_CHANGED_NOTIFICATION_NAME
                                               object:self.book];
}

- (void)unregisterForNotifications {
    // Clear out _all_ observations that this object was making
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// BOOK_FAVORITE_STATUS_DID_CHANGED_NOTIFICATION_NAME
- (void)notifyBookFavoriteStatusDidChange:(NSNotification *)notification {
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
    
    DRGSimplePDFVC *pdfVC = [[DRGSimplePDFVC alloc] initWithBook:self.book];
    [self.navigationController pushViewController:pdfVC animated:YES];
}

- (IBAction)favoriteBtnPressed:(UIButton *)sender {
    
    // update book
    [self.book toggleFavoriteStatus];
}

#pragma mark - Utils

- (void)updateViewContent {
    
    self.title = @"Book Information";
    
    self.titleLbl.text = self.book.title;
    self.authorListLbl.text = [self.book.authorList componentsJoinedByString:@", "];
    self.tagListLbl.text = [self.book.tagList componentsJoinedByString:@", "];
    self.coverImageView.image = [DRGDownloadManager downloadCoverImageForBook:self.book];
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


@end
