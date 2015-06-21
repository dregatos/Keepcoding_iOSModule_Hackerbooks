//
//  DRGBookViewCell.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 31/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGBookViewCell.h"
#import "DRGBook.h"
#import "DRGDownloadManager.h"
#import "NotificationKeys.h"

@interface DRGBookViewCell()

@property (nonatomic, strong) DRGBook *book;

@end

@implementation DRGBookViewCell

#pragma mark - Class methods

+ (CGFloat)height {
    return 90.f;
}

+ (NSString *)cellId {
    return NSStringFromClass(self);
}

#pragma mark - View events


- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - IBActions

- (IBAction)toggleFavoriteState:(id)sender {
    
    [self.book toggleFavoriteStatus];
    [self syncContentView];
}

#pragma mark - Public methods

- (void)configureCellForBook:(DRGBook *)book {
    self.book = book;
    [self syncContentView];
}

- (void)reset {
    self.coverImView.image = nil;  // placeholder
    self.titleLbl.text = nil;
    self.authorsLbl.text = nil;
    self.favoriteBtn.selected = nil;
}

#pragma mark - Helpers

- (void)syncContentView {
    
    self.coverImView.image = [DRGDownloadManager downloadCoverImageForBook:self.book];
    self.titleLbl.text = self.book.title;
    self.authorsLbl.text = [self.book.authorList componentsJoinedByString:@", "];
    self.favoriteBtn.selected = self.book.isFavorite;
}

@end
