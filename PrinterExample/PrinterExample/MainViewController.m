//
//  MainViewController.m
//  PrinterExample
//
//  Created by King on 08/12/2017.
//  Copyright © 2017 Printer. All rights reserved.
//

#import "MainViewController.h"
#import "PrinterManager.h"
#import "ProgressHUD.h"
#import "WifiInterface.h"
#import "PinCmdFactory.h"
#import "BleDeviceListController.h"
#import "BlueToothFactory.h"
#import "ConnectedlistViewController.h"
#import "EnumTypeDef.h"
#import "PrinterStatusObj.h"
#import <zlib.h>
#import "ZPLCmd.h"
#import "PlistUtils.h"
#import "NetworkPrinter.h"
#import "SearchPrinterListController.h"


#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

@interface MainViewController ()
{
   PrinterManager * _printerManager;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _Cboxinstruction.delegate = self;
    _CboxPortType.delegate = self;
    _Port = (int)[PlistUtils loadIntConfig:@"IPPort" defaultValue:9100];
    _lblChoiceAddress.text = NSLocalizedString(@"noconnectAndClick",nil);
    _printerManager = [PrinterManager sharedInstance];
    _Cboxinstruction.currentIndex = _printerManager.CurrentPrinterCmdType;
    _CboxPortType.currentIndex = _printerManager.CurrentPrinterPortType;
    //self.btnDisconnect.adjustsImageWhenDisabled = NO;
   
    //_MainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,10)];
    [self setdisabledColor];
    [self setConnectStatus:NO];
    _MainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_printerManager AddConnectObserver:self selector:@selector(handleNotification:)];//Add NSNotificationCenter
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblChoiceAddressClick)];
    [_lblChoiceAddress addGestureRecognizer:labelTapGestureRecognizer];
    _lblChoiceAddress.userInteractionEnabled = YES;

    self.btnConnectlist.enabled = false;
    [self setConnectStatus:false];
    self.btnConnect.enabled = false;
    self.btnConnect.alpha = 0.5;
    self.btnConnectlist.alpha = 0.5;
    self.title = @"Printer Example V4.16";
    
    [self setControlStatus];

}
-(void)setdisabledColor{
    UIColor *disabledcolor = UIColorFromHex(0x6B7A8D);
    self.btnDisconnect.disabledColor = disabledcolor;
   // self.btntest.disabledColor = disabledcolor;
    self.btnConnect.disabledColor = disabledcolor;
    self.btntest.backgroundColor = disabledcolor;
    self.btnConnectlist.disabledColor = disabledcolor;
    self.btnPrinterStatus.disabledColor = disabledcolor;
    self.btnPageLength.disabledColor = disabledcolor;
    self.btnBluetootSet.disabledColor = disabledcolor;
    self.btnTemplatePrint.disabledColor = disabledcolor;
}

-(void)setConnectStatus:(BOOL)isConnect{
    self.btnDisconnect.enabled = isConnect;
    self.btnConnect.enabled = !isConnect;
    self.btnPrinterStatus.enabled = isConnect;
    self.btnPageLength.enabled = isConnect;
   // self.btnBluetootSet.enabled = isConnect;
    if (isConnect){
        self.btnConnect.alpha = 0.5;
        self.btnDisconnect.alpha = 1;
        self.btntest.alpha = 1;
        self.btntest.backgroundColor = [UIColor whiteColor];
        self.btnPrinterStatus.alpha = 1;
        self.btnPageLength.alpha = 1;
        self.btnTemplatePrint.alpha = 1;
    }
    else
    {
        self.btnConnect.alpha = 1;
        self.btnDisconnect.alpha = 0.5;
        self.btntest.alpha = 0.5;
        self.btntest.backgroundColor = UIColorFromHex(0x6B7A8D);
        self.btnPrinterStatus.alpha = 0.5;
        self.btnPageLength.alpha = 0.5;
        self.btnTemplatePrint.alpha = 0.5;
        
    }
    
}


