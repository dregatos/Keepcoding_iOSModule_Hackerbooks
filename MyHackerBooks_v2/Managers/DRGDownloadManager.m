//
//  DRGLibraryDownloader.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGDownloadManager.h"
#import "DRGLibrary.h"

@implementation DRGDownloadManager

+ (DRGLibrary *)downloadLibraryFromServer {
    // Download library
    NSData *libraryData = [DRGDownloadManager downloadJSONFromURL:[NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"]];
    
    // Create library
    DRGLibrary *library = [DRGLibrary libraryWithJSONData:libraryData];
    
    return library;
}

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
