//
//  DRGLibrary.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;

@class DRGBook;

@interface DRGLibrary : NSObject

#pragma mark - Init

+ (instancetype)libraryWithJSONData:(NSData *)jsonData;

- (instancetype)initWithJSONData:(NSData *)jsonData;       

/**
    Updates given book info (if it belongs to our library)
    and returns the updated library.
 */
- (void)didUpdateBookContent:(DRGBook *)aBook;


#pragma mark - UITableViewController helpers

/**
    Returns a full list of books ORDERED alphabetically
 */
- (NSArray *)bookList;

/**
    Returns the number of books in the library
 */
- (NSUInteger)booksCount;

/**
 Returns a list of favorite books ORDERED alphabetically
 */
- (NSArray *)favoriteBookList;

/**
 Returns the number of favorite books in the library
 */
- (NSUInteger)favoriteBooksCount;

/**
    Returns an ordered list (alphabetically) of the full tag list
 */
- (NSArray *)tags;

/**
    Returns the number of books for a given 'tag'
 */
- (NSUInteger)bookCountForTag:(NSString *)tag;

/**
    Returns an ordered list (alphabetically) of books for a given 'tag'
 */
- (NSArray *)booksForTag:(NSString *)tag;

/**
    Returns the book at given index of the ordered list (alphabetically)
    of books for a given 'tag'
 */
- (DRGBook *)bookForTag:(NSString *)tag atIndex:(NSUInteger)index;

@end