-(void)UnregisterObserver{
  [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)dealloc {
    [self UnregisterObserver];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma handleNotification
- (void)handleNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(),^{
        [ProgressHUD dismiss];
        
       // NSLog(@"notification.object=%s",object_getClassName(notification.object));
        if([notification.name isEqualToString:(NSString *)PrinterConnectedNotification])
        {

            if ([notification.object isKindOfClass:[ObserverObj class]]) {
                
                ObserverObj *obj= notification.object;
                NSLog(@"notification.object.Msgobj=%s",object_getClassName(obj.Msgobj));
                NSLog(@"notification.object.Msgvalue=%@",(NSString *)obj.Msgvalue);
                
                if ([obj.Msgobj isKindOfClass:[PrinterInterface class]]) {
                    NSInteger iindex = [_printerManager.PrinterList indexOfObject:obj.Msgobj];
                    
                  if (-1 == iindex){
                      [_printerManager.PrinterList addObject:obj.Msgobj];
                    }
                    if (_printerManager.CurrentPrinter.PrinterPi==obj.Msgobj)
                        [self setConnectStatus:YES];
                }
                obj = nil;
            }
          //  [self setConnectStatus:true];
            [ProgressHUD showSuccess:@"printer connect success" Interaction:YES];
        
        }else if([notification.name isEqualToString:(NSString *)PrinterDisconnectedNotification])
        {
            if ([notification.object isKindOfClass:[ObserverObj class]]) {
                ObserverObj *obj= notification.object;
                if ([obj.Msgobj isKindOfClass:[PrinterInterface class]]) {
                    NSInteger index = [_printerManager.PrinterList indexOfObject:obj.Msgobj];
                  //  SLog(@"index=%d count=%d",index,[_printerManager.PrinterList count]);
                    if (index>=0){
                        [_printerManager.PrinterList removeObject:obj.Msgobj];
                    }
                    if (_printerManager.CurrentPrinter.PrinterPi==obj.Msgobj)
                        [self setConnectStatus:NO];
                }
                obj = nil;
            }
            
            [ProgressHUD showSuccess:@"printer connect Disconnected" Interaction:YES];
         //   [self setConnectStatus:false];
        } else if (([notification.name isEqualToString:(NSString *)BleDeviceDataChanged]))
        {
            if ([notification.object isKindOfClass:[ObserverObj class]]) {
                ObserverObj *obj= notification.object;
                if ([obj.Msgvalue isKindOfClass:[PrinterStatusObj class]]) {
                    [self ShowStatus:obj.Msgvalue];
                }
                obj.Msgvalue = nil;
                obj = nil;
            }
            
        }
        
        [self refreshConnectState];
        self.btnConnectlist.enabled = (_printerManager.PrinterList.count>0)?YES:NO;
        if (self.btnConnectlist.enabled)
            self.btnConnectlist.alpha = 1;
        else
            self.btnConnectlist.alpha = 0.5;

    });
}


-(void)ShowNormalStatus:(PrinterStatusObj *)printerStatusObj  {
    
    if (printerStatusObj.blMoveMentErr){
        [ProgressHUD showSuccess:(NSString *)STATUS_MOVEMENT_ERROR Interaction:YES];
    }
    if (printerStatusObj.blPaperJammed) {
        [ProgressHUD showSuccess:(NSString *)STATUS_PAPER_JAMMED_ERROR Interaction:YES];
    }
    if (printerStatusObj.blNoPaper) {
        [ProgressHUD showSuccess:(NSString *)STATUS_NO_PAPER_ERROR Interaction:YES];
    }
    if (printerStatusObj.blNoRibon){
        [ProgressHUD showSuccess:(NSString *)STATUS_RIBBON_RUNS_OUT_ERROR Interaction:YES];
    }
    if (printerStatusObj.blPrinterPause) {
        [ProgressHUD showSuccess:(NSString *)STATUS_PRINTER_PAUSE Interaction:YES];
    }
    if (printerStatusObj.blPrinting) {
        [ProgressHUD showSuccess:(NSString *)STATUS_PRINTER_BUSY Interaction:YES];
    }
    if (printerStatusObj.blLidOpened) {
        [ProgressHUD showSuccess:(NSString *)STATUS_PRINTER_LID_OPEN Interaction:YES];
    }
    if (printerStatusObj.blOverHeated) {
        [ProgressHUD showSuccess:(NSString *)STATUS_OVERHEATED_ERROR Interaction:YES];
    }
    if (printerStatusObj.blPrintReady) {
        [ProgressHUD showSuccess:(NSString *)STATUS_READYPRINT Interaction:YES];
    }

}
        
