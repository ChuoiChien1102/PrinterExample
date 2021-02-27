//
//  ViewController.m
//  PrinterExample
//
//  Created by King on 08/12/2017.
//  Copyright © 2017 Printer. All rights reserved.
//



#import "ImageViewController.h"
#import "BitmapSetting.h"
#import "Cmd.h"
#import "PrinterManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PinCmd.h"



//#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@interface ImageViewController (){
    PrinterManager *_printerManager;

    
}

@end



@implementation ImageViewController{
    ALAssetsLibrary* assetslibrary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _printerManager = PrinterManager.sharedInstance;
    assetslibrary = [[ALAssetsLibrary alloc] init];
    self.btnPrint.disabledColor = UIColorFromHex(0x6B7A8D);
    self.btnPrint.enabled = ([PrinterManager.sharedInstance.CurrentPrinter IsOpen]);
    if (self.btnPrint.enabled)
        self.btnPrint.alpha = 1;
    else
        self.btnPrint.alpha = 0.5;
    self.txtlimitWidth.delegate = self;
    self.txtlimitWidth.placeholder = @"Limit width";

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)printimageSync{
    int ilimitwidth = [self getBitmaplimit];
    for (PrinterInterface *pi in _printerManager.PrinterList) {//多台打印机同时打印(Multiple printers print at the same time)
        Cmd *cmd =  [_printerManager CreateCmdClass:pi.printerCmdtype];
        if (cmd == NULL)
            return;
        [cmd Clear];
        cmd.encodingType =Encoding_UTF8;
        NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:pi.printerCmdtype];
        [cmd Append:headercmd];
        
        
        Printer *currentprinter = _printerManager.CurrentPrinter;
        BitmapSetting *bitmapSetting  = currentprinter.BitmapSetts;
        switch (pi.printerCmdtype) {
                
            case PrinterCmdESC:
                bitmapSetting.Alignmode = Align_Center;
                bitmapSetting.limitWidth = ilimitwidth*8;//ESC
                break;
            case PrinterCmdTSC:
            case PrinterCmdCPCL:
                bitmapSetting.pos_X = 20;
                bitmapSetting.pos_Y = 40;
                bitmapSetting.limitWidth = ilimitwidth*8;
                break;
            case PrinterCmdPIN:
                bitmapSetting.limitWidth = self.imageView.image.size.width;
                break;
            case PrinterCmdZPL:
                bitmapSetting.pos_X = 20;
                bitmapSetting.pos_Y = 20;
                bitmapSetting.limitWidth = ilimitwidth*8;
                break;
                
            default:
                break;
        }
        
        
        
        NSData *data= [cmd GetBitMapCmd:bitmapSetting image:self.imageView.image];
        [cmd Append:data];
    
        [cmd Append:[cmd GetPrintEndCmd:1]];
        if ([pi IsOpen]){
            NSData *data=[cmd GetCmd];
            NSLog(@"data bytes=%@",data);
            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSLog(@"data string=%@",aString);
            [currentprinter Write:data];
        }
    }

    


}

