//
//  DRGLibrary.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRGBook;

@interface DRGLibrary : NSObject

#pragma mark - Init

+ (instancetype)libraryWithJSONData:(NSData *)jsonData;

- (instancetype)initWithJSONData:(NSData *)jsonData;       


#pragma mark - UITableViewController helpers

/** 
    Marks given book as favorite, updates the library and 
    returns the updated library.
 */
- (DRGLibrary *)markBookAsFavorite:(DRGBook *)aBook;

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