-(void)ShowStatus:(PrinterStatusObj *)printerStatusObj{
    NSString *sMsg;
     switch (printerStatusObj.printStautsCmd) {
         case PrnStautsCmd_Normal:
         case  PrnStautsCmd_HQPRNSTA410:
             [self ShowNormalStatus:printerStatusObj];
             break;
         case PrnStautsCmd_Mileage:
             sMsg = [NSString stringWithFormat:@"Printed Mileage:%ld m",printerStatusObj.PrintedMileage];
             [ProgressHUD showSuccess:sMsg Interaction:YES];
             break;
         case PrnStautsCmd_ModelName:
             sMsg = [NSString stringWithFormat:@"ModelName=%@ Serial number=%@",printerStatusObj.ModelName,printerStatusObj.Serialnumber];
             [ProgressHUD showSuccess:sMsg Interaction:YES];
             break;
         case PrnStautsCmd_MemorySize:
             sMsg = [NSString stringWithFormat:@"Memory Size:%ld",printerStatusObj.MemorySize];
             [ProgressHUD showSuccess:sMsg Interaction:YES];
             break;

         case PrnStautsCmd_PrintEnd:
             if (printerStatusObj.PrintEndStatus==1)
             {
               sMsg =@"print Ok";
               [ProgressHUD showSuccess:(NSString *)sMsg Interaction:YES];
             }
             break;
         default:
             break;
     }
    
    
}

-(void)refreshConnectState{
    NSString *sTitle=@"";
    if ([_printerManager.CurrentPrinter IsOpen]){
        if ([_printerManager.CurrentPrinter.PrinterPi isKindOfClass:[RTBlueToothPI class]])
           sTitle = [NSString stringWithFormat:@"Printer is connected(%@)",_printerManager.CurrentPrinter.PrinterPi.Name];
        else
           sTitle = [NSString stringWithFormat:@"Printer is connected(%@)",_printerManager.CurrentPrinter.PrinterPi.Address];
    } else
    {
        sTitle = @"Printer is Disconnected";
    }
    self.navigationItem.title  = sTitle;
}



#pragma mark - Table view data source



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     _printerManager.CurrentPrinterCmdType = (PrinterCmdType)_Cboxinstruction.currentIndex;
    if([segue.identifier isEqualToString:@"ShowConnectlist"]){
       ConnectedlistViewController *destViewController = segue.destinationViewController;
        destViewController.delegate = self;
        
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    if ([string isEqualToString:filteredStr]) {
        return YES;
    }
    return NO;
}



-(void) ConnectWifi{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"inputIpAddr",nil)  message:@"" preferredStyle:UIAlertControllerStyleAlert];
    

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"0.0.0.0";
        textField.text = [PlistUtils loadStringConfig:@"IPAddr" defaultValue:@"192.168.8.81"];

        
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.delegate = self;
        
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"9100";
        textField.text =[NSString stringWithFormat:@"%ld",_Port];
        textField.secureTextEntry = false;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = self;

    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"Cancel");
    }];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        UITextField *addressField = alertController.textFields[0];
        self.Address = addressField.text;
        BOOL b=NO;
        for (PrinterInterface *pi in _printerManager.PrinterList) {
            if ([pi.Address isEqualToString:self.Address])
                b = YES;
                
        }
        
        UITextField * portField = alertController.textFields[1];
        self.Port = [portField.text integerValue];
        _lblChoiceAddress.text =  [NSString stringWithFormat:@"%@:%ld",self.Address,self.Port];
        [PlistUtils saveStringConfig:@"IPAddr" value:self.Address];
        [PlistUtils saveIntConfig:@"IPPort" value:self.Port];
        [self setConnectStatus:b];
        

    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void) ConnectBle:(BlueToothKind)bluetoothkind{
    BleDeviceListController *controller = [[BleDeviceListController alloc] init];
    controller.delegate = self;
    controller.bluetoothkind = bluetoothkind;
    [[self navigationController] pushViewController:controller animated:YES];
}

