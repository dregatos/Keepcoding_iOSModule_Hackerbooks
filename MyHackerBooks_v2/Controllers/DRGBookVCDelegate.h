//
//  DRGBookVCDelegate.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRGBook;
@class DRGBookVC;

@protocol DRGBookVCDelegate <NSObject>

@optional
- (void)bookVC:(DRGBookVC *)aBookVC didFavoriteABook:(DRGBook *)aBook;

@end
