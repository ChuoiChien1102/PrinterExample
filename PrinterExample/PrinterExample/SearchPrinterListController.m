//
//  SearchPrinterListController.m
//  PrinterExample
//
//  Created by king on 2019/10/23.
//  Copyright © 2019年 Printer. All rights reserved.
//

#import "SearchPrinterListController.h"
#import "NetworkPrinter.h"

@implementation SearchPrinterListController{
    NetworkPrinter *_networkprinter;
}


#pragma mark - Table view data source

-(void)initPullRefresh{
    
    //采用iOS6 的自带的UIRefreshControl控制下拉刷新
    
    __weak typeof(self)weakSelf = self;
    [_networkprinter GetNetWorkPrinter:^(NetPrinterInfo * _Nonnull netPrinterinfo) {
        NSLog(@"ip=%@ mac->%@ \n subMask->%@ gateWay=%@",netPrinterinfo.ip,netPrinterinfo.mac,netPrinterinfo.subMask,netPrinterinfo.gateWay);
       // [weakSelf.tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });

        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8000 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
      //  [weakSelf.tableView reloadData];
        [weakSelf.refreshControl endRefreshing];
        
    });


}

//-(void)refreshDevice{
//    NSLog(@"refreshDevice");
//
//    [_networkprinter GetNetWorkPrinter:^(NetPrinterInfo * _Nonnull netPrinterinfo) {
//        NSLog(@"refreshDevice->ip=%@ mac->%@ \n subMask->%@ gateWay=%@",netPrinterinfo.ip,netPrinterinfo.mac,netPrinterinfo.subMask,netPrinterinfo.gateWay);
//        [self.tableView reloadData];
//
//
//    }];
//    //
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    _networkprinter = [NetworkPrinter sharedInstance];
    [_networkprinter ClearNetPrintList];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"scanning",nil)] ;
    //    [refresh addTarget:self action:@selector(refreshDevice) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self.refreshControl beginRefreshing];
    

    
    [self performSelector:@selector(initPullRefresh) withObject:nil afterDelay:0.1f];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //
    NSArray *devlist=_networkprinter.GetNetPrintList;
    if (devlist)
    {
    //  NSLog(@"devlist=%p  count=%ld",devlist,[devlist count]);
      return [devlist count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier;
    
    
    
    CellIdentifier  = @"menu";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSMutableArray *devlist = _networkprinter.GetNetPrintList;
    
    NetPrinterInfo * device =  [devlist objectAtIndex:indexPath.row];
    cell.textLabel.text = device.ip;
    cell.detailTextLabel.text = device.mac;
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self.refreshControl endRefreshing];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *devlist = _networkprinter.GetNetPrintList;
    NetPrinterInfo * device =  [devlist objectAtIndex:indexPath.row];
    [_delegate selectNetworkPrinterInfo:device];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end

