//
//  TemplatePrinterController.m
//  PrinterExample
//
//  Created by 朱正锋 on 2019/4/13.
//  Copyright © 2019年 Printer. All rights reserved.
//

#import "TemplatePrinterController.h"
#import "Printer.h"
#import "style.h"
#import "PrinterManager.h"
#import "LabelCommonSetting.h"
#import "ESCCmd.h"
#import "PinCmd.h"
#import "TSCCmd.h"
#import "ZPLCmd.h"
#import "ProgressHUD.h"
#import "CPCLCmd.h"

@interface TemplatePrinterController ()
{
    PrinterManager *_printerManager;
    int iAskstatus;
    int iReplay;
    int iSendPrint;
}

@end

@implementation TemplatePrinterController

- (void)viewDidLoad {
    [super viewDidLoad];
    iAskstatus = 0;
    iReplay = 0;
    iSendPrint=0;
    _printerManager = PrinterManager.sharedInstance;
}

- (NSData *)loadPrinterData{
    
    float labelWidth = 80;
    float labelHeight = 60;
    float bmpPrintWidth = 60;
    
    Cmd *cmd =  [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
    [cmd Clear];
    //    [cmd setEncodingType:Encoding_UTF8];
    [cmd setEncodingType:Encoding_GBK];
    LabelCommonSetting *commonSetting = [LabelCommonSetting new];
    commonSetting.labelWidth = labelWidth;
    commonSetting.labelHeight = labelHeight;
    commonSetting.labelgap = 0;
    commonSetting.labelDriection = Direction_Forward;
    
    [cmd Append:[cmd GetHeaderCmd:commonSetting]];
    
    
    BitmapSetting *bitmapSetting = [BitmapSetting new];
    bitmapSetting.pos_X = 10;
    bitmapSetting.pos_Y = 30;//10
    bitmapSetting.limitWidth = bmpPrintWidth * 7;
    bitmapSetting.Alignmode = Align_Left;
    
    UIImage *image = [UIImage imageNamed:@"logotest.png"];
    [cmd Append:[cmd GetBitMapCmd:bitmapSetting image:image]];
    
    BarcodeSetting *barcodeSetting = [BarcodeSetting new];
    barcodeSetting.coord = CoordMake(450, 35, 5, 5);//15
    barcodeSetting.ECClevel = ECC_level_L;
    PrinterCodeError printerError= PrinterCodeOK;
    [cmd Append:[cmd GetBarCodeCmd:barcodeSetting codeType:BarcodeTypeQrcode scode:@"1902280000099" codeError:&printerError]];
    
    [cmd Append:[cmd GetLFCmd]];
    
    
    TextSetting *textSetting = [TextSetting new];
    
    textSetting.TSCFonttype = TSCFontType_TSS24; //TSCFontType_TSS16;
    textSetting.X_start = 10;
    textSetting.Y_start = 100;
    textSetting.Rotate = Rotate0;
    textSetting.X_multi = 1;
    textSetting.Y_multi = 1;
    textSetting.IsBold = Set_Enabled;
    NSString *waybillNoAndBox = @"1902280000099    共4件";
    [cmd Append:[cmd GetTextCmd:textSetting text:waybillNoAndBox]];
    
    [cmd Append:[cmd GetLFCmd]];
    
    NSInteger h = 30;
    NSInteger textY = 100;
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    NSString *solicitationTime = @"揽货时间：2019/2/28 19:30:33";
    [cmd Append:[cmd GetTextCmd:textSetting text:solicitationTime]];
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    NSString *receiver = @"收方：测试开单数据";
    [cmd Append:[cmd GetTextCmd:textSetting text:receiver]];
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    NSString *receiverContact = @"刘先生 电话：18899999999";
    [cmd Append:[cmd GetTextCmd:textSetting text:receiverContact]];
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    NSString *receiverAddress = @"厦门市火炬园经济开发区";
    [cmd Append:[cmd GetTextCmd:textSetting text:receiverAddress]];
    
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    [cmd Append:[cmd GetTextCmd:textSetting text:@"---------------------------------------------------"]];
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    NSString *moneyStr = @"代收：10 现付：5 到付：5";
    [cmd Append:[cmd GetTextCmd:textSetting text:moneyStr]];
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    NSString *goodsName = @"托寄物：轮胎，邮箱等等等等一些杂物";
    [cmd Append:[cmd GetTextCmd:textSetting text:goodsName]];
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    [cmd Append:[cmd GetTextCmd:textSetting text:@"---------------------------------------------------"]];
    
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    NSString *senderAndTel = @"发先生 1999999999";
    [cmd Append:[cmd GetTextCmd:textSetting text:senderAndTel]];
    
    textY = textY + h;
    textSetting.X_start = 10;
    textSetting.Y_start = textY;
    NSString *tips = @"温馨提示：所发货物保丢不保损！";
    [cmd Append:[cmd GetTextCmd:textSetting text:tips]];
    
    // [cmd Append:[cmd GetPrintEndCmd:1]];
    
    //            if SZPrinterManager.sharedInstance().currentPrinter.isOpen {
    //                let data = cmd.getCmd()
    //                let printer = SZPrinterManager.sharedInstance().currentPrinter
    //                printer.writeAsync(data)
    //            }
    NSData *data = [cmd GetCmd];
    return data;
}


-(NSData *)getcopys{
    TextSetting *textSetting = [TextSetting new];
    textSetting.EscFonttype = TSCFontType_TSS24;
    textSetting.X_start = 10;
    textSetting.Y_start = 1;
    textSetting.Rotate = Rotate0;
    textSetting.X_multi = 1;
    textSetting.Y_multi = 1;
    textSetting.IsBold = Set_Enabled;
    NSString *s = [NSString stringWithFormat:@"this is [%d]",++_printerManager.icopys];
    Cmd *cmd =  [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
    [cmd Clear];
    [cmd setEncodingType:Encoding_UTF8];
    [cmd Append:[cmd GetTextCmd:textSetting text:s]];
    [cmd Append:[cmd GetPrintEndCmd:1]];
    return [cmd GetCmd];
}


-(void)TscAfterSendSuccPrint{//蓝牙打印，发送成功后，再发送下一条(rpp320定制)
    Printer * currentprinter = _printerManager.CurrentPrinter;
    //currentprinter.blewritetype = bleWriteWithResponse;//蓝牙写入类型，必须设置成WithResponse
    if (currentprinter.IsOpen){
        iAskstatus = 0;
        iReplay = 0;
        iSendPrint=0;
        
        NSData *cmdData = [self loadPrinterData];
        NSString *aString = [[NSString alloc] initWithData:cmdData encoding:NSUTF8StringEncoding];
        aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSLog(@"data string=%@",aString);
        
        [[currentprinter PrinterPi] setCallbackwhenSendFailure:^(NSInteger ipackNo, NSInteger ipackcnt, NSString *message) {
            NSLog(@"Send Fail:ipackNo:%ld ipackcnt:%ld message:%@",ipackNo,ipackcnt,message);
        }];
        
        [[currentprinter PrinterPi] setCallbackwhenSendProgressUpdate:^(NSInteger ipackNo, NSInteger ipackcnt, NSString *message) {
            NSLog(@"Send progress:ipackNo:%ld ipackcnt:%ld message:%@",ipackNo,ipackcnt,message);
        }];
        
        [[currentprinter PrinterPi] setCallbackDisConnect:^(ObserverObj *observerObj) {
            NSLog(@"Disconnect-Msgobj=%s",object_getClassName(observerObj.Msgobj));
            NSLog(@"Disconnect-Msgvalue=%@",(NSString *)observerObj.Msgvalue);
            [[currentprinter PrinterPi] setCallbackDisConnect:nil];
        }];
        
        [self DoTscAfterSendSuccPrint:currentprinter cmdData:cmdData  itimes:1];
    }
    
}

-(void)DoTscAfterSendSuccPrint:(Printer *) currentprinter cmdData:(NSData *)cmdData  itimes:(NSInteger)itimes {
    if (itimes>2) //连续打n张
        return;
    Cmd *tmpcmd =  [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
    [tmpcmd Append:[tmpcmd GetPrintStautsCmd:PrnStautsCmd_Normal]];
    if ([currentprinter IsOpen]){///获取打印机状态
        NSLog(@"Inquiry status:%d",++iAskstatus);
        NSData *data=[tmpcmd GetCmd];
        [currentprinter setIsNeedCallBack:false];
        [currentprinter Write:data];
        
    }
    
    
    [[currentprinter PrinterPi] setCallbackPrinterStatus:^(PrinterStatusObj *statusobj, NSString *message) {
        NSLog(@"Status response:%d",++iReplay);
        //正在打印中，也可以发送指令，但如果有开盖，或缺纸时，不要发送指令
        if (statusobj.blPrintReady || ( statusobj.blPrinting && !statusobj.blNoPaper && !statusobj.blLidOpened)){
              dispatch_async(dispatch_get_main_queue(), ^{
                if ([currentprinter IsOpen]){
                    NSData *data2=[self getcopys];
                    NSMutableData *mData = [[NSMutableData alloc] init];
                    [mData appendData:cmdData];
                    [mData appendData:data2];
                    NSLog(@"Send print%d",++iSendPrint);
                    [currentprinter setIsNeedCallBack:true];
                    [currentprinter Write:mData];
                }
                
                 });
        } else
        {
            usleep(1000*800);
            [self DoTscAfterSendSuccPrint:currentprinter cmdData:cmdData itimes:itimes];
            return ;
        }
    }];// end of setCallbackPrinterStatus
    
    [[currentprinter PrinterPi] setCallbackwhenSendSuccess:^(NSInteger ipackNo, NSInteger ipackcnt, NSString *message) {
        NSLog(@"Send success: ipackNo:%ld ipackcnt:%ld message:%@",ipackNo,ipackcnt,message);
        [self DoTscAfterSendSuccPrint:currentprinter cmdData:cmdData itimes:itimes+1];
        
    }]; //end of setCallbackwhenSendSuccess
    
    
    
    
}


- (IBAction)btnTemplate1Click:(id)sender {
    [self TscAfterSendSuccPrint];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
