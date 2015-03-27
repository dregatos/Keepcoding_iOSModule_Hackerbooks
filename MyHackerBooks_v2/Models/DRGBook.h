//
//  DRGBook.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRGBook : NSObject

/** Provided by the server */
@property (nonatomic, copy) NSString *title;            // Copy
@property (nonatomic, readonly) NSArray *authorList;    // Readonly. Arr of NSStrings
@property (nonatomic, readonly) NSArray *tagList;       // Readonly. Arr of NSStrings

/** If the file was download and saved locally,
    it will be the local URL, wheter it will be
    the URL provided by the server. */
@property (nonatomic, copy) NSURL *coverImageURL;       // Copy
@property (nonatomic, copy) NSURL *PDFFileURL;          // Copy

/** Determined by the user at runtime */
@property (nonatomic, readonly) BOOL isFavorite;

#pragma mark - Factory methods

+ (instancetype)bookWithTitle:(NSString *)title
                      authors:(NSArray *)authorList
                         tags:(NSArray *)tagList
                coverImageURL:(NSURL *)coverURL
                    andPDFURL:(NSURL *)PDFURL;

#pragma mark - Initializers

- (id)initWithTitle:(NSString *)title
            authors:(NSArray *)authorList
               tags:(NSArray *)tagList
      coverImageURL:(NSURL *)coverURL
          andPDFURL:(NSURL *)PDFURL;


#pragma mark - JSON

- (id)initWithDictionary:(NSDictionary *)aDic;

- (NSDictionary *)proxyForJSON;

#pragma mark - Others

- (void)toggleFavoriteStatus;


@end
