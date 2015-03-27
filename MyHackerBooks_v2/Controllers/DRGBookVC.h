//
//  DRGBookVC.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit;

#import "DRGLibraryTableVC.h"

@class DRGBook;

@interface DRGBookVC : UIViewController <UISplitViewControllerDelegate,DRGLibraryTableVCDelegate>

@property (nonatomic, readonly) DRGBook *book;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *authorListLbl;
@property (weak, nonatomic) IBOutlet UILabel *tagListLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;

- (id)initWithBook:(DRGBook *)aBook;

@end