-(void)selectDeviceInfo:(RTDeviceinfo *)device{
    if (![self.Address isEqualToString:device.UUID]){
      [self setConnectStatus:NO];
    }
    self.Address = device.UUID;
    _lblChoiceAddress.text = [NSString stringWithFormat:@"%@[%@]",device.name,device.ShortAddress];
    
}
-(void)selectPrinterInterface:(PrinterInterface *)printerpi{
    self.Address = printerpi.Address;
    if ([printerpi isKindOfClass:[RTBlueToothPI class]])
    {
        _CboxPortType.currentIndex = PrinterPortBle;
        _lblChoiceAddress.text = [NSString stringWithFormat:@"%@[%@]",printerpi.Name,printerpi.getShortAddress];
     }
    else{
      _lblChoiceAddress.text = [NSString stringWithFormat:@"%@:%d",printerpi.Address,printerpi.Port];
      _CboxPortType.currentIndex = PrinterPortWifi;
     }
    _Cboxinstruction.currentIndex = printerpi.printerCmdtype;
    [_printerManager.CurrentPrinter setPrinterPi:printerpi];
    [_printerManager setCurrentPrinterCmdType:printerpi.printerCmdtype];
    
    [self setConnectStatus:printerpi.IsOpen];
    [self refreshConnectState];
    

}




- (void)lblChoiceAddressClick {
    switch (_CboxPortType.currentIndex) {
        case PrinterPortWifi:
            [self ConnectWifi];
            break;
        case PrinterPortBle:
            [self ConnectBle:BlueToothKind_Ble];
            break;
        case PrinterPortMFI:
            [self ConnectBle:BlueToothKind_Classic];
            break;
        default:
            break;
    }
    
}


- (IBAction)btnConnect:(id)sender {
//     self.Address=@"1EBC58BE-6DF0-AC8D-9F52-A92E9167CC9C";
    NSLog(@"self.Address=%@",self.Address);
    if ([self.Address isEqualToString:@""] ) {
      [ProgressHUD showError:@"no set Address" Interaction:false];
        return;
    }
    
    switch (_CboxPortType.currentIndex) {
        case PrinterPortWifi:
            [_printerManager DoConnectwifi:self.Address Port:self.Port];
            break;
        case PrinterPortBle:
           // [_printerManager AutoStartConnectBleNoScan:self.Address];
            [_printerManager DoConnectBle:self.Address];
           
            break;
        case PrinterPortMFI:
            [_printerManager DoConnectMfi:self.Address];

            break;
        default:
            break;
    }

    

}
- (IBAction)btnDisConnect:(id)sender {
   [_printerManager.CurrentPrinter Close];
//     [(RTBlueToothPI *)_printerManager.CurrentPrinter.PrinterPi DisConnectBleByCmd];//for Rpp410
}

-(void)exectime{
NSLog(@"timer");
}


-(NSString *)Encode64:(Byte *)buf len:(NSUInteger)len{
    
    @try{
        NSData *tmpdata = [[NSData alloc] initWithBytes:buf length:len];
        //  SLog(@"tmpdata=%@ tmpdata.length=%d",tmpdata,tmpdata.length);
        NSData *data= [tmpdata base64EncodedDataWithOptions: 0];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
        return string;
    }@catch(NSException *e){
        NSLog(@"Exception:%@",e);
        return @"ZIP_ERR";
        
    }
}

