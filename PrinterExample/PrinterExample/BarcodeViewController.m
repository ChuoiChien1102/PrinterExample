//
//  BarcodeViewController.m
//  PrinterExample
//
//  Created by 朱正锋 on 27/12/2017.
//  Copyright © 2017 Printer. All rights reserved.
//

#import "BarcodeViewController.h"
#import "UIImage+Barcode.h"
#import "Header.h"
#import "EnumTypeDef.h"
#import "Printer.h"
#import "PrinterManager.h"
#import "ProgressHUD.h"
#import "BarcodeSetting.h"
#import "LabelCommonSetting.h"
@interface BarcodeViewController ()
{
   NSInteger kMaxLength;
    PrinterManager *_printerManager;
}
@end

@implementation BarcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barcodeText.delegate=self;
    self.barcodeText.placeholder = [self getCodeComment];
    self.CboxBarcodeType.delegate = self;
    // kMaxLength=1000;
//    [self.barcodeText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.btnPrint.disabledColor = UIColorFromHex(0x6B7A8D);
    self.btnPrint.enabled = ([PrinterManager.sharedInstance.CurrentPrinter IsOpen]);
    if (self.btnPrint.enabled)
        self.btnPrint.alpha = 1;
    else
        self.btnPrint.alpha = 0.5;
    _printerManager = PrinterManager.sharedInstance;
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

-(NSString *)getCodeComment{
    
    switch(_CboxBarcodeType.currentIndex){
        case BarcodeTypeUPC_A:
            self.barcodeText.keyboardType = UIKeyboardTypeNumberPad;
            return NSLocalizedString(@"tip_barcode_text_UPC_A", nil);
        case BarcodeTypeEAN13:
            self.barcodeText.keyboardType = UIKeyboardTypeNumberPad;
            return NSLocalizedString(@"tip_barcode_text_EAN13", nil);
        case BarcodeTypeEAN8:
            self.barcodeText.keyboardType = UIKeyboardTypeNumberPad;
            return NSLocalizedString(@"tip_barcode_text_EAN8", nil);
        case BarcodeTypeCODE39:
            
            return NSLocalizedString(@"tip_barcode_text_CODE39", nil);
        case BarcodeTypeITF:
            self.barcodeText.keyboardType = UIKeyboardTypeNumberPad;
            return NSLocalizedString(@"tip_barcode_text_ITF", nil);
            
        case BarcodeTypeCODABAR:
            return NSLocalizedString(@"tip_barcode_text_CODABAR", nil);
        case BarcodeTypeCODE128:
             return NSLocalizedString(@"tip_barcode_text_CODE128", nil);
        case BarcodeTypeQrcode:
             return NSLocalizedString(@"anycharacter", nil);
            
    }
    
    return @"";
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger strLength=textField.text.length-range.length+string.length;
    NSInteger kMaxlength=20;
    switch(_CboxBarcodeType.currentIndex){
        case BarcodeTypeUPC_A:
            kMaxlength=11;
            break;
        case BarcodeTypeEAN13:
            kMaxlength=12;
            break;
        case BarcodeTypeEAN8:
            kMaxlength=7;
            break;
        case BarcodeTypeCODE39:
            kMaxlength=30;
            break;
        case BarcodeTypeITF:
            kMaxlength=14;
            break;
            
        case BarcodeTypeCODABAR:
            kMaxlength=30;
            break;
        case BarcodeTypeCODE128:
            kMaxlength=42;
            break;
    }
    return (strLength<=kMaxlength);
}

-(BOOL)checkInput:(BarcodeType)codetype  code:(NSString *)code{
    NSString * regex;
    switch (codetype) {
        case BarcodeTypeUPC_A:
            regex = @"\\d{11}";
            break;
         case BarcodeTypeUPC_E:
            /*                regex = "\\d{6}";
             return inputStr.matches(regex);*/
            return false;
        case BarcodeTypeEAN13:
            regex = @"\\d{12}";
            break;
        case BarcodeTypeEAN8:
            regex = @"\\d{7}";
            break;
        case BarcodeTypeCODE39:
            regex = @"[a-zA-Z\\p{Digit} \\$%\\+\\-\\./]{1,30}";
            break;
        case BarcodeTypeITF:
            regex = @"(\\d{2}){1,15}";
            break;
        case BarcodeTypeCODABAR:
            regex = @"[A-D][0-9\\$\\+\\-\\./:]{0,28}[A-D]";
            break;
//        case BarcodeTypeCODE93:
//            return false;
        case BarcodeTypeCODE128:
            regex = @"[\\p{ASCII}]{1,42}";
            break;
        case BarcodeTypeQrcode:
            regex = @"[\\p{ASCII}]+";
            break;
        default:
            return false;
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:code];
}


