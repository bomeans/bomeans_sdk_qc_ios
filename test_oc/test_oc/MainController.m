//
//  ViewController.m
//  test_oc
//
//  Created by mingo on 2016/5/18.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import "MainController.h"
#import "IR/BomeansIRKit.h"
#import "IR/BIRRemote.h"
#import "IR/BIRTypeItem.h"
//#import "YouHW.h"
#import "myHW.h"

static NSString *API_KEY=@"36c3862a5dddca583f3fb7e8effb712c0540ff7de";

@interface MainController ()
{
    id<BIRRemote> remote;
    
    BomeansIRKit *irKit;
}

//@property (weak, nonatomic) IBOutlet UIButton *btSendIR;

@end

@implementation MainController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //判斷使用遠端還近端
    NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
    //預設使用近端
    [defaultValue setObject:@"local" forKey:@"wifiToIR"];
    [defaultValue synchronize];
    
}


- (id)init
{
    self = [super init];
    if (self)
    {
        //設定API KEY
        irKit = [[BomeansIRKit alloc] initWithKey:API_KEY];
        
        // 設定使用中國大陸地區的web server 供web api 跟create remote 使用
        [BomeansIRKit setUseChineseServer:NO];
        
        //判斷使用遠端還近端
        NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
        NSString *wifiRoIr =[defaultValue stringForKey:@"wifiToIR"];
        if([wifiRoIr isEqual:@"cloud"]){
            //使用自定義的HW (遠端)
            myHW *myHW_1 = [[myHW alloc] init];     // 建立你的hw
            [irKit setIRHW:myHW_1];                 // 設定給SDK 使用
        }
        else{
            [irKit setIRHW:nil];
        }
        //[_btSendIR setEnabled:YES];
        
        
        //id<BIRTVPicker> _picker = [self createSmartPicker:@"1" withBrand:@"13"];
        //NSLog(@"%@",_picker);
        
    }
    return self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString*)language
{
    return @"tw";
}


//取出廠牌清單
- (NSArray*)getTypeList
{
    return [irKit webGetTypeList:[self language]];
}


//取出某類型下的所有廠牌清單
- (NSArray*)getBrandList:(NSString*)typeID
{
    return [irKit webGetBrandList:typeID start:0 number:1800 language:[self language] brandName:nil getNew:false];
}

//取出某類型下的十大廠牌清單
- (NSArray*)getTop10BrandList:(NSString*)typeID
{
    return [irKit webGetTopBrandList:typeID start:0 number:10 language:[self language] getNew:false];
}


//取出某類型&廠牌下所有遙控器清單
- (NSArray*)getRemoteList:(NSString*)typeID andBrand:(NSString*)brandID getNew:(bool)newData;
{
    return [irKit webGetRemoteModelList:typeID andBrand:brandID getNew:false];
}

//建立遙控器
- (id <BIRRemote>)createRemoter:(NSString*)typeID withBrand:(NSString*)brandID andModel:(NSString*)moduleID getNew:(bool)newData
{
    return [irKit createRemoteType:typeID withBrand:brandID andModel:moduleID getNew:false];
}


//選碼
- (id)createSmartPicker:(NSString*)type withBrand:(NSString*)brand
{
    return [irKit createSmartPicker:type withBrand:brand getNew:NO];
}

@end








