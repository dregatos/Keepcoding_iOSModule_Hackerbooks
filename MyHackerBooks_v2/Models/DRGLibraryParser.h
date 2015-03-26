//
//  DRGLibraryParser.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRGLibraryParser : NSObject

/** This method serialize the JSON,
    returning an array of DRGBooks
 */
- (NSArray *)parseJSONData:(NSData *)data;

@end
