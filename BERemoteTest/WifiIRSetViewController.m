//
//  WifiIRSetViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/8.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//
#import "WifiIRSetViewController.h"
#import "WifiIRSetViewCell.h"
#import "DataProvider.h"
#import "IR/BomeansWifiToIRDiscovery.h"
#import "IR/BIRIpAndMac.h"
#import "WifiSetViewController.h"
#import "IRDetailViewController.h"
#import "IRSetViewController.h"

@interface WifiIRSetViewController ()<BIRWifiToIRDiscoveryDelegate> {
    DataProvider* _dataProvider;
    BomeansWifiToIRDiscovery* _discovery;
    NSMutableArray* _contentArray;
    NSMutableArray* _contentTitleArray;
    NSInteger _currentSegmentedIndex;
    NSIndexPath* _currentSelectIrIndexPath;
    BOOL _irConnectFlag;
}
@end

@implementation WifiIRSetViewController

- (void)dealloc{
    //[_discovery cancelNext];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _contentArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataProvider = [DataProvider initDataProvider];
    //_discovery = [[BomeansWifiToIRDiscovery alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _currentSegmentedIndex = 0;
    
    NSMutableArray* irStateArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray* wifiIrArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"轉發器", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"轉發器Wifi狀態", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wifi設定", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Led及定時設定", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    
    _contentArray = [[NSMutableArray alloc] initWithObjects:irStateArray, wifiIrArray, nil];
    _contentTitleArray = [NSMutableArray arrayWithObjects:@"", @"選擇轉發器", nil];
    
    [self checkWifiIrConnect];
    [self choiceServer:nil];
}

//轉發器連接狀態
-(void)checkWifiIrConnect{
    int irState = [_dataProvider getWifiIRState];
    _irConnectFlag = irState==BIROK?true:false;
    NSLog(@"wifi: %i",irState);
    
    NSString* state;
    
    switch (irState) {
        case BIROK:
            state = @"已連線";
            break;
        case BIRNotConnectToNetWork:
            state = @"未連線至網路";
            break;
        case BIRNotFindWifiToIR:
            state = @"找不到轉發器";
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:[[_contentArray objectAtIndex:0] objectAtIndex:1]];
    [dict setValue:state forKey:@"ip"];
    
    [[_contentArray objectAtIndex:0] replaceObjectAtIndex:1 withObject:dict];
    [self.tableView reloadData];
}

-(NSArray*)discoveryWifiToIR{
    _discovery = [[BomeansWifiToIRDiscovery alloc] init];
    
    NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    if(( [_discovery discoryBlockTryTime:5] ) || (_discovery.allWifiToIr.allValues.count > 0))
    {
        //搜尋所有轉發器裝置
        NSArray *devices = _discovery.allWifiToIr.allValues;
        //NSLog(@"all : %@",allDevice);
        for(BIRIpAndMac *device in devices)
        {
            NSString *deviceName = [device.extraInfo substringFromIndex:(device.extraInfo.length - 4)];
            NSString *deviceIP = device.ip;
            NSString *deviceMAC = device.mac;
            NSString *deviceCoreID = device.extraInfo;
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:deviceName, @"name", deviceIP, @"ip", deviceMAC, @"mac", deviceCoreID, @"coreid", nil];
            
            [deviceArray addObject:dict];
        }
    }
    else
    {
        NSLog(@"Not find wifiTO ir");
    }
    [_discovery cancelNext];
    
    return deviceArray;
}

