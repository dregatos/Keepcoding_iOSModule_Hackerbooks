//
//  DRGLibraryDownloader.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGDownloadManager.h"
#import "DRGPersistanceManager.h"
#import "DRGLibrary.h"
#import "DRGBook.h"

@implementation DRGDownloadManager

#pragma mark - Library

+ (DRGLibrary *)downloadLibraryFromServer {
    // Download library
    NSData *libraryData = [DRGDownloadManager downloadJSONFromURL:[NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"]];
    
    // Create library
    DRGLibrary *library = [DRGLibrary libraryWithJSONData:libraryData];
    
    return library;
}

#pragma mark - Cover Images

+ (UIImage *)downloadCoverImageForBook:(DRGBook *)aBook {

    if ([aBook.coverImageURL isFileURL]) {
        // If cover image was stored on disk, then return it.
        return [DRGPersistanceManager loadCoverImageOfBook:aBook];
        
    } else {
        // If not, download & save it into disk.
        NSData *imageData = [NSData dataWithContentsOfURL:aBook.coverImageURL];
        UIImage *cover = [UIImage imageWithData:imageData];
        NSURL *coverLocalURL = [DRGPersistanceManager saveCoverImage:cover ofBook:aBook];
        if (coverLocalURL) { // local URL
            // Update book info
            [aBook updateCoverImageURL:coverLocalURL];
        }
        
        return cover;
    }
}

#pragma mark - PDF files

+ (NSData *)downloadPDFForBook:(DRGBook *)aBook {
    
    if ([aBook.PDFFileURL isFileURL]) {
        // If cover image was stored on disk, then return it.
        return [DRGPersistanceManager loadPDFFileOfBook:aBook];
        
    } else {
        // If not, download & save it into disk.
        NSData *pdfData = [NSData dataWithContentsOfURL:aBook.PDFFileURL];
        NSURL *pdfLocalURL = [DRGPersistanceManager savePDFFile:pdfData ofBook:aBook];
        if (pdfLocalURL) { // local URL
            // Update book info
            [aBook updatePDFFileURL:pdfLocalURL];
        }
        
        return pdfData;
    }
}

#pragma mark - Helpers

+ (NSData *)downloadJSONFromURL:(NSURL *)jsonURL {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:jsonURL];
    
    NSError *error;
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error || data == nil) {
        NSLog(@"Download data failed. Error: %@", error.localizedDescription);
    }
    
    return data;
}

@end
