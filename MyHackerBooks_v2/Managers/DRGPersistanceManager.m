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

NSString * const imageFolderName = @"ImageFolder";
NSString * const pdfFolderName = @"PDFFolder";

@interface DRGPersistanceManager ()

@property (nonatomic, strong) NSFileManager *fileManager;

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

/** Document Or cache Path Changes on every launch in iOS 8 */
+ (NSURL *)currentLocalURL:(NSURL *)storedLocalURL {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *newURL = [documentsURL URLByAppendingPathComponent:[storedLocalURL lastPathComponent] isDirectory:NO];
    
//    NSLog(@"New local path: %@", [newURL absoluteString]);
//    NSLog(@"Old local path: %@", [storedLocalURL absoluteString]);
    
    return newURL;
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
    // Create the Library
    DRGLibrary *library = [DRGLibrary libraryWithJSONData:data];
    
    NSLog(@"Library was loaded from Documents/");

    return library;
}

#pragma mark - Manage Cover Images

+ (NSURL *)saveCoverImage:(UIImage *)image ofBook:(DRGBook *)aBook {
    
    /** Remove whitespace from book.title to avoid problems */
    NSString *fileName = [aBook.title stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *folderURL = [DRGPersistanceManager documentsFolderURL];
    
    // Save the cover image
    NSURL *coverLocalURL = [DRGPersistanceManager saveImage:image
                                                onFolderURL:folderURL
                                                   withName:fileName];
    return coverLocalURL;
}

+ (UIImage *)loadCoverImageOfBook:(DRGBook *)aBook {
    NSURL *url = [DRGPersistanceManager currentLocalURL:aBook.coverImageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"Cover Image %@ loaded from Documents/",[url lastPathComponent]);
    return [UIImage imageWithData:imageData];
}

+ (NSURL *)saveImage:(UIImage *)image onFolderURL:(NSURL *)folderURL withName:(NSString *)aName {
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //check if the cache directory is writable
    if ([fileManager isWritableFileAtPath:[folderURL path]]) {
        //check if the directory of our image is already exist
        if ([fileManager createDirectoryAtURL:folderURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            //create the complete url
            NSURL *fileToWrite = [[folderURL URLByAppendingPathComponent:aName isDirectory:NO] URLByAppendingPathExtension:@"jpg"];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.);
            if ([imageData writeToURL:fileToWrite options:NSDataWritingAtomic error:&error]) {
                NSLog(@"Cover Image %@ saved on Documents/",[fileToWrite lastPathComponent]);
                return fileToWrite;
            }
        }
    }
    
    NSLog(@"Save Cover image failed with error: %@", error);
    return nil;
}

+ (NSURL *)savePDF:(NSData *)pdfData onFolderURL:(NSURL *)folderURL withName:(NSString *)aName {
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //check if the cache directory is writable
    if ([fileManager isWritableFileAtPath:[folderURL path]]) {
        //check if the directory of our image is already exist
        if ([fileManager createDirectoryAtURL:folderURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            //create the complete url
            NSURL * fileToWrite = [[folderURL URLByAppendingPathComponent:aName isDirectory:NO] URLByAppendingPathExtension:@"pdf"];
            if ([pdfData writeToURL:fileToWrite options:NSDataWritingAtomic error:&error]) {
//                NSLog(@"PDF saved at URL: %@",fileToWrite);
                return fileToWrite;
            }
        }
    }
    
    NSLog(@"Save PDF failed with error: %@", error);
    return nil;
}

@end