-(NSString *)Encode64:(NSData *)adatas {
    
    @try{
        NSData *data= [adatas base64EncodedDataWithOptions: 0];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
        return string;
    }@catch(NSException *e){
        NSLog(@"Exception:%@",e);
        return @"ZIP_ERR";
        
    }
}

-(void) testzipaa{
    NSString * ss= @"testaaa";
    NSData *aData = [ss dataUsingEncoding: NSUTF8StringEncoding];
    NSInteger tlen = aData.length;
    Byte * cmd = (Byte *)[aData bytes];
    NSInteger blen=0;
    /* 计算缓冲区大小，并为其分配内存 */
    blen = compressBound(tlen); /* 压缩后的长度是不会超过blen的 */
    Byte *buf = (Byte *)malloc(sizeof(Byte) * blen);
    if(buf == nil)
    {
        NSLog(@"no enough memory!\n");
        return ;
    }
    
    /* 压缩 */
    if(compress(buf, &blen, cmd, tlen) != Z_OK)
    {
        SLog(@"compress failed!\n");
        return ;
    }
    NSData * bufdata = [[NSData alloc] initWithBytes:buf length:blen];
    
    
    
    SLog(@"bufdata=%@ bufdata.lenght=%d",bufdata,bufdata.length);
    
    NSString * strbase64 =[self Encode64:buf len:blen];
    NSLog(@"strbase64=%@",strbase64);
    // NSData *datazip = [zipAndUnzip gzipDeflate:imagedata];
    
    //    NSData *undatazip = [zipAndUnzip gzipInflate:datazip];
    //       SLog(@"undatazip=%@,undatazip.length=%d",undatazip,undatazip.length
    
    
}



//注意针式打印机如果有蓝牙打印测试页后，要手动重启打印机，否则发任何指令，都将无效！！！
//Note: If the dot matrix printer has a Bluetooth print test page, it is necessary to manually restart the printer, otherwise any instructions will be invalid! ! !
- (IBAction)btntest:(id)sender {
   // [self setUsbEnable:YES];

  /*
    for (PrinterInterface *pi in _printerManager.PrinterList) {//多台打印机同时打印(Multiple printers print at the same time)
        Cmd *cmd =  [_printerManager CreateCmdClass:pi.printerCmdtype];
        if (cmd == NULL)
            return;
        [cmd Clear];
        [cmd Append:cmd.GetSelftestCmd];
        NSLog(@"data=%@",[cmd GetCmd]);
        if (pi.IsOpen){
            [pi Write:[cmd GetCmd]];
            
        }
    }
  */
    
    if (_printerManager.CurrentPrinter.IsOpen){
        Cmd *cmd =  [_printerManager CreateCmdClass:(PrinterCmdType)_Cboxinstruction.currentIndex];
        if (cmd == NULL)
            return;
        [cmd Clear];
        [cmd Append:cmd.GetSelftestCmd];
        if ([_printerManager.CurrentPrinter IsOpen]){
            [_printerManager.CurrentPrinter Write:[cmd GetCmd]];
        }
    
    }
}

