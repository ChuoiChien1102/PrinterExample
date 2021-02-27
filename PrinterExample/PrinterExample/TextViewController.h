//
//  TextViewController.h
//  PrinterExample
//
//  Created by King on 25/12/2017.
//  Copyright © 2017 Printer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleButton.h"

@interface TextViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtViewinput;

@property (weak, nonatomic) IBOutlet StyleButton *btnPrint;
@property (weak, nonatomic) IBOutlet StyleButton *btnCancelPrint;


@end
