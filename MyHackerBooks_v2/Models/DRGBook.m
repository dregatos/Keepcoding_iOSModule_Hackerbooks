//
//  DRGBook.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGBook.h"

@interface DRGBook ()

@property (nonatomic, readwrite) NSArray *authorList;   // Readwrite. Arr of NSStrings
@property (nonatomic, readwrite) NSArray *tagList;      // Readwrite. Arr of NSStrings

@property (nonatomic, readwrite) BOOL isFavorite;

@end

@implementation DRGBook

#pragma mark - Init

+ (instancetype)bookWithTitle:(NSString *)title
                      authors:(NSArray *)authorList
                         tags:(NSArray *)tagList
                coverImageURL:(NSURL *)coverURL
                    andPDFURL:(NSURL *)PDFURL
                andIsFavorite:(BOOL)isFavorite {
    
    return [[self alloc] initWithTitle:title authors:authorList tags:tagList coverImageURL:coverURL PDFURL:PDFURL andIsFavorite:isFavorite];
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
        _tagList = tagList;
        _coverImageURL = coverURL;
        _PDFFileURL = PDFURL;
        _isFavorite = isFavorite;
    }
    
    return self;
}

#pragma mark - JSON

- (id)initWithDictionary:(NSDictionary *)aDict {
    
    return [self initWithTitle:[aDict objectForKey:@"title"]
                       authors:[self extractElementsForKey:@"authors" onDictionary:aDict]
                          tags:[self extractElementsForKey:@"tags" onDictionary:aDict]
                 coverImageURL:[NSURL URLWithString:[aDict objectForKey:@"image_url"]]
                        PDFURL:[NSURL URLWithString:[aDict objectForKey:@"pdf_url"]]
                 andIsFavorite:[[aDict objectForKey:@"favorite"] boolValue]];
}

- (NSDictionary *)proxyForJSON {
    
    NSString *imString = [NSString stringWithFormat:@"%@", self.coverImageURL];
    NSString *pdfString = [NSString stringWithFormat:@"%@",self.PDFFileURL];
    NSString *authorString = [self.authorList componentsJoinedByString:@","];
    NSString *tagString = [self.tagList componentsJoinedByString:@","];

    return @{@"authors"   : authorString ? authorString : @"",
             @"image_url" : imString ? imString : @"",
             @"pdf_url"   : pdfString ? pdfString : @"",
             @"tags"      : tagString ? tagString : @"",
             @"title"     : self.title ? self.title : @"",
             @"favorite"  : @(self.isFavorite)
            };
}

#pragma mark - Properties

- (void)updateCoverImageURL:(NSURL *)newURL {
    self.coverImageURL = newURL;
}

- (void)updatePDFFileURL:(NSURL *)newURL {
    self.PDFFileURL = newURL;
}

#pragma mark - Utils

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

- (NSArray *)extractElementsForKey:(NSString *)key onDictionary:(NSDictionary *)aDict {
    
    NSString *elements = [aDict objectForKey:key];
    NSArray *elementArr = [elements componentsSeparatedByString:@","];
    
    return elementArr;
}

- (void)toggleFavoriteStatus {
    self.isFavorite = !self.isFavorite;
}


@end