-(void)setControlStatus{
    [self.btnBarcodeprint setHidden:YES];
    [self.btnCodepage setHidden:YES];
    [self.btnPageLength setHidden:YES];
    [self.btnPrinterStatus setHidden:YES];
    [self.btnDrawBoxPrint setHidden:YES];
    [self.btnUsbEnabled setHidden:YES];
    [self.btnTemplatePrint setHidden:YES];
   
    
    switch (_printerManager.CurrentPrinterCmdType) {
        case PrinterCmdPIN:
            [self.btnPageLength setHidden:NO];
            break;
        case PrinterCmdESC:
            [self.btnCodepage setHidden:NO];
            [self.btnBarcodeprint setHidden:NO];
            break;
            
        case PrinterCmdTSC:
            [self.btnBarcodeprint setHidden:NO];
            [self.btnPrinterStatus setHidden:NO];
            break;
        case PrinterCmdCPCL:
            [self.btnBarcodeprint setHidden:NO];
            break;
        case PrinterCmdZPL:
            [self.btnBarcodeprint setHidden:NO];
            [self.btnPrinterStatus setHidden:NO];
            [self.btnDrawBoxPrint setHidden:NO];
            [self.btnUsbEnabled setHidden:NO];
            break;
        default:
            break;
    }
    
    
    if (_printerManager.CurrentPrinterPortType==PrinterPortWifi){
       // [self.tvCellNetPrinter ]
       // [self.tvCellNetPrinter row]
        [self.tvCellNetPrinter setHidden:NO];
       // [self.btnSearchPrinter setHidden:NO];
    } else
    {
//        [self.btnSearchPrinter setHidden:YES];
        [self.tvCellNetPrinter setHidden:YES];
    }
    
    
    if (_printerManager.CurrentPrinterPortType==PrinterPortBle){
        [self.btnBluetootSet setHidden:NO];
    } else
    {
        [self.btnBluetootSet setHidden:YES];
    }
    
    
    if (_printerManager.CurrentPrinterCmdType==PrinterCmdPIN)
    {
        [_btnBarcodeprint setHidden:YES];
        [self.btnPageLength setHidden:NO];
    }
    else{
        [_btnBarcodeprint setHidden:NO];
        [self.btnPageLength setHidden:YES];
    }
    
    if (_printerManager.CurrentPrinterCmdType==PrinterCmdESC)
        [_btnCodepage setHidden:NO];
    else
        [_btnCodepage setHidden:YES];
    if (_printerManager.CurrentPrinterPortType==PrinterPortBle && _printerManager.CurrentPrinterCmdType==PrinterCmdTSC){
       [self.btnTemplatePrint setHidden:NO];
    }
    [self.tableView reloadData];
}


-(void)WBComboValueChanged:(id)sender{
    _printerManager.CurrentPrinterCmdType = (PrinterCmdType)_Cboxinstruction.currentIndex;
    _printerManager.CurrentPrinterPortType = (PrinterPortType)_CboxPortType.currentIndex;
    [PlistUtils saveIntConfig:@"PrinterPortType" value:_printerManager.CurrentPrinterPortType];
    [PlistUtils saveIntConfig:@"PrinterCmdType" value:_printerManager.CurrentPrinterCmdType];
    [self setControlStatus];
    
}


- (IBAction)btnPrinterStatus:(id)sender {
    if (_printerManager.CurrentPrinter.IsOpen){
        Cmd *cmd =  [_printerManager CreateCmdClass:(PrinterCmdType)_Cboxinstruction.currentIndex];
        if (cmd == NULL)
            return;
        [cmd Clear];
        
        [cmd Append:[cmd GetPrintStautsCmd:PrnStautsCmd_Normal]];//PrnStautsCmd_HQPRNSTA410,PrnStautsCmd_Normal,PrnStautsCmd_ModelName,PrnStautsCmd_MemorySize
        NSData *data=[cmd GetCmd];
        NSLog(@"data bytes=%@",data);
       
//        NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];

        //NSLog(@"data string=%@",data);
        if ([_printerManager.CurrentPrinter IsOpen]){
           [_printerManager.CurrentPrinter Write:data];
        }
        
    }

}

