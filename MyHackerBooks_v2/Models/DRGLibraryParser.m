//
//  DRGLibraryParser.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGLibraryParser.h"
#import "DRGBook.h"
#import "DRGBookParser.h"

@implementation DRGLibraryParser

#pragma mark - JSON

- (NSArray *)parseJSONData:(NSData *)data {
    
    if (!data) {
        return nil;
    }
    
    NSError *error;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    if (JSONObject == nil || error) {
        NSLog(@"JSON Parse failed with error: %@", error.userInfo);
        return nil;
    }
    
    NSArray *bookList;
    if ([JSONObject isKindOfClass:[NSArray class]]) {  // Array of dictionaries
        bookList = [self parseJSONArray:(NSArray *)JSONObject];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {   // A dictionary
        bookList = @[[self parseJSONDictionary:(NSDictionary *)JSONObject]];
    }
    
    return bookList;
}

- (NSArray *)parseJSONArray:(NSArray *)jsonArray {
    
    if (!jsonArray || ![jsonArray count]) {
        return nil;
    }
    
    NSMutableArray *books = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in jsonArray) {
        DRGBook *book = [self parseJSONDictionary:dic];
        if (book) {
            [books addObject:book];
        }
    }
    
    return [books copy];
}

- (DRGBook *)parseJSONDictionary:(NSDictionary *)jsonDic {
    return [DRGBookParser bookFromDictionary:jsonDic];
}

@end
