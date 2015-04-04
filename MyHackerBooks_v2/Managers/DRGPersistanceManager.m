//
//  DRGPersistanceManager.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit.UIImage;

#import "DRGPersistanceManager.h"
#import "DRGLibrary.h"
#import "DRGBook.h"

@interface DRGPersistanceManager ()

@end

@implementation DRGPersistanceManager

#pragma mark - System folders URLs

+ (NSURL *)documentsFolderURL {
    // Get path to the Documents folder
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    return documentsURL;
}

+ (NSURL *)localLibraryURL  {
    return [[DRGPersistanceManager documentsFolderURL] URLByAppendingPathComponent:@"library.txt"];
}

#pragma mark - Save OR Load library

+ (BOOL)saveLibraryOnDocumentsFolder:(DRGLibrary *)aLibrary {
    
    // DRGLibrary -> JSON
    NSError *error;
    NSMutableArray *JSON = [[NSMutableArray alloc] init];
    for (DRGBook *book in aLibrary.bookList) {
        NSDictionary *dic = [book proxyForJSON];
        [JSON addObject:dic];
    }
    
    // Serialize the JSON
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about readability
                                                         error:&error];
    // Save it
    if (![jsonData writeToURL:[DRGPersistanceManager localLibraryURL] atomically:YES]) {  // Save library database and check result
        NSLog(@"There was an error saving the library data base into the Documents folder");
        return NO;
    }
    
    NSLog(@"Library was saved on Documents/");
    return YES;  // Succesfully saved
}

+ (DRGLibrary *)loadLibraryFromDocumentsFolder {
    
    NSData *data = [NSData dataWithContentsOfURL:[DRGPersistanceManager localLibraryURL]];
    NSLog(@"Library was loaded from Documents/");
    // Create the Library
    DRGLibrary *library = [DRGLibrary libraryWithJSONData:data];

    return library;
}

#pragma mark - Manage Cover Images

+ (NSURL *)saveCoverImage:(UIImage *)image ofBook:(DRGBook *)aBook {
    
    // Save the cover image
    NSData *imageData = UIImageJPEGRepresentation(image, 1.);
    NSURL *coverLocalURL = [DRGPersistanceManager saveData:imageData
                                               onFolderURL:[DRGPersistanceManager documentsFolderURL]
                                                  withName:aBook.title
                                              andExtension:@"jpg"];
    return coverLocalURL;
}

+ (UIImage *)loadCoverImageOfBook:(DRGBook *)aBook {
    NSLog(@"Cover Image %@ LOADED from Documents/",[aBook.coverImageURL lastPathComponent]);
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:aBook.coverImageURL]];
}

#pragma mark - Manage PDF files

+ (NSURL *)savePDFFile:(NSData *)pdfData ofBook:(DRGBook *)aBook {
    
    // Save the cover image
    NSURL *pdfLocalURL = [DRGPersistanceManager saveData:pdfData
                                             onFolderURL:[DRGPersistanceManager documentsFolderURL]
                                                withName:aBook.title
                                            andExtension:@"pdf"];
    return pdfLocalURL;
}

+ (NSData *)loadPDFFileOfBook:(DRGBook *)aBook {
    NSLog(@"PDF file %@ LOADED from Documents/",[aBook.PDFFileURL lastPathComponent]);
    return [NSData dataWithContentsOfURL:aBook.PDFFileURL];
}

#pragma mark - Helpers

+ (NSURL *)saveData:(NSData *)data onFolderURL:(NSURL *)folderURL withName:(NSString *)aName andExtension:(NSString *)aExtension {
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //check if the cache directory is writable
    if ([fileManager isWritableFileAtPath:[folderURL path]]) {
        //check if the directory of our image is already exist
        if ([fileManager createDirectoryAtURL:folderURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            //create the complete url
            NSURL *fullPath = [[folderURL URLByAppendingPathComponent:aName isDirectory:NO] URLByAppendingPathExtension:aExtension];
            if ([data writeToURL:fullPath options:NSDataWritingAtomic error:&error]) {
                NSLog(@"File named %@ SAVED on Documents/",[fullPath lastPathComponent]);
                return fullPath;
            }
        }
    }
    
    NSLog(@"Save file named %@ failed with error: %@",aName, error.userInfo);
    return nil;
}

@end
