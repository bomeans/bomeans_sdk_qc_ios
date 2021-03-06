//
//  SmartPickerViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/17.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "ACPickerViewController.h"
#import "ACPickerView.h"
#import "DataProvider.h"
#import "BIRModelItem.h"
#import "RemoteViewController.h"
#import "RecountView.h"

NSTimer* recountTimer;

@interface ACPickerViewController () <ACPickerViewDelegate, BIRAcAutoPickerDelegate, RecountViewDelegate>

@property (nonatomic, strong) ACPickerView*     myView;
@property (nonatomic, strong) DataProvider*     dataProvider;
@property (nonatomic, strong) id<BIRACPicker>   picker;
@property (nonatomic, strong) NSMutableArray*   modelArray;
@property (nonatomic, strong) BIRAcAutoPicker*  smartPicker;
@property (nonatomic, strong) RecountView*      recountView;
@property (nonatomic, assign) int               recountTimeNum;

@end

@implementation ACPickerViewController

- (ACPickerView*)myView{
    if (!_myView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _myView = [[ACPickerView alloc] initWithFrame:viewFrame];
        _myView.delegate = self;
        [self.view addSubview:_myView];
    }
    return _myView;
}

-(RecountView *)recountView{
    if (!_recountView) {
        CGRect viewFrame = CGRectMake(0, (self.view.frame.size.height)/2/2, self.view.frame.size.width, self.view.frame.size.height/2);
        _recountView = [[RecountView alloc] initWithFrame:viewFrame];
        _recountView.delegate = self;
    }
    return _recountView;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _modelArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self myView];
    [self recountView];
    
    _dataProvider = [DataProvider sharedInstance];
    _picker = [_dataProvider createACSmartPickerWithBrand:self.brandID];
    _smartPicker = [[BIRAcAutoPicker alloc] init];
    _smartPicker.delegate = self;
    
    NSDictionary *dic = [_picker begin];
    NSString *key = [dic objectForKey:@"keyid"];
    if (key.length > 0) {
        [_myView setCheckedButtonTitle:key];
    }
    BIRModelItem *model = [dic objectForKey:@"model"];
    self.navigationItem.title = [NSString stringWithFormat:@"(%d/%d)%@", [_picker getNowModelNum], [_picker getModelCount], model.model];
}

- (void)pickerResult:(BOOL)flag{
    int result = [_picker keyResult:flag];
    
    if (BIR_PNext == result) {
        if (!flag) {
            BIRModelItem *nextModel = [_picker getNextModel];
            self.navigationItem.title = [NSString stringWithFormat:@"(%d/%d)%@", [_picker getNowModelNum], [_picker getModelCount], nextModel.model];
        }
        NSString *nextKey = [_picker getNextKey];
        if (nextKey.length > 0) {
            [_myView setCheckedButtonTitle:nextKey];
        }
    }else if (BIR_PFind == result){
        NSArray *resultArray = [_picker getPickerResult];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
        for (BIRRemoteUID *uid in resultArray) {
            BIRModelItem *item = [[BIRModelItem alloc] initWithModel:uid.modelID machineModel:uid.modelID country:nil releaseTime:nil];
            [tempArray addObject:item];
        }
        _modelArray = tempArray;
        [self chooseModel];
    }else{  //BIR_PFail
        _modelArray = [NSMutableArray new];
        [self chooseModel];
    }
}

- (void)chooseModel{
    if (_modelArray.count == 0) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Tip" message:@"Did not find the matching remote control！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }else if (_modelArray.count == 1) {
        BIRModelItem* item = [_modelArray objectAtIndex:0];
        [self toCreateRemote:item.model];
    }else{
        UIAlertController* alertSheet = [UIAlertController alertControllerWithTitle:@"choice remote control" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertSheet addAction:cancelAction];
        
        for (int i = 0; i < _modelArray.count; i++) {
            BIRModelItem* model = _modelArray[i];
            UIAlertAction* action = [UIAlertAction actionWithTitle:model.model style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self toCreateRemote:model.model];
            }];
            [alertSheet addAction:action];
        }
        [self presentViewController:alertSheet animated:YES completion:nil];
    }
}

- (void)toCreateRemote:(NSString*)model{
    RemoteViewController *view = [[RemoteViewController alloc] init];
    view.currentType = @"2";
    view.currentBrand = self.brandID;
    view.currentModel = model;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - ACPickerViewDelegate
- (void)checkedButtonClick:(NSString*)title{
    [_picker transmitIR];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tip" message:@"是否有回應" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
        [self pickerResult:NO];
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        [self pickerResult:YES];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)startButtonClick
{
    [_picker beginAutoPicker];
    [self.view addSubview:_recountView];
    [self startRecount:3];
    [_recountView setMsgLableText:[NSString stringWithFormat:@"%d", self.recountTimeNum]];
}

- (void)stopButtonClick
{
    [_picker endAutoPicker];
    NSArray *array = [_picker getPickerResult];
    BIRRemoteUID *remote = [array objectAtIndex:0];
    NSLog(@"remote model : %@", remote.modelID);
    NSString *nextKey = [_picker getNextKey];
    if (nextKey.length > 0) {
        [_myView setCheckedButtonTitle:nextKey];
    }
}

- (void)startRecount : (int)num
{
    [recountTimer invalidate];
    self.recountTimeNum = num;
    recountTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.recountTimeNum--;
        [_recountView setMsgLableText:[NSString stringWithFormat:@"%d", self.recountTimeNum]];
        if (self.recountTimeNum == 0) {
            [recountTimer invalidate];
        }
    }];
}

#pragma mark - BIRAcAutoPickerDelegate
-(void)acAutoPickerIndex:(int)index withModel:(BIRModelItem*)model
{
    self.navigationItem.title = [NSString stringWithFormat:@"(%d/%d)%@", [_picker getNowModelNum], [_picker getModelCount], model.model];
    //NSLog(@"%d / %d : %@", index, [_picker getModelCount], model.model);
    [self startRecount:3];
    [_recountView setMsgLableText:[NSString stringWithFormat:@"%d", self.recountTimeNum]];
}

-(void)autoPickerNoMatches{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tip" message:@"自動配對發碼結束" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        [_recountView removeFromSuperview];
    }];
}

#pragma mark - RecountViewDelegate
-(void)pressStopButton
{
    [_recountView removeFromSuperview];
    [recountTimer invalidate];
    [self stopButtonClick];
}

@end
