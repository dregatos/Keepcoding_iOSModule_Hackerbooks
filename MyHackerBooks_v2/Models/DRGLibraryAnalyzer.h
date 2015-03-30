//
//  DRGLibraryAnalyzer.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRGLibraryAnalyzer : NSObject

/** Returns the given 'unorderedList' sorted alphabetically */
+ (NSArray *)bookListAlphabeticallySortedByTitle:(NSArray *)unorderedList;

/** Returns the full list of tags (sorted alphabetically) included on the given 'books' */
+ (NSArray *)sortedTagListForBooks:(NSArray *)books;

/** Returns a book list (sorted alphabetically) whose tag == given 'tag' */
+ (NSArray *)sortedBookList:(NSArray *)books forTag:(NSString *)tag;

/** Returns a book list /sorted alphabetically) containing all the books selected as 'favorite' */
+ (NSArray *)sortedFavoriteBookList:(NSArray *)books;

@end
