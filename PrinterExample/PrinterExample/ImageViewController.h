//
//  ViewController.h
//  PrinterExample
//
//  Created by King on 08/12/2017.
//  Copyright © 2017 Printer. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "StyleButton.h"

@interface ImageViewController : UIViewController<UIImagePickerControllerDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong) NSString * fileUrl;
@property(nonatomic,strong) NSString * fileTitle;
@property (weak, nonatomic) IBOutlet StyleButton *btnPrint;
@property (weak, nonatomic) IBOutlet UITextField *txtlimitWidth;

@end

