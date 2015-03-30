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

/** Fetchs the library stored on the Documents folder */
+ (DRGLibrary *)loadLibraryFromDocumentFolder;

@end
