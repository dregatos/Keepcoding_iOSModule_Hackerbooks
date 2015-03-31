//
//  DRGLibraryDownloader.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;
@import UIKit.UIImage;

@class DRGBook;
@class  DRGLibrary;

@interface DRGDownloadManager : NSObject

/** Download JSON, Serialize it and Create the Library */
+ (DRGLibrary *)downloadLibraryFromServer;

/**
    If requested cover image:
 
    1. was previously download & stored, then it
    returns the local copy.
 
    2. is not stored on disk, then download, store it,
    and UPDATE the library.
 
    Filename of stored is = book's title without whitespaces
 */
+ (UIImage *)downloadCoverImageForBook:(DRGBook *)aBook ofLibrary:(DRGLibrary *)aLibrary;

@end
