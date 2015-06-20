//
//  DRGLibraryTableVC.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit;

@class DRGBook;
@class DRGLibraryPresenter;
@class DRGLibraryTableVC;

#import "DRGLibraryTableVCDelegate.h"

@interface DRGLibraryTableVC : UITableViewController <DRGLibraryTableVCDelegate>

// delegate
@property (nonatomic, weak) id<DRGLibraryTableVCDelegate> delegate;

//@property (nonatomic, strong) DRGLibrary *library;

- (id)initWithLibraryPresenter:(DRGLibraryPresenter *)libraryPresenter
                         style:(UITableViewStyle)style;

@end