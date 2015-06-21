//
//  DRGBook.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGBook.h"
#import "NotificationKeys.h"

@interface DRGBook ()

@property (nonatomic, readwrite) NSString *title;               // Readwrite
@property (nonatomic, readwrite) NSArray *authorList;           // Readwrite. Arr of NSStrings
@property (nonatomic, readwrite) NSMutableArray *tagList;       // Readwrite. Arr of NSStrings
@property (nonatomic, readwrite) NSURL *coverImageURL;          // Readwrite
@property (nonatomic, readwrite) NSURL *PDFFileURL;             // Readwrite
@property (nonatomic, readwrite) BOOL isFavorite;               // Readwrite

@end

NSString * const FAVORITE_TAG = @"Favorite";

@implementation DRGBook

- (NSMutableArray *)tagList  {
    if  (!_tagList) _tagList = [[NSMutableArray alloc] init];
    return _tagList;
}

#pragma mark - Init

+ (instancetype)bookWithTitle:(NSString *)title
                      authors:(NSArray *)authorList
                         tags:(NSArray *)tagList
                coverImageURL:(NSURL *)coverURL
                    andPDFURL:(NSURL *)PDFURL
                andIsFavorite:(BOOL)isFavorite {
    
    return [[self alloc] initWithTitle:title
                               authors:authorList
                                  tags:tagList
                         coverImageURL:coverURL
                                PDFURL:PDFURL
                         andIsFavorite:isFavorite];
}

- (id)initWithTitle:(NSString *)title
            authors:(NSArray *)authorList
               tags:(NSArray *)tagList
      coverImageURL:(NSURL *)coverURL
             PDFURL:(NSURL *)PDFURL
      andIsFavorite:(BOOL)isFavorite {
    
    if (self = [super init]) {
        _title = title;
        _authorList = authorList;
        _tagList = [tagList mutableCopy];
        _coverImageURL = coverURL;
        _PDFFileURL = PDFURL;
        _isFavorite = isFavorite;
    }
    
    return self;
}

#pragma mark - Properties

- (NSURL *)coverImageURL {
    if ([_coverImageURL isFileURL]) {
        return [self currentLocalURL:_coverImageURL];
    }
    
    return _coverImageURL;
}

- (NSURL *)PDFFileURL {
    if ([_PDFFileURL isFileURL]) {
        return [self currentLocalURL:_PDFFileURL];
    }
    
    return _PDFFileURL;
}

- (void)updateCoverImageURL:(NSURL *)newURL {
    self.coverImageURL = newURL;
    [[NSNotificationCenter defaultCenter] postNotificationName:BOOK_INFO_WAS_UPDATED_NOTIFICATION_NAME
                                                        object:self
                                                      userInfo:nil];
}

- (void)updatePDFFileURL:(NSURL *)newURL {
    self.PDFFileURL = newURL;
    [[NSNotificationCenter defaultCenter] postNotificationName:BOOK_INFO_WAS_UPDATED_NOTIFICATION_NAME
                                                        object:self
                                                      userInfo:nil];
}

#pragma mark - Utils

- (void)toggleFavoriteStatus {
    self.isFavorite = !self.isFavorite;
    
    if (self.isFavorite) {
        [self.tagList addObject:FAVORITE_TAG];
    } else {
        [self.tagList removeObject:FAVORITE_TAG];
    }
    
    // Notify change
    [[NSNotificationCenter defaultCenter] postNotificationName:BOOK_INFO_WAS_UPDATED_NOTIFICATION_NAME
                                                        object:self
                                                      userInfo:nil];
}

- (BOOL)isPDFLocallyStored {
    return [self.PDFFileURL isFileURL];
}

/** Document Or cache Path Changes on every launch in iOS 8 */
- (NSURL *)currentLocalURL:(NSURL *)storedLocalURL {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *newURL = [documentsURL URLByAppendingPathComponent:[storedLocalURL lastPathComponent] isDirectory:NO];
    
    return newURL;
}

#pragma mark - Overwritten

- (BOOL)isEqual:(id)object {
    
    if ([object isKindOfClass:[self class]]) {
        return [self.title isEqualToString:((DRGBook *)object).title];
    }
    
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ Book |\nTitle: %@\nAuthors: %@\nTags: %@\nCover: %@\nPDF: %@\nisFavorite:%i",
            [self class], self.title, self.authorList, self.tagList, self.coverImageURL, self.PDFFileURL, self.isFavorite];
}

@end
