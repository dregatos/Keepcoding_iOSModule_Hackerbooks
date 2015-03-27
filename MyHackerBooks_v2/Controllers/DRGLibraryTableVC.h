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

#pragma mark - Protocol

@protocol DRGLibraryTableVCDelegate <NSObject>

@optional
- (void)libraryTableVC:(DRGLibraryTableVC *)libraryTableVC didSelectCharacter:(DRGBook *)book;

@end


@interface DRGLibraryTableVC : UITableViewController

@property (nonatomic, strong) DRGLibrary *library;
@property (nonatomic, weak) id<DRGLibraryTableVCDelegate> delegate;

- (id)initWithLibrary:(DRGLibrary *)aLibrary style:(UITableViewStyle)style;

@end
