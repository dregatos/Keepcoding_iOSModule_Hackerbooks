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

@property (nonatomic, readonly) NSMutableArray *books;      // Full list of books. Unordered
@property (nonatomic, readonly) NSMutableArray *tags;       // Full list of tags. Unordered

#pragma mark - Init

+ (instancetype)libraryWithJSONData:(NSData *)jsonData;

- (instancetype)initWithJSONData:(NSData *)jsonData;

#pragma mark -

- (DRGBook *)bookTitled:(NSString *)bookTitle;

@end
