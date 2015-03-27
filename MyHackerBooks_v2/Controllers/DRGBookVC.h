//
//  DRGBookVC.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRGBook;

@interface DRGBookVC : UIViewController

@property (nonatomic, readonly) DRGBook *model;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *authorListLbl;
@property (weak, nonatomic) IBOutlet UILabel *tagListLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

- (id)initWithModel:(DRGBook *)aBook;

@end
