//
//  DRGLibraryTableVC.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit;

@class DRGBook;
@class DRGLibrary;
@class DRGLibraryTableVC;

#import "DRGLibraryTableVCDelegate.h"
#import "DRGBookVCDelegate.h"

@interface DRGLibraryTableVC : UITableViewController <DRGBookVCDelegate>

// delegate
@property (nonatomic, weak) id<DRGLibraryTableVCDelegate> delegate;

@property (nonatomic, strong) DRGLibrary *library;

- (id)initWithLibrary:(DRGLibrary *)aLibrary style:(UITableViewStyle)style;

@end