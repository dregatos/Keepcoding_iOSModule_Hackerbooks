//
//  DRGLibraryAnalyzer.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRGLibraryAnalyzer : NSObject

- (NSArray *)bookListAlphabeticallyOrderedByTitle:(NSArray *)unorderedList;

- (NSArray *)orderedTagListForBooks:(NSArray *)books;

- (NSArray *)orderedBookListForTag:(NSString *)tag onBooks:(NSArray *)books;

@end
