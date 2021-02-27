//
//  CodePageViewController.m
//  PrinterExample
//
//  Created by 朱正锋 on 12/03/2018.
//  Copyright © 2018 Printer. All rights reserved.
//

#import "CodePageViewController.h"
#import "CodepagelistTVController.h"
#import "PrinterManager.h"
#import "ProgressHUD.h"

@interface CodePageViewController ()
{
    PrinterManager * _printerManager;
    NSString *scodepage;
}
@end

@implementation CodePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _printerManager = [PrinterManager sharedInstance];
    self.btnSetting.disabledColor = UIColorFromHex(0x6B7A8D);
    self.btnSetting.enabled = ([PrinterManager.sharedInstance.CurrentPrinter IsOpen]);
    if (self.btnSetting.enabled)
        self.btnSetting.alpha = 1;
    else
        self.btnSetting.alpha = 0.5;

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)edtCodePageOnTouchDown:(id)sender {
    CodepagelistTVController *controller = [[CodepagelistTVController alloc] init];
    controller.delegate = self;
    [[self navigationController] pushViewController:controller animated:YES];

}

-(void)selectCodepage:(NSString *)codeName codevalue:(NSString*)codevalue{
    self.edtChooseCodePage.text = codeName;
    scodepage = codevalue;
    NSLog(@"scodepage=%@",scodepage);
  
}
- (IBAction)btnSettingOnDown:(id)sender {
    
    if ([scodepage isEqualToString:@""] ) {
        [ProgressHUD showError:@"No selected character set" Interaction:false];
        return;
    }
    
    if (_printerManager.CurrentPrinter.IsOpen){
        Cmd *cmd =  [_printerManager CreateCmdClass:(PrinterCmdType)_printerManager.CurrentPrinterCmdType];
        if (cmd == NULL)
            return;
        [cmd Clear];
        [cmd Append:[cmd GetCodePageCmd:scodepage]];//for Esc
        NSLog(@"data=%@",[cmd GetCmd]);
        if ([_printerManager.CurrentPrinter IsOpen]){
            [_printerManager.CurrentPrinter Write:[cmd GetCmd]];
        }
        
    }

}


@end
