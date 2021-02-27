//
//  BleDeviceListController.m
//  RTPrinter
//
//  Created by PRO on 15/12/20.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import "BleDeviceListController.h"
#import "BlueToothFactory.h"
#import "ObserverObj.h"
#import "RTBlueToothPI.h"

@interface BleDeviceListController(){
    RTBlueToothPI * _blueToothPI;
    
}
@end

@implementation BleDeviceListController


-(void)initPullRefresh{
    
    //采用iOS6 的自带的UIRefreshControl控制下拉刷新
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"scanning",nil)] ;
    [refresh addTarget:self action:@selector(refreshDevice:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self.refreshControl beginRefreshing];
    [_blueToothPI startScan:30 isclear:YES];
}
-(IBAction)refreshDevice:(id)sender{
    if (self.bluetoothkind==BlueToothKind_Ble)
       [_blueToothPI startScan:30 isclear:YES];
    else
    { //mfi
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
        
    
        
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerBroadcast];
    @try {
        _blueToothPI  = [BlueToothFactory Create:self.bluetoothkind];
    } @catch (NSException *exception) {
        NSLog(@"BlueToothFactory exception=%@",exception);
    };
    [self performSelector:@selector(initPullRefresh) withObject:nil afterDelay:1.5f];
    
}


- (void)handleNotification:(NSNotification *)notification{
    
    if([notification.name isEqualToString:(NSString *)BleServiceStatusChanged ]){
        ObserverObj *obj = notification.object;
        
        switch([obj.Msgvalue intValue]){
            case BleScanComplete:
                [self.refreshControl endRefreshing];
                break;
        }
        [self.tableView reloadData];
    }
    else if([notification.name isEqualToString:(NSString *)BleServiceFindDevice ]){
        [self.tableView reloadData];
    }
    else if ([notification.name isEqualToString:(NSString *)BleSystemBluetoothReady ]) {
        NSLog(@"！！！！！系统准备完毕！！！！");
    }
}

-(void)registerBroadcast{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:(NSString *)BleServiceStatusChanged object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:(NSString *)BleServiceFindDevice object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:(NSString *)BleSystemBluetoothReady object:nil];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   //
    NSArray *devlist=_blueToothPI.getBleDevicelist;
    //SLog(@"devlist=%p  count=%ld",devlist,[devlist count]);
    return [devlist count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *devlist = _blueToothPI.getBleDevicelist;
    if([devlist objectAtIndex:indexPath.row])
    {
         RTDeviceinfo *device=[devlist objectAtIndex:indexPath.row];
        if([device.ShortAddress length]>0)
        {
            return 60;
        }
        return 40;
    }
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier;
    
    
    
    CellIdentifier  = @"menu";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSMutableArray *devlist = _blueToothPI.getBleDevicelist;
    
    RTDeviceinfo * device =  [devlist objectAtIndex:indexPath.row];
    
    NSString * isConnect =@"";
    if (_printerManager.CurrentPrinter.PrinterPi != nil)
    {
      if ([_printerManager.CurrentPrinter.PrinterPi.Address isEqualToString:device.UUID])
         isConnect = @"(*)";
    }
    cell.textLabel.text =   [NSString stringWithFormat:@"%@%@ rssi:%ld",device.name, isConnect,device.rssiLevel] ;
    
    if([device.ShortAddress length] == 0){
        cell.detailTextLabel.text = device.UUID;
    }
    else{
        cell.detailTextLabel.text = device.ShortAddress;
     
    }
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_blueToothPI stopScan];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *devlist = _blueToothPI.getBleDevicelist;
    RTDeviceinfo * device =  [devlist objectAtIndex:indexPath.row];
    [_delegate selectDeviceInfo:device];
    [self.navigationController popViewControllerAnimated:YES];
 
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


@end