-(void)WBComboValueChanged:(id)sender{
  self.barcodeText.placeholder = [self getCodeComment];
}

-(BOOL)generateCode:(NSString * )code{
    if([code length] == 0)
        return  NO;
    
    NSString * barcode ;
    BarcodeType barcodetype =(BarcodeType)_CboxBarcodeType.currentIndex;
    
    UIImage * newImage = [UIImage generateBarCode:code barcodeType:barcodetype frame:self.barcodeImage.frame barcode:&barcode];
    
    if(newImage == nil){
        [ProgressHUD showError:[NSString stringWithFormat:NSLocalizedString(@"tip_barcode_text_format_error", nil),[self getCodeComment]]];
        return NO;
    }
    
    
    self.barcodeImage.image = newImage;
    
    
    if(_CboxBarcodeType.currentIndex == BarcodeTypeCODE128)
        self.barcodeCaption.text = [self.barcodeText text];
    else
        self.barcodeCaption.text = barcode;
    
    
    
    return YES;
}



- (IBAction)onGenerateBarcode:(id)sender {
    NSInteger strLength=self.barcodeText.text.length;
    BOOL blnGen=true;
    switch(_CboxBarcodeType.currentIndex){
        case BarcodeTypeUPC_A:
            break;
        case BarcodeTypeEAN13:
            
            break;
        case BarcodeTypeEAN8:
            
            break;
        case BarcodeTypeCODE39:
            
            break;
        case BarcodeTypeITF:
            if (strLength % 2==0) {
                blnGen=true;
            } else {
                blnGen=false;
            }
            break;
            
        case BarcodeTypeCODABAR:
            
            break;
        case BarcodeTypeCODE128:
            
            break;
    }
    if (blnGen) {
        [self generateCode:self.barcodeText.text];
    } else {
        NSString * errorInfo =  NSLocalizedString(@"tip_barcode_text_is_odd", nil);
       [ProgressHUD showError:errorInfo];
    }
  
    
}

-(Coordinate)getBarCoordinate:(PrinterCmdType)cmdtype rotate:(RotateType)rotate{
    int labelwidth = 72;
    int labelHeight = 50;
    Coordinate coord;
    coord = CoordMake(0, 0, 0, 0);
    switch (cmdtype) {
        case PrinterCmdESC:
            coord = CoordMake(10, 0, 3, 90);//barset.coord.y Useless co
            break;
        case PrinterCmdTSC:
        {
            switch (rotate) {
                case Rotate0:
                    coord = CoordMake(10, 10, 0, 96);//coord.width barcode Useless
                    break;
                case Rotate90:
                    coord = CoordMake(labelwidth*8/2, 20, 0, 96);
                    break;
                case Rotate180:
                    coord = CoordMake(labelwidth*8/2, 200, 0, 96);
                    break;
                case Rotate270:
                    coord = CoordMake(labelwidth*8/2, labelHeight*8/2, 0, 96);
                    break;
                default:
                    break;
            }
            break;
            
            
        }
        case PrinterCmdCPCL:
        {
            switch (rotate) {
                case Rotate0:
                case Rotate180: //Rotate180 Useless
                    coord = CoordMake(10, 10, 1, 96);//coord.width 1~7
                    break;
                case Rotate90:
                case Rotate270:
                    coord = CoordMake(labelwidth*8/2, labelHeight*8/2, 1, 90);
                    break;
                default:
                    break;
            }
        }
            
        case PrinterCmdZPL:
        {
            switch (rotate) {
                case Rotate0:
                    coord = CoordMake(10, 10, 0, 48);
                    break;
                case Rotate90:
                    coord = CoordMake(labelwidth*8/2, 20,0,48);
                    break;
                case Rotate180:
                   coord = CoordMake(10, 10, 0, 0);
                    break;
                case Rotate270:
                    coord = CoordMake(labelwidth*8/2, labelHeight*8-20, 0, 48);
                    break;
                default:
                    break;
            }
        }

            
        default:
            break;
    }
    
    return coord;

}

