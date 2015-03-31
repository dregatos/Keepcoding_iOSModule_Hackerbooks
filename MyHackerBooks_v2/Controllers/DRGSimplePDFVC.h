//
//  DRGSimplePDFVC.h
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit;

@class DRGBook;

@interface DRGSimplePDFVC : UIViewController <UIWebViewDelegate>

@property (nonatomic, readonly) DRGBook *book;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithBook:(DRGBook *)aBook;

@end
