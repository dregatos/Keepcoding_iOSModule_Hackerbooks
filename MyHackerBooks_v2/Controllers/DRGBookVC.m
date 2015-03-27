//
//  DRGBookVC.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGBookVC.h"
#import "DRGBook.h"
#import "DRGSimplePDFVC.h"

@interface DRGBookVC ()

@property (nonatomic, readwrite) DRGBook *book;

@end

@implementation DRGBookVC

#pragma mark - Init

- (id)initWithBook:(DRGBook *)aBook {
    
    if (self = [super init]) {
        _book = aBook;
    }
    
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self syncViewWithModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)readThisBookBtnPressed:(UIButton *)sender {
    
    NSError *error;
    NSData *pdfData = [NSData dataWithContentsOfURL:self.book.PDFFileURL options:0 error:&error];

    if (!pdfData) {
        NSLog(@"Sorry. This book is not available.");
        return;
    }
    
    DRGSimplePDFVC *pdfVC = [[DRGSimplePDFVC alloc] initWithPDF:pdfData];
    [self.navigationController pushViewController:pdfVC animated:YES];
}

- (IBAction)favoriteBtnPressed:(UIButton *)sender {
    
    [self.book toggleFavoriteStatus];
    [self syncViewWithModel];
}

#pragma mark - Utils

- (void)syncViewWithModel {
    
    self.title = @"Book Information";
    
    self.titleLbl.text = self.book.title;
    self.authorListLbl.text = [self.book.authorList componentsJoinedByString:@","];
    self.tagListLbl.text = [self.book.tagList componentsJoinedByString:@","];
    
    NSError *error;
    NSData *coverData = [NSData dataWithContentsOfURL:self.book.coverImageURL options:0 error:&error];
    UIImage *coverIm = [UIImage imageWithData:coverData];
    
    if (!coverIm) {
        NSLog(@"If cover image is not available, show a placeholder cover");
    }
    self.coverImageView.image = coverIm;
    
    self.favoriteBtn.selected = self.book.isFavorite;
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
    // Is splitVC's table visible?
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.rightBarButtonItem = svc.displayModeButtonItem;
        // NOTE: bar Btn item is provided by the splitVC
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - DRGLibraryTableVCDelegate

- (void)libraryTableVC:(DRGLibraryTableVC *)libraryTableVC didSelectCharacter:(DRGBook *)book {
    
    self.book = book;
    [self syncViewWithModel];
}


@end
