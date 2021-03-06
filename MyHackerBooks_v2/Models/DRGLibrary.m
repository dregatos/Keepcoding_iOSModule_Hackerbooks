//
//  DRGLibrary.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGLibrary.h"
#import "DRGLibraryParser.h"

#import "DRGBook.h"

@interface DRGLibrary ()

@property (nonatomic, readwrite) NSMutableArray *books;      // Full list of books. Unordered
@property (nonatomic, readwrite) NSMutableArray *tags;     // Full list of tags. Unordered

@end

@implementation DRGLibrary

#pragma mark - Initializers

+ (instancetype)libraryWithJSONData:(NSData *)jsonData {
    return [[self alloc] initWithJSONData:jsonData];
}

- (instancetype)initWithJSONData:(NSData *)jsonData {
    
    if (self = [super init]) {
        // Parse JSON
        DRGLibraryParser *parser = [[DRGLibraryParser alloc] init];
        NSArray *books = [parser parseJSONData:jsonData];
        // Get books
        _books = [books mutableCopy];
    }
    
    return self;
}

#pragma mark - Properties

- (NSArray *)tags {
    NSMutableArray *tagList = [[NSMutableArray alloc] init];
    for (DRGBook *book in self.books) {
        for (NSString *tag in book.tagList) {
            if (![tagList containsObject:tag] && tag) {
                [tagList addObject:tag];
            }
        }
    }
    
    return tagList;
}

#pragma mark - Public methods

- (DRGBook *)bookTitled:(NSString *)bookTitle {
    
    if (!bookTitle || [bookTitle isEqualToString:@""]) {
        return nil;
    }
    
    for (DRGBook *book in self.books) {
        if ([book.title isEqualToString:bookTitle]) {
            return book;
        }
    }
    
    return nil;
}

#pragma mark - Helpers

- (NSUInteger)booksCount {
    return [self.books count];
}

- (NSUInteger)tagsCount {
    return [self.tags count];
}

#pragma mark - Overwritten

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: Library | Number of books: %lu | Number of tags:%lu",
            [self class], (unsigned long)[self booksCount], (unsigned long)[[self tags] count]];
}


@end
