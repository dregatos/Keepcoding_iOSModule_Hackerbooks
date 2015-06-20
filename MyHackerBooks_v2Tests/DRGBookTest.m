//
//  DRGBookTest.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 19/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DRGBook.h"

@interface DRGBookTest : XCTestCase

@end

@implementation DRGBookTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBookHasFavoriteTagAfterMarkingItAsFavorite {
    
    DRGBook *book = [[DRGBook alloc] init];
    [book toggleFavoriteStatus];
    
    XCTAssertTrue([book.tagList containsObject:FAVORITE_TAG], @"tagList should contain a 'Favorite' tag");

//    XCTAssertEqualObjects([book.tagList containsObject:@"Favorite"], book.isFavorite, @"tagList should contain a 'Favorite' tag");
    
}

@end
