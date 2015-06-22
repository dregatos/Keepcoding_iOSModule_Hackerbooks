//
//  DRGBookViewCell.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 31/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRGBook;

@interface DRGBookViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *authorsLbl;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;


+(CGFloat) height;
+(NSString *)cellId;

- (void)configureCellForBook:(DRGBook *)book;
- (void)reset;

@end
