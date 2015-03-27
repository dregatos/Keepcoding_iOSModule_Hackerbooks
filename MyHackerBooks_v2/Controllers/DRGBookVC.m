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

@property (nonatomic, readwrite) DRGBook *model;

@end

@implementation DRGBookVC

#pragma mark - Init

- (id)initWithBook:(DRGBook *)aBook {
    
    if (self = [super init]) {
        _model = aBook;
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
    
    NSData *pdfData = [NSData dataWithContentsOfURL:self.model.PDFFileURL];

    DRGSimplePDFVC *pdfVC = [[DRGSimplePDFVC alloc] initWithPDF:pdfData];
    [self.navigationController pushViewController:pdfVC animated:YES];
}

#pragma mark - Utils

- (void)syncViewWithModel {
    
    self.title = @"Book Information";
    
    self.titleLbl.text = self.model.title;
    self.authorListLbl.text = [self.model.authorList componentsJoinedByString:@","];
    self.tagListLbl.text = [self.model.tagList componentsJoinedByString:@","];
    
    NSData *coverData = [NSData dataWithContentsOfURL:self.model.coverImageURL];
    UIImage *coverIm = [UIImage imageWithData:coverData];
    self.coverImageView.image = coverIm;
}


@end
