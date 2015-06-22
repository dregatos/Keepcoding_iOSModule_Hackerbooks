//
//  DRGLibraryPresenter.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 19/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRGLibrary;
@class DRGBook;

@interface DRGLibraryPresenter : NSObject

/* 
 Total number of books 
 */
@property (nonatomic, readonly) NSUInteger bookCount;

/** 
 Sorted Array of tags (Favorites is the first tag)
 */
@property (nonatomic, readonly) NSArray *tags;

+ (instancetype)libraryWithLibrary:(DRGLibrary *)aLibrary;

- (instancetype)initWithLibrary:(DRGLibrary *)aLibrary;

/**
 Returns the number of books for a given 'tag'
 */
- (NSUInteger)bookCountForTag:(NSString *)tagString;

/**
 Returns an ordered list (alphabetically) of books for a given 'tag'
 */
- (NSArray *)booksForTag:(NSString *)tagString;

/**
 Returns the book at given index of the ordered list (alphabetically)
 of books for a given 'tag'
 */
- (DRGBook *)bookForTag:(NSString *)tagString atIndex:(NSUInteger)index;

@end
