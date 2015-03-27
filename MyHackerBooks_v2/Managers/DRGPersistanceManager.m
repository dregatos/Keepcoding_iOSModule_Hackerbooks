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

- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (NSURL *)documentsFolderURL {
    // Get path to the Documents folder
    NSURL *documentsURL = [[self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return documentsURL;
}

- (NSURL *)localLibraryURL  {
    return [[self documentsFolderURL] URLByAppendingPathComponent:@"library.txt"];
}

#pragma mark - Save library

+ (BOOL)saveLibraryOnDocumentFolder:(DRGLibrary *)aLibrary {
    
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
    if (![jsonData writeToURL:[[self alloc] localLibraryURL] atomically:YES]) {  // Save library database and check result
        NSLog(@"There was an error saving the library data base into the Documents folder");
        return NO;
    }
    
    return YES;  // Succesfully saved
}

#pragma mark - Load local library

+ (DRGLibrary *)loadLibraryFromDocumentFolder {
    
    NSData *data = [NSData dataWithContentsOfURL:[[self alloc] localLibraryURL]];
    // Create the Library
    DRGLibrary *library = [DRGLibrary libraryWithJSONData:data];
    
    return library;
}

#pragma mark - Save cover images and pdf's

+ (void)saveResourcesOfLibrary:(DRGLibrary *)aLibrary {
    
    for (DRGBook *book in aLibrary.bookList) {
        
        /** Remove whitespace from book.title to avoid problems */
        NSString *fileName = [book.title stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSURL *folderURL = [[self  alloc] documentsFolderURL];
        
        // Save the cover image
        NSData *imageData = [NSData dataWithContentsOfURL:book.coverImageURL];
        UIImage *cover = [UIImage imageWithData:imageData];
        NSURL *coverLocalURL = [[self alloc] saveImage:cover
                                           onFolderURL:folderURL
                                              withName:fileName];
        if (coverLocalURL) { // Save local URL
            book.coverImageURL = coverLocalURL;
        }
        
        // Save PDF
        NSData *pdfData = [NSData dataWithContentsOfURL:book.PDFFileURL];
        NSURL *pdfLocalURL = [[self alloc] savePDF:pdfData
                                       onFolderURL:folderURL
                                          withName:fileName];
        if (pdfLocalURL) {  // Save local URL
            book.PDFFileURL = pdfLocalURL;
        }
    }
    
    // Save library (the NSData) again, containing local URLs
    [DRGPersistanceManager saveLibraryOnDocumentFolder:aLibrary];
}

- (NSURL *)saveImage:(UIImage *)image onFolderURL:(NSURL *)folderURL withName:(NSString *)aName {
    
    NSError *error;
    //check if the cache directory is writable
    if ([self.fileManager isWritableFileAtPath:[folderURL path]]) {
        //check if the directory of our image is already exist
        if ([self.fileManager createDirectoryAtURL:folderURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            //create the complete url
            NSURL *fileToWrite = [[folderURL URLByAppendingPathComponent:aName isDirectory:NO] URLByAppendingPathExtension:@"jpg"];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.);
            if ([imageData writeToURL:fileToWrite options:NSDataWritingAtomic error:&error]) {
//                NSLog(@"Image saved at URL: %@",fileToWrite);
                return fileToWrite;
            }
        }
    }
    
    NSLog(@"Save Cover image failed with error: %@", error);
    return nil;
}

- (NSURL *)savePDF:(NSData *)pdfData onFolderURL:(NSURL *)folderURL withName:(NSString *)aName {
    
    NSError *error;
    //check if the cache directory is writable
    if ([self.fileManager isWritableFileAtPath:[folderURL path]]) {
        //check if the directory of our image is already exist
        if ([self.fileManager createDirectoryAtURL:folderURL withIntermediateDirectories:YES attributes:nil error:&error]) {
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
