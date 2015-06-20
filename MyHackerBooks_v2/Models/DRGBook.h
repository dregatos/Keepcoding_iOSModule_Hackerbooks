//
//  DRGBook.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;
@import UIKit.UIImage;

extern NSString * const FAVORITE_TAG;

@interface DRGBook : NSObject

@property (nonatomic, readonly) NSString *title;            // Readonly
@property (nonatomic, readonly) NSArray *authorList;        // Readonly. Arr of NSStrings
@property (nonatomic, readonly) NSMutableArray *tagList;    // Readonly. Arr of NSStrings
@property (nonatomic, readonly) NSURL *coverImageURL;       // Readonly. Use updateCoverImageURL: to change it
@property (nonatomic, readonly) NSURL *PDFFileURL;          // Readonly. Use updatePDFFileURL: to change it

/** YES if one of its tag = 'Favorite' */
@property (nonatomic, readonly) BOOL isFavorite;        // Readonly. Use toggleFavoriteStatus: to change it

#pragma mark - Factory methods

+ (instancetype)bookWithTitle:(NSString *)title
                      authors:(NSArray *)authorList
                         tags:(NSArray *)tagList
                coverImageURL:(NSURL *)coverURL
                    andPDFURL:(NSURL *)PDFURL
                andIsFavorite:(BOOL)isFavorite;

#pragma mark - Initializers

- (id)initWithTitle:(NSString *)title
            authors:(NSArray *)authorList
               tags:(NSArray *)tagList
      coverImageURL:(NSURL *)coverURL
             PDFURL:(NSURL *)PDFURL
      andIsFavorite:(BOOL)isFavorite;


#pragma mark - Modify book info/status

- (void)toggleFavoriteStatus;

- (void)updateCoverImageURL:(NSURL *)newURL;

- (void)updatePDFFileURL:(NSURL *)newURL;

- (BOOL)isPDFLocallyStored;

@end