-(void)choiceServer:(UISegmentedControl*)sender{
    if (sender) {
        _currentSegmentedIndex = sender.selectedSegmentIndex;
    }
    
    NSLog(@"choice server : %ld", _currentSegmentedIndex);
    NSMutableArray* wifiIrArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    switch (_currentSegmentedIndex) {
        case 0:
        {
            [_dataProvider setIRHW:BIRLocal];
            wifiIrArray = [NSMutableArray arrayWithArray:[self discoveryWifiToIR]];
        }
            break;
        case 1:
        {
            //[wifiIrArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"name1", @"name", @"ip1", @"ip", @"mac1", @"mac", @"coreid1", @"coreid", nil]];
            //[wifiIrArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"nam2", @"name", @"ip2", @"ip", @"mac2", @"mac", @"coreid2", @"coreid", nil]];
            wifiIrArray = [[NSMutableArray alloc] initWithArray:[_dataProvider.defaultValue objectForKey:@"deviceArray"]];
            
            for (int i = 0; i < wifiIrArray.count; i++) {
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:wifiIrArray[i]];
                NSString* irCoreID = [dict objectForKey:@"coreid"];
                
                bool onLineBool = [self checkRemoteWifiToIRLogin:irCoreID];
                if (onLineBool) {
                    [dict setValue:@"線上" forKey:@"ip"];
                }else [dict setValue:@"離線" forKey:@"ip"];
                
                [wifiIrArray replaceObjectAtIndex:i withObject:dict];
            }
            
            //遠端時先改為群體廣播...清空近端時的裝置設定用 可不清
            [_dataProvider.irKit setWifiToIrIP: nil];
            
            [_dataProvider setIRHW:BIRCloud];
        }
            break;
        default:
            break;
    }
    [_contentArray replaceObjectAtIndex:1 withObject:wifiIrArray];
    [self.tableView reloadData];
}

