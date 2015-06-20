//
//  DRGBookParser.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 19/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGBookParser.h"
#import "DRGBook.h"

@implementation DRGBookParser

#pragma mark - JSON

+ (DRGBook *)bookFromDictionary:(NSDictionary *)aDict {
    
    return [[DRGBook alloc] initWithTitle:[aDict objectForKey:@"title"]
                                  authors:[[self alloc] extractElementsForKey:@"authors" onDictionary:aDict]
                                     tags:[[self alloc] extractElementsForKey:@"tags" onDictionary:aDict]
                            coverImageURL:[NSURL URLWithString:[aDict objectForKey:@"image_url"]]
                                   PDFURL:[NSURL URLWithString:[aDict objectForKey:@"pdf_url"]]
                            andIsFavorite:[[aDict objectForKey:@"favorite"] boolValue]];
}

+ (NSDictionary *)proxyForJSON:(DRGBook *)aBook {
    
    NSString *imString = [NSString stringWithFormat:@"%@", aBook.coverImageURL];
    NSString *pdfString = [NSString stringWithFormat:@"%@",aBook.PDFFileURL];
    NSString *authorString = [aBook.authorList componentsJoinedByString:@","];
    NSString *tagString = [aBook.tagList componentsJoinedByString:@","];
    
    return @{@"authors"   : authorString ? authorString : @"",
             @"image_url" : imString ? imString : @"",
             @"pdf_url"   : pdfString ? pdfString : @"",
             @"tags"      : tagString ? tagString : @"",
             @"title"     : aBook.title ? aBook.title : @"",
             @"favorite"  : @(aBook.isFavorite)
             };
}

#pragma mark - Helpers

- (NSArray *)extractElementsForKey:(NSString *)key
                      onDictionary:(NSDictionary *)aDict {
    
    NSString *elements = [aDict objectForKey:key];
    NSArray *elementArr = [elements componentsSeparatedByString:@","];
    
    NSMutableArray *normalized = [NSMutableArray array];
    for (NSString *str in elementArr) {
        [normalized addObject:[self normalizeCase:str]];
    }
    
    return normalized;
}

- (NSString *)normalizeCase:(NSString *)aString {
    
    aString = [self trimWhiteSpaces:aString];
    
    NSString *norm;
    if (aString.length <= 1) {
        norm = [aString capitalizedString];
    } else {
        norm = [NSString stringWithFormat:@"%@%@",[[aString substringToIndex:1] uppercaseString],
                [[aString substringFromIndex:1]lowercaseString]];
    }
    return norm;
}

- (NSString *) trimWhiteSpaces:(NSString *)string {
    
    //Trimming the initial and final whitespaces of a string
    
    NSString *rawString = [string copy];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    return trimmedString;
}

@end
