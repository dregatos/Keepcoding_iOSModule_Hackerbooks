//
//  DRGPersistanceManager.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;
@import UIKit.UIImage;

@class DRGLibrary;
@class DRGBook;

@interface DRGPersistanceManager : NSObject

#pragma mark - Library

/** Returns YES if saving process success */
+ (BOOL)saveLibraryOnDocumentsFolder:(DRGLibrary *)aLibrary;

/** Fetchs the library stored on the Documents folder */
+ (DRGLibrary *)loadLibraryFromDocumentsFolder;

#pragma mark - Cover images cache

/** Returns local URL when the image was saved. If 'nil' then it was an error... */
+ (NSURL *)saveCoverImage:(UIImage *)image ofBook:(DRGBook *)aBook;

/**  */
+ (UIImage *)loadCoverImageOfBook:(DRGBook *)aBook;

#pragma mark - PDF files cache

/** Returns local URL when the image was saved. If 'nil' then it was an error... */
+ (NSURL *)savePDFFile:(NSData *)pdfData ofBook:(DRGBook *)aBook;

/**  */
+ (NSData *)loadPDFFileOfBook:(DRGBook *)aBook;

@end