//檢查遠端轉發器是否上線
-(BOOL)checkRemoteWifiToIRLogin:(NSString*)coreID{
    
    NSString *fiviApiUrl = @"http://api.openfivi.com:3000/login";
    
    
    //1.Use NSDictionary
    //NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                          coreID, @"coreid",
    //                          nil];
    //NSData* jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:kNilOptions error:&error];
    
    //2.use json string
    NSString *jsonStr = [NSString stringWithFormat: @"{\"coreid\":\"%@\"}", coreID];
    NSLog(@"Post jsonStr : %@", jsonStr);
    
    NSError __block *sendError = nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse __block *sendResponse;
    NSData __block *localData = nil;
    
    BOOL __block reqProcessed = false;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fiviApiUrl]];
    [request setHTTPMethod:@"POST"];
    
    if (sendError == nil)
    {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        // Send the request and get the response
        //localData = [NSURLConnection sendSynchronousRequest:request returningResponse:&sendResponse error:&sendError];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            localData = data;
            sendError = error;
            sendResponse = response;
            reqProcessed = true;
        }] resume];
        
        while (!reqProcessed) {
            [NSThread sleepForTimeInterval:0];
        }
        
        //NSString *result = [[NSString alloc] initWithData:localData encoding:NSASCIIStringEncoding];
        //NSLog(@"Post result : %@", result);
        
        
        NSError *jsonError = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:localData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jsonError];
        NSLog(@"Post result : %@", responseDict);
        
        NSString* success = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"success"]];
        //NSLog(@"success : %@", success);
        
        if ([success isEqualToString:@"1"]) {
            return YES;
        }else return NO;
    }
    else
        return NO;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_contentArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* nibName = @"WifiIRSetViewCell";
    static NSString* cellIdentifer = @"wifiSetCell";
    static NSString* cellIdentiferForSW = @"wifiSetCellSW";
    static NSString* cellIdentiferForState = @"wifiSetCellState";
    static NSString* cellIdentiferForWifiSet = @"wifiSetCellWifiSet";
    
     WifiIRSetViewCell *cell;
     if (indexPath.section == 0) {
         switch (indexPath.row) {
             case 0:
                 cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForSW];
                 break;
             case 1:
                 cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForState];
                 break;
             default:
                 cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForWifiSet];
                 break;
         }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    }
    
     if (!cell) {
         if (indexPath.section == 0) {
             switch (indexPath.row) {
                 case 0:
                 {
                     [tableView registerClass:[WifiIRSetViewCell class] forCellReuseIdentifier:cellIdentiferForSW];
                     cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForSW];
                 }
                     break;
                 case 1:
                 {
                     [tableView registerClass:[WifiIRSetViewCell class] forCellReuseIdentifier:cellIdentiferForState];
                     cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForState];
                     cell = [cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentiferForState];
                 }
                     break;
                 default:
                 {
                     [tableView registerClass:[WifiIRSetViewCell class] forCellReuseIdentifier:cellIdentiferForWifiSet];
                     cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForWifiSet];
                 }
                     break;
             }
         }else{
             [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellIdentifer];
             cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
         }
     }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_contentTitleArray objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UISegmentedControl* segmented = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"近端", @"遠端", nil]];
                segmented.selectedSegmentIndex = _currentSegmentedIndex;
                [segmented addTarget:self action:@selector(choiceServer:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = segmented;
            }
                break;
            case 1:
            {
                UIButton* button = [[UIButton alloc] init];
                [button setFrame:CGRectMake(0, 0, 25, 25)];
                [button setBackgroundImage:[UIImage imageNamed:@"Button-Refresh"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(checkWifiIrConnect) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = button;
            }
                break;
            default:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }

    cell.textLabel.text = [NSString stringWithFormat:@"   %@",[[[_contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.detailTextLabel.text = [[[_contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"ip"];
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            WifiSetViewController* view = [[WifiSetViewController alloc] initWithNibName:@"WifiSetViewController" bundle:nil];
            [self.navigationController pushViewController:view animated:YES];
        }
        else if (indexPath.row == 3){
            IRSetViewController* view = [[IRSetViewController alloc] initWithNibName:@"IRSetViewController" bundle:nil];
            view.currentServer = _currentSegmentedIndex;
            [self.navigationController pushViewController:view animated:YES];
        }
    }else{
        //選擇轉發器
        if (_currentSegmentedIndex == 0) {
            //近端
            _currentSelectIrIndexPath = indexPath;
            WifiIRSetViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString* deviceIP = cell.detailTextLabel.text;
            if (deviceIP) {
                //設定此用此裝置
                [_dataProvider.irKit setWifiToIrIP: deviceIP];
            }
            
            NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithArray:[_dataProvider.defaultValue objectForKey:@"deviceArray"]];
            //deviceArray = [_dataProvider.defaultValue objectForKey:@"deviceArray"];
            NSDictionary* dict = [[_contentArray objectAtIndex:1] objectAtIndex:indexPath.row];
            bool dataexist = false;
            
            for (NSDictionary* deviceDict in deviceArray) {
                NSString* deviceName = [deviceDict objectForKey:@"name"];
                NSString* cellName = [dict objectForKey:@"name"];
                if ([deviceName isEqualToString:cellName]) {
                    dataexist = true;
                    break;
                }
            }
            if (!dataexist) {
                [deviceArray addObject:dict];
                [_dataProvider.defaultValue setObject:deviceArray forKey:@"deviceArray"];
                [_dataProvider.defaultValue synchronize];
            }
        }else{
            //遠端
            _currentSelectIrIndexPath = indexPath;
            NSDictionary* dict = [[_contentArray objectAtIndex:1] objectAtIndex:indexPath.row];
            NSString* coreID = [dict valueForKey:@"coreid"];
            [_dataProvider.defaultValue setObject:coreID forKey:@"deviceCoreID"];
            [_dataProvider.defaultValue synchronize];
        }
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
        if (oldIndex == nil) {
            oldIndex = _currentSelectIrIndexPath;
        }
        [self.tableView cellForRowAtIndexPath:oldIndex].textLabel.text = [NSString stringWithFormat:@"   %@", [[[_contentArray objectAtIndex:oldIndex.section] objectAtIndex:oldIndex.row] objectForKey:@"name"]];
        [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"\u2713%@",[[[_contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    IRDetailViewController* view = [[IRDetailViewController alloc] initWithNibName:@"IRDetailViewController" bundle:nil];
    view.wifiIrDict = [[_contentArray objectAtIndex:1] objectAtIndex:indexPath.row];
    view.segmentedIndex = _currentSegmentedIndex;
    
    [self.navigationController pushViewController:view animated:YES];
    
    if (_currentSegmentedIndex == 1) {
        view.sendBack = ^{
            [self choiceServer:nil];
        };
    }
    
}

/*
#pragma mark - BIRWifiToIRDiscoveryDelegate
-(void)wifiToIR:(id)obj discoryWifiToIr:(BIRIpAndMac*)ipAndMac
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [_contentArray replaceObjectAtIndex:1 withObject:[self discoveryWifiToIR]];
                       [self.tableView reloadData];
                   });
}

-(void)wifiToIR:(id)obj process:(int)step
{
    
}

-(void)wifiToIR:(id)obj endDiscory:(BOOL)result
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [_contentArray replaceObjectAtIndex:1 withObject:[self discoveryWifiToIR]];
                       [self.tableView reloadData];
                   });
}*/

@end
