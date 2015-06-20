//
//  DRGLibraryPresenter.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 19/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGLibraryPresenter.h"
#import "DRGBook.h"
#import "DRGLibrary.h"

@interface DRGLibraryPresenter ()

@property (nonatomic, strong) DRGLibrary *library;

@end

@implementation DRGLibraryPresenter

#pragma mark - Init

+ (instancetype)libraryWithLibrary:(DRGLibrary *)aLibrary {
    return [[self alloc] initWithLibrary:aLibrary];
}

- (instancetype)initWithLibrary:(DRGLibrary *)aLibrary {
    if (self = [super init]) {
        _library = aLibrary;
    }
    return self;
}

#pragma mark - Properties

- (NSUInteger)bookCount {
    return [self.library.books count];
}

- (NSArray *)tags {
    
    if ([self bookCountForTag:FAVORITE_TAG]) {
        NSMutableArray *mArr = [[self.library.tags sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]
                                mutableCopy];
        [mArr removeObject:FAVORITE_TAG];
        [mArr insertObject:FAVORITE_TAG atIndex:0];
        return [mArr copy];
    }
    
    return [self.library.tags sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark - UITableViewController helpers

- (NSUInteger)bookCountForTag:(NSString *)tagString {
    return [[self booksForTag:tagString] count];
}

- (NSArray *)booksForTag:(NSString *)tagString {
    
    if (!tagString || [tagString isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray *bookList = [[NSMutableArray alloc] init];
    for (DRGBook *book in self.library.books) {
        for (NSString *bookTag in book.tagList) {
            if ([bookTag isEqualToString:tagString] && tagString) {
                [bookList addObject:book];
            }
        }
    }
    
    NSArray *orderedList = [self bookListAlphabeticallySortedByTitle:bookList];
    return orderedList;
}

- (DRGBook *)bookForTag:(NSString *)tagString atIndex:(NSUInteger)index {
    
    NSArray *list = [self booksForTag:tagString];
    if ([list count] > index) {
        return [list objectAtIndex:index];
    }
    
    return nil;
}

#pragma mark - Helpers

- (NSArray *)bookListAlphabeticallySortedByTitle:(NSArray *)unorderedList {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [unorderedList sortedArrayUsingDescriptors:sortDescriptors];
}


@end
