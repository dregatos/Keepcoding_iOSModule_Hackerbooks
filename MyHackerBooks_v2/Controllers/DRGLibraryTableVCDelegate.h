//
//  DRGLibraryTableVCDelegate.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;

@class DRGLibraryTableVC;
@class DRGBook;

@protocol DRGLibraryTableVCDelegate <NSObject>

@optional
- (void)libraryTableVC:(DRGLibraryTableVC *)libraryTableVC didSelectCharacter:(DRGBook *)book;

@end
