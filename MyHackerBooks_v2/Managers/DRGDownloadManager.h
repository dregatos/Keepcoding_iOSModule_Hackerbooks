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


/** DESCRIPTION **
 
    At the moment downloads are performed in the foreground.
    Later we will add blocks and GCD to avoid blocking the app during downloads.
 */

@interface DRGDownloadManager : NSObject

/** Download JSON, Serialize it and Create the Library */
+ (DRGLibrary *)downloadLibraryFromServer;

/**
    If requested cover image:
 
    1. was previously download & stored, then it
    returns the local copy AND update the coverImageURL of the book.
 
    2. is not stored on disk, then download, store it,
    and UPDATE the library.
 
    Filename of stored image is = book's title without whitespaces
 */
+ (UIImage *)downloadCoverImageForBook:(DRGBook *)aBook ofLibrary:(DRGLibrary *)aLibrary;

/**
    If requested PDF file:

    1. was previously download & stored, then it
    returns the local copy AND update the PDFFileURL of the book.

    2. is not stored on disk, then download, store it,
    and UPDATE the library.

    Filename of stored PDF file is = book's title without whitespaces
 */
+ (NSData *)downloadPDFForBook:(DRGBook *)aBook ofLibrary:(DRGLibrary *)aLibrary;

@end
