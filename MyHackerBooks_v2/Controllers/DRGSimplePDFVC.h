//
//  DRGSimplePDFVC.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRGBook;

@interface DRGSimplePDFVC : UIViewController

@property (nonatomic, readonly) NSData *pdf;

- (id)initWithPDF:(NSData *)pdfData;

@end
