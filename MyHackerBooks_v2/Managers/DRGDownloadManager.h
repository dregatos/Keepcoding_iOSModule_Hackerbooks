//
//  DRGLibraryDownloader.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  DRGLibrary;

@interface DRGDownloadManager : NSObject

/** 
    Download JSON, Serialize it and Create the Library
 */
+ (DRGLibrary *)downloadLibraryFromServer;

@end