-(void)pinPrint{
    Cmd *cmd = [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
    [cmd Clear];
    cmd.encodingType =Encoding_UTF8;
//    NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];
//    [cmd Append:headercmd];
  //  [cmd Append:[(PinCmd*)cmd GetPageLengthCmd:PageUnit_inch ipageLen:10]];// for old Printers
    //For new printers
   //[cmd Append:[(PinCmd*)cmd GetPageLengthCmd:pglen_INCH_A4_11_6]];//用于新的打印机 for new Printers
    

    
    Printer *currentprinter = _printerManager.CurrentPrinter;
    BitmapSetting *bitmapSetting  = currentprinter.BitmapSetts;
    bitmapSetting.Alignmode = Align_Center;
    bitmapSetting.limitWidth = self.imageView.image.size.width;
    NSData *data= [cmd GetBitMapCmd:bitmapSetting image:self.imageView.image];
    [cmd Append:data];
    for (int i=0; i<1; i++) {
        [cmd Append:[cmd GetLFCRCmd]];
    }
    [cmd Append:[cmd GetPrintEndCmd]];
    if ([_printerManager.CurrentPrinter IsOpen]){
        NSData *data=[cmd GetCmd];
        //        NSLog(@"data bytes=%@",data);
        //        NSLog(@"===========================");
        //        Byte *b =[data bytes];
        //        NSMutableString * s = [NSMutableString new];
        //        for (int i=0; i<data.length; i++) {
        //            [s appendFormat:@"%02x ",b[i]];
        //            if ((i+1) % 16==0)
        //              [s appendString:@"\r"];
        //        }
        //        NSLog(@"s=%@",s);
        // NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        //NSLog(@"data string=%@",aString);
      
        
        
        NSLog(@"data bytes=%@",data);

        [currentprinter Write:data];
    }
    
//    data = nil;
//    cmd=nil;
}
-(int)getBitmaplimit{
    NSString * s = self.txtlimitWidth.text;
    if ([s isEqualToString:@""]){
        s = @"72";
        self.txtlimitWidth.text = @"72";
    }
    NSInteger ilimitwidth = [s intValue];
    if (ilimitwidth>72){
        self.txtlimitWidth.text = @"72";
    }
    return [s intValue];
}

-(void)EscPrint{
    Cmd *cmd = [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
    [cmd Clear];
    cmd.encodingType =Encoding_UTF8;
    NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];
    [cmd Append:headercmd];
    int ilimitwidth = [self getBitmaplimit];
    Printer *currentprinter = _printerManager.CurrentPrinter;
    BitmapSetting *bitmapSetting  = currentprinter.BitmapSetts;
    bitmapSetting.Alignmode = Align_Left;
    bitmapSetting.limitWidth = ilimitwidth*8;//ESC

    NSData *data= [cmd GetBitMapCmd:bitmapSetting image:self.imageView.image];
//    NSData *data= [cmd GetBitMapCmdZoom:bitmapSetting  image:self.imageView.image limitmaxzooms:0]; //自动放大
    [cmd Append:data];
    [cmd Append:[cmd GetLFCRCmd]];
    //[cmd Append:[cmd GetCutPaperCmd:CutterMode_half]];
    //[cmd Append:[cmd GetFeedAndCutPaperCmd:false FeedDistance:0]];
    [cmd Append:[cmd GetPrintEndCmd:1]];
    
    //
    
    //询问打印是否完成，打印完成，返回 “print Ok" 适用于 Rpp80Use 定制客户使用。
    //Inquire whether the printing is completed, printing is completed, return "print Ok" For Rpp80Use custom customer use.
    // [cmd Append:[cmd GetAskPrintOkCmd]];
    
    
    if ([_printerManager.CurrentPrinter IsOpen]){
        NSData *data=[cmd GetCmd];
        //        NSLog(@"data bytes=%@",data);
        //        NSLog(@"===========================");
        //        Byte *b =[data bytes];
        //        NSMutableString * s = [NSMutableString new];
        //        for (int i=0; i<data.length; i++) {
        //            [s appendFormat:@"%02x ",b[i]];
        //            if ((i+1) % 16==0)
        //              [s appendString:@"\r"];
        //        }
        //        NSLog(@"s=%@",s);
        // NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        //NSLog(@"data string=%@",aString);
        for (int k=0; k<1; k++) {
            [currentprinter Write:data];
            //  usleep(1000 * 1000*3);
            
        }
        
    }
    
    data = nil;
    cmd=nil;
}

- (IBAction)btnImagePrint:(id)sender {
    
//    [self printimageSync];
//    return;
    
    
    switch (_printerManager.CurrentPrinterCmdType) {
        case PrinterCmdPIN:
            [self pinPrint];
            return;
        case PrinterCmdESC:
            [self EscPrint];
            return;
        default:
            break;
    }
    
    int ilimitwidth = [self getBitmaplimit];
    Cmd *cmd = [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
    [cmd Clear];
    cmd.encodingType =Encoding_UTF8;
    NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];
    [cmd Append:headercmd];

    
    Printer *currentprinter = _printerManager.CurrentPrinter;
    BitmapSetting *bitmapSetting  = currentprinter.BitmapSetts;
    bitmapSetting.Alignmode = Align_Left;
    switch (_printerManager.CurrentPrinterCmdType) {
            
        case PrinterCmdESC:
            bitmapSetting.Alignmode = Align_Center;
            bitmapSetting.limitWidth = ilimitwidth*8;//ESC
            break;
        case PrinterCmdTSC:
        case PrinterCmdCPCL:
            bitmapSetting.pos_X = 20;
            bitmapSetting.pos_Y = 20;
            bitmapSetting.limitWidth = ilimitwidth*8;
            break;
        case PrinterCmdPIN:
            bitmapSetting.limitWidth = self.imageView.image.size.width;
            break;
        case PrinterCmdZPL:
            bitmapSetting.limitWidth = ilimitwidth*8;
            bitmapSetting.pos_X = 10;
            bitmapSetting.pos_Y = 10;
            break;
        default:
            break;
    }

    NSData *data= [cmd GetBitMapCmd:bitmapSetting image:self.imageView.image];
//    NSData *data= [cmd GetBitMapCmdExt:bitmapSetting image:self.imageView.image]; //ESC and wifi,usb
    [cmd Append:data];
    [cmd Append:[cmd GetLFCRCmd]];
    //[cmd Append:[cmd GetCutPaperCmd:CutterMode_half]];
    //[cmd Append:[cmd GetFeedAndCutPaperCmd:false FeedDistance:0]];
    [cmd Append:[cmd GetPrintEndCmd:1]];
    
    //

    //询问打印是否完成，打印完成，返回 “print Ok" 适用于 Rpp80Use 定制客户使用。
    //Inquire whether the printing is completed, printing is completed, return "print Ok" For Rpp80Use custom customer use.
   // [cmd Append:[cmd GetAskPrintOkCmd]];
    
    
    if ([_printerManager.CurrentPrinter IsOpen]){
        NSData *data=[cmd GetCmd];
//        NSLog(@"data bytes=%@",data);
//        NSLog(@"===========================");
//        Byte *b =[data bytes];
//        NSMutableString * s = [NSMutableString new];
//        for (int i=0; i<data.length; i++) {
//            [s appendFormat:@"%02x ",b[i]];
//            if ((i+1) % 16==0)
//              [s appendString:@"\r"];
//        }
//        NSLog(@"s=%@",s);
       // NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        //NSLog(@"data string=%@",aString);
        for (int k=0; k<1; k++) {
            [currentprinter Write:data];
          //  usleep(1000 * 1000*3);
            
        }
        
    }
 
    data = nil;
    cmd=nil;
  
}


-(void)loadImage:(UIImage *)image{
    _imageView.image =image;
//    {
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.image = [ BitmapConvert makeScaleImage:image maxWidth:48*8];
//    }
}



- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
     [self loadImage:image];
     NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
    _fileUrl =  [refURL absoluteString] ;
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
        {
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            NSLog(@"[imageRep filename] : %@", [imageRep filename]);
            
            _fileTitle = [imageRep filename];
        };
        
        
        
        [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
        
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (IBAction)btnLoadImage:(id)sender {//
   UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 编辑模式
    imagePicker.allowsEditing=false;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//测试图片
/*
-(NSData *) GetBitMapTestCmd{
    BitmapUtil * bitmaputil = [BitmapUtil new];
    NSInteger ilen=0;
   // -(Byte *) GetESCBitmapTimesPrintCmd:(UIImage*) image ResultLen:(NSInteger *)ResultLen {
    Byte *cmd = [bitmaputil Get24PinTimesBitmapPrintCmd:self.imageView.image ResultLen:&ilen];
    return [NSData dataWithBytesNoCopy:cmd length:ilen freeWhenDone:false];
//  Byte cmd[2]={0x12,0x54};
   // return [NSData dataWithBytes:cmd length:ilen];
    
//    NSString *s = @"标签指令";
//    return  [s dataUsingEncoding:NSUTF8StringEncoding];
}
 */

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    if ([string isEqualToString:filteredStr]) {
        return YES;
    }
    return NO;
}


@end
