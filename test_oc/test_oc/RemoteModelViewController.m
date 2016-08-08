//
//  RemoteModelViewController.m
//  test_oc
//
//  Created by mingo on 2016/5/26.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import "RemoteModelViewController.h"
#import "MainController.h"

#import "IR/BomeansIRKit.h"
#import "IR/BIRModelItem.h"

@interface RemoteModelViewController (){
    
    NSArray *remoteKeys;
    id<BIRRemote> remoteModal;
    MainController *mainC;
    
    NSMutableArray* _keyArray;
    
    
    __weak IBOutlet UIButton *button_power;
    __weak IBOutlet UIButton *button_channel_up;
    __weak IBOutlet UIButton *button_channel_down;
    __weak IBOutlet UIButton *button_volume_up;
    __weak IBOutlet UIButton *button_volume_down;
    __weak IBOutlet UIButton *button_mute;
    __weak IBOutlet UIButton *button_1;
    __weak IBOutlet UIButton *button_2;
    __weak IBOutlet UIButton *button_3;
    __weak IBOutlet UIButton *button_4;
    __weak IBOutlet UIButton *button_5;
    __weak IBOutlet UIButton *button_6;
    __weak IBOutlet UIButton *button_7;
    __weak IBOutlet UIButton *button_8;
    __weak IBOutlet UIButton *button_9;
    __weak IBOutlet UIButton *button_0;
    
}


@end

@implementation RemoteModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mainC = [[MainController alloc] init];
    
    //取類型資料清單
    remoteModal = self.getMainCRemoteModel;
    
    remoteKeys = [remoteModal getAllKeys];
    
    //LOG array
    //NSLog(@"The content of arry is %@",remoteKeys);
    
    
    _keyArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_POWER_TOGGLE", @"key", button_power, @"value", nil]];
    
    //NSLog(@"The setup button of arry is %@",_keyArray);
    
    
    //設定button key 的 key code
    for (NSDictionary* dict in _keyArray)
    {
        BOOL isFound = NO;
        
        NSString* strKey = [dict objectForKey:@"key"];
        for (NSString* strKey2 in remoteKeys)
        {
            if (NSOrderedSame == [strKey caseInsensitiveCompare:strKey2])
            {
                isFound = YES;
                break;
            }
        }
        
        NSLog(isFound ? @"Yes" : @"No");
        
        if (isFound)
        {
            //[[dict objectForKey:@"value"] setHidden:NO];
            //[[dict objectForKey:@"value"] setEnabled:YES];
        }
        else
        {
            //[[dict objectForKey:@"value"] setHidden:YES];
            //[[dict objectForKey:@"value"] setEnabled:NO];
        }
    }
    
    
    
}

//取某類型&廠牌下的遙控器清單
-(id <BIRRemote>)getMainCRemoteModel
{
    //NSArray *remoteModel = [mainC getRemoteList:self.typeID andBrand:self.brandID getNew:false];
    
    remoteModal = [mainC createRemoter:self.typeID withBrand:self.brandID andModel:self.remoteID getNew:false];
    
    
    //remoteModal = [mainC createRemoter:@"1" withBrand:@"13" andModel:@"LCD09" getNew:false];
    
    return remoteModal;
}


//回到 Main controller
- (IBAction)goMainController:(UIButton *)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}



//按下按鍵
- (IBAction)keyButtonClicked:(id)sender
{
    for (NSDictionary* dict in _keyArray)
    {
        NSLog(@"%@",sender);
        
        if (sender == [dict objectForKey:@"value"])
        {
            //NSLog(@"%@",[dict objectForKey:@"key"]);
            [remoteModal transmitIR:[dict objectForKey:@"key"] withOption:nil];
            break;
        }
    }
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

@end
