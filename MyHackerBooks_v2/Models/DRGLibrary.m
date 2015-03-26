//
//  DRGLibrary.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGLibrary.h"
#import "DRGDownloadManager.h"
#import "DRGLibraryParser.h"
#import "DRGLibraryAnalyzer.h"
#import "DRGBook.h"

@interface DRGLibrary ()

@property (nonatomic, strong) DRGLibraryAnalyzer *analyzer;
@property (nonatomic, strong) NSArray *books;             // Full list of books. Unordered

@end

@implementation DRGLibrary

- (DRGLibraryAnalyzer *)analyzer  {
    if  (!_analyzer) _analyzer = [[DRGLibraryAnalyzer alloc] init];
    return _analyzer;
}

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
        _books = books;
    }
    
    return self;
}

#pragma mark - Public methods

- (NSArray *)bookList {
    return [self.analyzer bookListAlphabeticallyOrderedByTitle:self.books];
}

- (NSUInteger)booksCount {
    return [self.books count];
}

- (NSArray *)tags {
    return [self.analyzer orderedTagListForBooks:self.books];
}

- (NSUInteger)bookCountForTag:(NSString *)tag {
    NSArray *list = [self.analyzer orderedBookListForTag:tag onBooks:self.books];
    return [list count];
}

- (NSArray *)booksForTag:(NSString *)tag {
    return [self.analyzer orderedBookListForTag:tag onBooks:self.books];
}

- (DRGBook *)bookForTag:(NSString *)tag atIndex:(NSUInteger)index {
    NSArray *list = [self.analyzer orderedBookListForTag:tag onBooks:self.books];
    return [list objectAtIndex:index];
}

#pragma mark - Utils

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: Library | Number of books: %lu | Number of tags:%lu",
            [self class], [self booksCount], [[self tags] count]];
}


@end
