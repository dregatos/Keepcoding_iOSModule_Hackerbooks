//
//  DRGPersistanceManager.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRGLibrary;

@interface DRGPersistanceManager : NSObject


/** Returns YES if saving process success */
+ (BOOL)saveLibraryOnDocumentFolder:(DRGLibrary *)aLibrary;

/** Returns the library stored on the Documents folder */
+ (DRGLibrary *)loadLibraryFromDocumentFolder;

/** 
    This method download and save each book's cover and pdf file on Documents.
    It takes a while, freezing the app because (for now) we are doing this
    process on the main thread.
 */
+ (void)saveResourcesOfLibrary:(DRGLibrary *)aLibrary;

@end
