//
//  DRGLibrary.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGLibrary.h"
#import "DRGLibraryParser.h"
#import "DRGLibrarySearcher.h"

#import "NotificationKeys.h"

#import "DRGPersistanceManager.h"

#import "DRGBook.h"

@interface DRGLibrary ()

@property (nonatomic, strong) NSArray *books;             // Full list of books. Unordered

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
        _books = books;
    }
    
    return self;
}

#pragma mark - Public methods

- (void)didUpdateBookContent:(DRGBook *)aBook {
    
    if ([self.books containsObject:aBook]) {  //Only if it belongs to our Library
        
        // Update content of library
        NSMutableArray *mList = [self.books mutableCopy];
        NSUInteger index = [mList indexOfObject:aBook];
        [mList replaceObjectAtIndex:index withObject:aBook];
        
        self.books = [mList copy];
        
        NSLog(@"Library was updated");
        
        // Save updated library
        [DRGPersistanceManager saveLibraryOnDocumentsFolder:self];
        
        // Notify library was updated
        NSDictionary *dict = @{LIBRARY_KEY:self};
        [[NSNotificationCenter defaultCenter] postNotificationName:LIBRARY_DID_CHANGE_NOTIFICATION_NAME object:self userInfo:dict];
    }
}

- (NSArray *)bookList {
    return [DRGLibrarySearcher bookListAlphabeticallySortedByTitle:self.books];
}

- (NSUInteger)booksCount {
    return [self.books count];
}

- (NSArray *)favoriteBookList {
    return [DRGLibrarySearcher sortedFavoriteBookList:self.books];
}

- (NSUInteger)favoriteBooksCount {
    NSArray *list = [DRGLibrarySearcher sortedFavoriteBookList:self.books];
    return [list count];
}

- (NSArray *)tags {
    return [DRGLibrarySearcher sortedTagListForBooks:self.books];
}

- (NSUInteger)bookCountForTag:(NSString *)tag {
    NSArray *list = [DRGLibrarySearcher sortedBookList:self.books forTag:tag];
    return [list count];
}

- (NSArray *)booksForTag:(NSString *)tag {
    return [DRGLibrarySearcher sortedBookList:self.books forTag:tag];
}

- (DRGBook *)bookForTag:(NSString *)tag atIndex:(NSUInteger)index {
    NSArray *list = [DRGLibrarySearcher sortedBookList:self.books forTag:tag];
    return [list objectAtIndex:index];
}

#pragma mark - Utils

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: Library | Number of books: %lu | Number of tags:%lu",
            [self class], (unsigned long)[self booksCount], (unsigned long)[[self tags] count]];
}


@end
