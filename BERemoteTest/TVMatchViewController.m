//
//  TVMatchViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/2.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "TVMatchViewController.h"
#import "IR/BIRTVPicker.h"
#import "IR/BIRRemote.h"
#import "IR/BIRModelItem.h"
#import "DataProvider.h"
#import "RemoteViewController.h"

@interface TVMatchViewController (){
    id<BIRTVPicker> _picker;
    NSMutableArray* _keyArray;
    NSInteger _currentPickerIndex;
    NSMutableArray* _modelArray;
    
    __weak IBOutlet UIButton* _checkButton;
}
@end

@implementation TVMatchViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _keyArray = [[NSMutableArray alloc]initWithCapacity:1];
        _modelArray = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPickerIndex = 1;
    self.navigationItem.title = [self.brandName stringByAppendingFormat:@"-%ld",_currentPickerIndex];
    
    UIBarButtonItem *naviLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"＜Back" style:UIBarButtonItemStylePlain target:self action:@selector(popToRootViewController:)];
    self.navigationItem.leftBarButtonItem = naviLeftButton;
    
    [_keyArray addObject:@"IR_KEY_CHANNEL_UP"];
    [_keyArray addObject:@"IR_KEY_VOLUME_UP"];
    [_keyArray addObject:@"IR_KEY_MUTING"];
    [_keyArray addObject:@"IR_KEY_MENU"];
    [_keyArray addObject:@"IR_KEY_POWER_TOGGLE"];
    
    self.typeID = @"1";
    _picker = [[DataProvider initDataProvider] createSmartPickerWithType:self.typeID withBrand:self.brandID];
    
    if ([_picker begin].length > 0) {
        for (NSString* defaultKey in _keyArray) {
            if ([defaultKey isEqualToString:[_picker begin]]) {
                [_checkButton setTitle:defaultKey forState:UIControlStateNormal];
                break;
            }
        }
    }
    
}

-(void)popToRootViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)checkButtonClick:(id)sender{
    [_picker transmitIR];
    
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"是否有回應" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    alertView.tag = 2;
//    [alertView show];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tip" message:@"是否有回應" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
        [self alertControllerTag:2 clickedButtonAtIndex:0];
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        [self alertControllerTag:2 clickedButtonAtIndex:1];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) setupRemoter:(NSInteger)index{
    
    BIRModelItem* model = [_modelArray objectAtIndex:index];
    
    RemoteViewController* view = [[RemoteViewController alloc] initWithNibName:@"RemoteViewController" bundle:nil];
    view.typeID = self.typeID;
    view.brandID = self.brandID;
    view.modelID = model.model;
    view.brandName = self.brandName;
    
    [self.navigationController pushViewController:view animated:YES];
    
}