- (IBAction)btnPrint:(id)sender {
    if(![self generateCode:self.barcodeText.text]){ //此方法生成中文，会有问题
        [ProgressHUD showError:NSLocalizedString(@"please_input_barcode_text",nil) ];
        return ;
    }
//    switch (_printerManager.CurrentPrinterCmdType) {
//        case PrinterCmdESC:
//           // [self EscPrint];
//            break;
//        case PrinterCmdTSC:
//            break;
//
//        case PrinterCmdCPCL:
//            break;
//
//        case PrinterCmdZPL:
//            [self ZplPrint];
//            return;
//           // break;
//
//        case PrinterCmdPIN:
//            break;
//    }
    
    Printer * currentprinter = _printerManager.CurrentPrinter;
    NSString* sBarcode = self.barcodeCaption.text;
    
    if (currentprinter.IsOpen){
        Cmd *cmd =  [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
        [cmd Clear];
        
        NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];
        [cmd Append:headercmd];

        PrinterCodeError  CodeError;
        BarcodeSetting * barset = [BarcodeSetting new];
        barset.Rotate = (RotateType)_segRotate.selectedSegmentIndex;
        barset.coord = [self getBarCoordinate:_printerManager.CurrentPrinterCmdType rotate:barset.Rotate];
    
         switch (_printerManager.CurrentPrinterCmdType) {
             case PrinterCmdESC:
                barset.Alignmode = Align_Left;
                barset.HRIPos = BarcodeHRIpos_Below;
                barset.HRIFonttype = ESCFontType_FontA;
                break;
 
            case PrinterCmdTSC:
                barset.narrow = 2;
                barset.wide   = 4;
                if (_CboxBarcodeType.currentIndex==BarcodeTypeQrcode){
                  barset.ECClevel = ECC_level_H;
               }
                break;
                
            case PrinterCmdCPCL:
                 barset.ratio=1;
                if (_CboxBarcodeType.currentIndex==BarcodeTypeQrcode){
                    barset.ECClevel = ECC_level_H;
                }
                
             case PrinterCmdZPL:
                 barset.HRIPos = BarcodeHRIpos_Below;

            default:
                break;
        }
        
        
        
        //sBarcode = @"二维码中文测试";
        NSData *data= [cmd GetBarCodeCmd:barset  codeType:_CboxBarcodeType.currentIndex scode:sBarcode codeError:&CodeError];
        if (CodeError<0){
            [ProgressHUD showError:[NSString stringWithFormat:NSLocalizedString(@"tip_barcode_text_format_error", nil),[self getCodeComment]]];
        
            return;
        }
        [cmd Append:data];
        for (int i=0; i<3; i++) {
           [cmd Append:[cmd GetLFCRCmd]];
        }
        
        
        [cmd Append:[cmd GetPrintEndCmd:1]];
        //询问打印是否完成，打印完成，返回 “print Ok" 适用于 Rpp80Use 定制客户使用。
        //Inquire whether the printing is completed, printing is completed, return "print Ok" For Rpp80Use custom customer use.
      //  [cmd Append:[cmd GetAskPrintOkCmd]]; 
        
        
        if ([currentprinter IsOpen]){
            NSData *data=[cmd GetCmd];
            NSLog(@"data bytes=%@",data);
            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSLog(@"data string=%@",aString);
            [currentprinter Write:[cmd GetCmd]];
        }
        
        
        
        
    }
    
}

/**
 * 字母、数字、中文
 */
- (BOOL)isInputRuleAndNumber:(NSString *)str
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    unsigned long len=str.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[str characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_') || (a == '-'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ||([other rangeOfString:str].location != NSNotFound)
             ))
            return NO;
    }
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    NSString *toBeString = textField.text;
    NSString *lastString;
    if(toBeString.length>0)
        lastString=[toBeString substringFromIndex:toBeString.length-1];
    
    if (![self isInputRuleAndNumber:toBeString]&&[self hasEmoji:lastString]) {
        textField.text = [self disable_emoji:toBeString];
        return;
    }
    NSString *lang = [[textField textInputMode] primaryLanguage];
    if([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}

/**
*  获得 kMaxLength长度的字符
*/
-(NSString *)getSubString:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > 10000) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//【注意4】：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
}

/**
 *  过滤字符串中的emoji
 */

- (BOOL)hasEmoji:(NSString*)str{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}






- (IBAction)bntText:(id)sender {
}
@end
