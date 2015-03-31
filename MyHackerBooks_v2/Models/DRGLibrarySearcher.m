//
//  DRGLibraryAnalyzer.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGLibrarySearcher.h"
#import "DRGBook.h"

@implementation DRGLibrarySearcher

+ (NSArray *)bookListAlphabeticallySortedByTitle:(NSArray *)unorderedList {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [unorderedList sortedArrayUsingDescriptors:sortDescriptors];
}

+ (NSArray *)sortedTagListForBooks:(NSArray *)books {
    
    NSMutableArray *tagList = [[NSMutableArray alloc] init];
    for (DRGBook *book in books) {
        for (NSString *tag in book.tagList) {
//            NSLog(@"Found tag: %@", tag);
            if (![tagList containsObject:tag] && tag) {
                [tagList addObject:tag];
            }
        }
    }
    
    NSArray *orderedList = [tagList sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return orderedList;
}

+ (NSArray *)sortedBookList:(NSArray *)books forTag:(NSString *)tag {

    NSMutableArray *bookList = [[NSMutableArray alloc] init];
    for (DRGBook *book in books) {
        for (NSString *bookTag in book.tagList) {
            if ([bookTag isEqualToString:tag] && tag) {
                [bookList addObject:book];
            }
        }
    }
    
    NSArray *orderedList = [DRGLibrarySearcher bookListAlphabeticallySortedByTitle:bookList];
    return orderedList;
}

+ (NSArray *)sortedFavoriteBookList:(NSArray *)books {
    
    NSMutableArray *bookList = [[NSMutableArray alloc] init];
    for (DRGBook *book in books) {
        if (book.isFavorite) {
            [bookList addObject:book];
        }
    }
    
    NSArray *orderedList = [DRGLibrarySearcher bookListAlphabeticallySortedByTitle:bookList];
    return orderedList;
}


@end
