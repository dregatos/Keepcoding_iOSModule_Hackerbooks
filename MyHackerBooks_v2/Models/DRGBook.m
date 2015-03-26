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

@end

@implementation DRGBook

#pragma mark - Init

+ (instancetype)bookWithTitle:(NSString *)title
                      authors:(NSArray *)authorList
                         tags:(NSArray *)tagList
                coverImageURL:(NSURL *)coverURL
                    andPDFURL:(NSURL *)PDFURL {
    
    return [[self alloc] initWithTitle:title authors:authorList tags:tagList coverImageURL:coverURL andPDFURL:PDFURL];
}

- (id)initWithTitle:(NSString *)title
            authors:(NSArray *)authorList
               tags:(NSArray *)tagList
      coverImageURL:(NSURL *)coverURL
          andPDFURL:(NSURL *)PDFURL {
    
    if (self = [super init]) {
        _title = title;
        _authorList = authorList;
        _tagList = tagList;
        _coverImageURL = coverURL;
        _PDFFileURL = PDFURL;
    }
    
    return self;
}

#pragma mark - JSON

- (id)initWithDictionary:(NSDictionary *)aDict {
    
    return [self initWithTitle:[aDict objectForKey:@"title"]
                       authors:[aDict objectForKey:@"authors"]
                          tags:[aDict objectForKey:@"tags"]
                 coverImageURL:[NSURL URLWithString:[aDict objectForKey:@"image_url"]]
                     andPDFURL:[NSURL URLWithString:[aDict objectForKey:@"pdf_url"]]];
}

- (NSDictionary *)proxyForJSON {
    
    return @{@"authors"   : self.authorList,
             @"image_url" : [NSString stringWithFormat:@"%@", self.coverImageURL],
             @"pdf_url"   : [NSString stringWithFormat:@"%@",self.PDFFileURL],
             @"tags"      : self.tagList,
             @"title"     : self.title
             };
}

#pragma mark - Utils

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: Title: %@\nAuthors: %@\nTags: %@\nCover: %@\nPDF: %@\nisFavorite:%i",
            [self class], self.title, self.authorList, self.tagList, self.coverImageURL, self.PDFFileURL, self.isFavorite];
}


@end
