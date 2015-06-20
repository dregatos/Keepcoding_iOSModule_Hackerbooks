//
//  DRGBookParser.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 19/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import Foundation;

@class DRGBook;

@interface DRGBookParser : NSObject

#pragma mark - JSON

+ (DRGBook *)bookFromDictionary:(NSDictionary *)aDic;

+ (NSDictionary *)proxyForJSON:(DRGBook *)aBook;

@end