- (IBAction)PageLengthOnClick:(id)sender {
    //用于针式打印机，设置后，必须手动重启打印机
    //use for pincmd,After setting, you must manually restart the printer
    if (_printerManager.CurrentPrinter.IsOpen){
        Cmd *cmd =  [_printerManager CreateCmdClass:(PrinterCmdType)_Cboxinstruction.currentIndex];
        if (cmd == NULL)
            return;
        [cmd Clear];
        // [cmd Append:[(PinCmd*)cmd GetPageLengthCmd:PageUnit_inch ipageLen:6]];// for old Printers
        [cmd Append:[(PinCmd*)cmd GetPageLengthCmd:pglen_INCH_5_5]];//用于新的打印机 pglen_INCH_3_5
        if ([_printerManager.CurrentPrinter IsOpen]){
            [_printerManager.CurrentPrinter Write:[cmd GetCmd]];
        }
        
    }
}
//定制机 用于RPP410 zpl DrawBoxCmd
////custom machine for RPP410 zpl DrawBoxCmd
- (IBAction)btnDrawBoxPrintClick:(id)sender {
    if (_printerManager.CurrentPrinter.IsOpen){
        ZPLCmd *cmd =  [_printerManager CreateCmdClass:PrinterCmdZPL];
        if (cmd == NULL)
            return;
        [cmd Clear];
        NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];
        [cmd Append:headercmd];        // [cmd Append:[(PinCmd*)cmd GetPageLengthCmd:PageUnit_inch ipageLen:6]];// for old Printers
        NSData *data =  [cmd GetDrawBoxCmd:100 y:100 width:70 height:70 lineWidth:2];
        [cmd Append:data];
        data =  [cmd GetDrawBoxCmd:200 y:100 width:70 height:70 lineWidth:2];
        [cmd Append:data];
        data =  [cmd GetDrawBoxCmd:300 y:100 width:70 height:70 lineWidth:2];
        [cmd Append:data];
        data =  [cmd GetDrawBoxCmd:400 y:100 width:70 height:70 lineWidth:2];
        [cmd Append:data];
        data =  [cmd GetDrawBoxCmd:400 y:100 width:70 height:70 lineWidth:2];
        [cmd Append:data];

        [cmd Append:[cmd GetPrintEndCmd:4]];
        if ([_printerManager.CurrentPrinter IsOpen]){
            NSData *data2 =[cmd GetCmd];
            NSString *aString = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSLog(@"data string=%@",aString);
            [_printerManager.CurrentPrinter Write:data2];
        }
        
    }}

//启用/禁用usb for RPP410 定制机
//Enable/disable usb for RPP410 customizer
- (IBAction)btnUsbEnabledClick:(id)sender {
    PrinterManager *_printerManager = PrinterManager.sharedInstance;
        Cmd *cmd = [_printerManager CreateCmdClass:PrinterCmdZPL];
        ZPLCmd * zplcmd = (ZPLCmd *)cmd;
        [zplcmd GetSetUsbEnableCmd:YES];
        [cmd Clear];
        [cmd Append:cmd.GetSelftestCmd];
        NSLog(@"data=%@",[cmd GetCmd]);
        if ([_printerManager.CurrentPrinter IsOpen]){
            [_printerManager.CurrentPrinter Write:[cmd GetCmd]];
        }
    }




- (IBAction)btnSearchPrinterClick:(id)sender {
    SearchPrinterListController *controller = [[SearchPrinterListController alloc] init];
    controller.delegate = self;
    [[self navigationController] pushViewController:controller animated:YES];

    
    
    
//    [NetworkPrinter.sharedInstance GetNetWorkPrinter:^(NetPrinterInfo * _Nonnull netPrinterinfo) {
//               printf("callback ok\n");
//
//        NSLog(@"callback ip=%@ mac->%@ \n subMask->%@ gateWay=%@",netPrinterinfo.ip,netPrinterinfo.mac,netPrinterinfo.subMask,netPrinterinfo.gateWay);
//
//
//    }];

}

-(void)selectNetworkPrinterInfo:(NetPrinterInfo *)device;
{
    if (![self.Address isEqualToString:device.ip]){
        [self setConnectStatus:NO];
    }

    self.Address = device.ip;
    _lblChoiceAddress.text = [NSString stringWithFormat:@"%@:%d",device.ip,9100];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)  {
       if  (indexPath.row==3 && _printerManager.CurrentPrinterPortType!=PrinterPortWifi){
           return 0;
        }
        //在需要自适应高度的cell处 设置
        return  50;// UITableViewAutomaticDimension;
    }
    return 50;
}
@end