- (void)alertControllerTag:(NSInteger)tag clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (tag == 2)
    {
        if (1 == buttonIndex)
        {
            int res = [_picker keyResult:YES];
            
            if (res == BIR_PNext)
            {
                NSString* key = [_picker getNextKey];
                if (key.length > 0)
                {
                    for (NSString* defaultKey in _keyArray) {
                        if ([defaultKey isEqualToString:key]) {
                            [_checkButton setTitle:defaultKey forState:UIControlStateNormal];
                            break;
                        }
                    }
                    _checkButton.hidden = NO;
                }
                else
                {
                    _checkButton.hidden = YES;
                }
                self.navigationItem.title = [self.brandName stringByAppendingFormat:@"-%ld",_currentPickerIndex];
            }
            else if (res == BIR_PFind)
            {
                NSMutableArray* tempModelArray = [[NSMutableArray alloc] initWithCapacity:1];
                NSArray* array = [_picker getPickerResult];
                for (BIRRemoteUID* uid in array)
                {
                    BIRModelItem* item = [[BIRModelItem alloc] initWithModel:uid.modelID machineModel:uid.modelID country:nil releaseTime:nil];
                    [tempModelArray addObject:item];
                }
                
                _modelArray = tempModelArray;
                
                self.navigationItem.title = [self.brandName stringByAppendingFormat:@"-%ld",_currentPickerIndex];
                
//                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"已找到遙控器" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alertView.tag = 3;
//                [alertView show];
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tip" message:@"已找到遙控器" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
                    [self alertControllerTag:3 clickedButtonAtIndex:1];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else
            {
//                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"已找到遙控器" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alertView.tag = 3;
//                [alertView show];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tip" message:@"已找到遙控器" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
                    [self alertControllerTag:3 clickedButtonAtIndex:1];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else
        {
            int res = [_picker keyResult:NO];
            
            if (res == BIR_PNext)
            {
                NSString* key = [_picker getNextKey];
                if (key.length > 0)
                {
                    for (NSString* defaultKey in _keyArray) {
                        if ([defaultKey isEqualToString:key]) {
                            [_checkButton setTitle:defaultKey forState:UIControlStateNormal];
                            break;
                        }
                    }
                    _checkButton.hidden = NO;
                }
                else
                {
                    _checkButton.hidden = YES;
                }
                
                _currentPickerIndex += 1;
                
                self.navigationItem.title = [self.brandName stringByAppendingFormat:@"-%ld",_currentPickerIndex];
            }
            else if (res == BIR_PFind)
            {
                _currentPickerIndex += 1;
                
                self.navigationItem.title = [self.brandName stringByAppendingFormat:@"-%ld",_currentPickerIndex];
                
//                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"已找到遙控器" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alertView.tag = 3;
//                [alertView show];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tip" message:@"已找到遙控器" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
                    [self alertControllerTag:3 clickedButtonAtIndex:1];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                _modelArray = [NSMutableArray new];
                
//                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"未找到遙控器" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alertView.tag = 3;
//                [alertView show];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tip" message:@"未找到遙控器" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
                    [self alertControllerTag:3 clickedButtonAtIndex:1];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    else if (tag == 3)
    {
        if (_modelArray.count == 0) {
            
        }
        else
            if (_modelArray.count == 1)
            {
                //[self commitButtonClicked:nil];
                [self setupRemoter:0];
            }
            else
            {
                UIAlertController* alertSheet = [UIAlertController alertControllerWithTitle:@"ChooseRemote" message:@"message" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
                
                [alertSheet addAction:cancelAction];
                
                for (int i = 0; i < _modelArray.count; i++) {
                    BIRModelItem* model = _modelArray[i];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:model.model style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self setupRemoter:i];
                        //NSLog(@"click index %@[%i]", action.title, i);
                    }];
                    [alertSheet addAction:action];
                }
                
                [self presentViewController:alertSheet animated:YES completion:nil];
            }
    }
}

/*
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 2)
    {
        if (1 == buttonIndex)
        {
            int res = [_picker keyResult:YES];
            
            if (res == BIR_PNext)
            {
                NSString* key = [_picker getNextKey];
                if (key.length > 0)
                {
                    for (NSString* defaultKey in _keyArray) {
                        if ([defaultKey isEqualToString:key]) {
                            [_checkButton setTitle:defaultKey forState:UIControlStateNormal];
                            break;
                        }
                    }
                    _checkButton.hidden = NO;
                }
                else
                {
                    _checkButton.hidden = YES;
                }
                self.navigationItem.title = [self.brandName stringByAppendingFormat:@"-%ld",_currentPickerIndex];
            }
            else if (res == BIR_PFind)
            {
                NSMutableArray* tempModelArray = [[NSMutableArray alloc] initWithCapacity:1];
                NSArray* array = [_picker getPickerResult];
                for (BIRRemoteUID* uid in array)
                {
                    BIRModelItem* item = [[BIRModelItem alloc] initWithModel:uid.modelID machineModel:uid.modelID country:nil releaseTime:nil];
                    [tempModelArray addObject:item];
                }
                
                _modelArray = tempModelArray;
                
                self.navigationItem.title = [self.brandName stringByAppendingFormat:@"-%ld",_currentPickerIndex];
                
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"已找到遙控器" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertView.tag = 3;
                [alertView show];
            }
            else
            {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"已找到遙控器" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertView.tag = 3;
                [alertView show];
            }
        }
        else
        {
            int res = [_picker keyResult:NO];
            
            if (res == BIR_PNext)
            {
                NSString* key = [_picker getNextKey];
                if (key.length > 0)
                {
                    for (NSString* defaultKey in _keyArray) {
                        if ([defaultKey isEqualToString:key]) {
                            [_checkButton setTitle:defaultKey forState:UIControlStateNormal];
                            break;
                        }
                    }
                    _checkButton.hidden = NO;
                }
                else
                {
                    _checkButton.hidden = YES;
                }
                
                _currentPickerIndex += 1;
                
                self.navigationItem.title = [self.brandName stringByAppendingFormat:@"-%ld",_currentPickerIndex];
            }
            else if (res == BIR_PFind)
            {
                _currentPickerIndex += 1;
                
                self.navigationItem.title = [self.brandName stringByAppendingFormat:@"-%ld",_currentPickerIndex];
                
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"已找到遙控器" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertView.tag = 3;
                [alertView show];
            }
            else
            {
                _modelArray = [NSMutableArray new];
                
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"未找到遙控器" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertView.tag = 3;
                [alertView show];
            }
        }
    }
    else if (alertView.tag == 3)
    {
        if (_modelArray.count == 0) {
            
        }
        else
            if (_modelArray.count == 1)
            {
                //[self commitButtonClicked:nil];
                [self setupRemoter:0];
            }
            else
            {
                
//                UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"ChooseRemote" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
//                
//                for (BIRModelItem* model in _modelArray)
//                {
//                    [sheet addButtonWithTitle:model.model];
//                }
//                
//                [sheet showInView:self.view];
                
                
                UIAlertController* alertSheet = [UIAlertController alertControllerWithTitle:@"ChooseRemote" message:@"message" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];

                [alertSheet addAction:cancelAction];
                
                for (int i = 0; i < _modelArray.count; i++) {
                    BIRModelItem* model = _modelArray[i];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:model.model style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self setupRemoter:i];
                        //NSLog(@"click index %@[%i]", action.title, i);
                    }];
                    [alertSheet addAction:action];
                }
                
                [self presentViewController:alertSheet animated:YES completion:nil];
                
            }
    }
}
*/
/*
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        return;
    }
    
    [self setupRemoter:buttonIndex-1];
    
    
    //self.device.name = model.model;
//    self.device.modelID = model.model;
//    device.remoter = _remoter;
//    device.keys = [_remoter getAllKeys];
//    
//    [[DeviceManager sharedInstance] save];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceChangedNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceRefreshNotification" object:nil];
//    
//    [self.navigationController popViewControllerAnimated:YES];
}*/

@end
