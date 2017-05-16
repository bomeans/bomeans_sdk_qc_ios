//
//  MainViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/10/6.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "DataProvider.h"

@interface MainViewController ()<MainViewDelegate>

@property(nonatomic, strong)MainView*       mainView;
@property(nonatomic, strong)DataProvider*   dataProvider;
@property(nonatomic, strong)id<BIRRemote>   remoter;
@property(nonatomic, strong)id<BIRRemote>   remoterBig;
@property(nonatomic, strong)id<BIRTVPicker> picker;
@property(nonatomic, assign)CFAbsoluteTime  startTime;
@property(nonatomic, strong)NSString*       typeId;
@property(nonatomic, strong)NSString*       brandId;
@property(nonatomic, strong)NSString*       modelId;
@property(nonatomic, strong)NSMutableArray* resultArray;

@end

@implementation MainViewController

- (MainView*)mainView
{
    if (!_mainView) {
        CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _mainView = [[MainView alloc] initWithFrame:viewFrame];
        _mainView.delegate = self;
        self.navigationItem.leftBarButtonItem = _mainView.changeServerButton;
        self.navigationItem.rightBarButtonItem = _mainView.checkAllButton;
        [self.view addSubview:_mainView];
    }
    return _mainView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarItem = self.mainView.tabBarItem;
        self.navigationItem.title = @"TW";
        [self initMyView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataProvider = [DataProvider sharedInstance];
    [_dataProvider setIRHW:[_dataProvider IRHW]];
}

- (void)initMyView
{
    NSArray *defaultSectionArray = @[@"類型清單",@"廠牌清單",@"型號清單",@"創建遙控器",@"創建大萬能",
                          @"智慧選碼按鍵",@"按鍵清單",@"智慧選碼"];
    
    NSMutableArray *defaultResultArray = [NSMutableArray arrayWithCapacity:8];
    for (int i = 1; i <= 8; i++) {
        [defaultResultArray addObject:@[@"result"]];
    }
    
    [self.mainView getSectionSource:defaultSectionArray];
    [self.mainView getDataSoruce:defaultResultArray];
}

-(void)clearData{
    [_resultArray removeAllObjects];
    _resultArray = [NSMutableArray arrayWithCapacity:8];
    for (int i = 1; i <= 8; i++) {
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
        [mArray addObject:@""];
        [_resultArray addObject:mArray];
    }
    [_mainView getDataSoruce:_resultArray];
}

-(float)runTime{
    CFAbsoluteTime runTime = (CFAbsoluteTimeGetCurrent() - _startTime);
    return runTime * 1.0;
}

-(NSString*)addRunTimeWithString:(NSString*)firstString{
    return [NSString stringWithFormat:@"%@, %.3fs", firstString, [self runTime]];
}

-(NSString*)getTypeCount{
    NSArray *typeList = [_dataProvider getTypeList];
    NSString *aString = [NSString stringWithFormat:@"typeCount : %lu", typeList.count];
    return [self addRunTimeWithString:aString];
}

-(NSString*)getBrandCount{
    NSArray *brandList = [_dataProvider getBrandListWithType:@"1"];
    NSString *aString = [NSString stringWithFormat:@"brandCount : %lu", brandList.count];
    return [self addRunTimeWithString:aString];
}

-(NSString*)getModelCount{
    NSArray *modelList = [_dataProvider getModelListWithType:@"1" andBrand:@"12"];
    NSString *aString = [NSString stringWithFormat:@"remoteCount : %lu", modelList.count];
    return [self addRunTimeWithString:aString];
}

-(NSString*)getCreateRemote{
    _remoter = [_dataProvider createRemoterWithType:_typeId withBrand:_brandId andModel:_modelId];
    NSString *aString = [NSString stringWithFormat:@"%@ %@", [_remoter getBrandName], [_remoter getModuleName]];
    return [self addRunTimeWithString:aString];
}

-(NSString*)getAllKey{
    NSString *aString = [NSString stringWithFormat:@"keyCount : %ld",[_remoter getAllKeys].count];
    return [self addRunTimeWithString:aString];
}

-(NSString*)getBigCombine{
    _remoterBig = [_dataProvider createBigCombineRemoterWithType:_typeId withBrand:_brandId];
    NSString *aString = [NSString stringWithFormat:@"remoter's key : %ld",[_remoterBig getAllKeys].count];
    return [self addRunTimeWithString:aString];
}

-(NSString*)getSmartKeyList{
    NSArray* keyList = [_dataProvider getSmartPickerKeyListWithType:@"1"];
    NSString *aString = [NSString stringWithFormat:@"smartKeys : %ld", keyList.count];
    return [self addRunTimeWithString:aString];
}

-(NSString*)getSmartKey{
    _picker = [_dataProvider createTVSmartPickerWithType:_typeId withBrand:_brandId];
    NSString *aString = [NSString stringWithFormat:@"%@", [_picker begin]];
    return [self addRunTimeWithString:aString];
}

#pragma mark - MainViewDelegate
- (void)didChangeServer
{
    [self clearData];
    if ([self.navigationItem.title isEqualToString:@"TW"]) {
        self.navigationItem.title = @"CN";
        [BomeansIRKit setUseChineseServer:YES]; //預設值:NO=tw, YES=cn
        [_dataProvider setLanguage:@"cn"];
    }
    else {
        self.navigationItem.title = @"TW";
        [BomeansIRKit setUseChineseServer:NO]; //預設值:NO=tw, YES=cn
        [_dataProvider setLanguage:@"tw"];
    }
}

- (void)didCheckAll
{
    if ([self.navigationItem.title isEqualToString:@"TW"]) {
        _typeId = @"1";
        _brandId = @"13";
        _modelId = @"LCD09";
    }else{
        _typeId = @"1";
        _brandId = @"8";
        _modelId = @"Hisense_0010";
    }
    
    dispatch_queue_t myQueue = dispatch_queue_create("com.bomeans.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(myQueue, ^{
        dispatch_async(mainQueue, ^{
            [self clearData];
        });
    });
    
    _startTime = CFAbsoluteTimeGetCurrent();
    
    dispatch_async(myQueue, ^{
        NSString *typeString = [self getTypeCount];
        dispatch_async(mainQueue, ^{
            //typeCount
            //[_resultArray[0] replaceObjectAtIndex:0 withObject:typeString];
            [_resultArray[0] removeAllObjects];
            [_resultArray[0] addObject:typeString];
            [_mainView getDataSoruce:_resultArray];
        });
    });
    
    dispatch_async(myQueue, ^{
        NSString *brandString = [self getBrandCount];
        dispatch_async(mainQueue, ^{
            //brandCount
            //[_resultArray replaceObjectAtIndex:1 withObject:brandString];
            [_resultArray[1] removeAllObjects];
            [_resultArray[1] addObject:brandString];
            [_mainView getDataSoruce:_resultArray];
        });
    });
    
    dispatch_async(myQueue, ^{
        NSString *modelString = [self getModelCount];
        dispatch_async(mainQueue, ^{
            //型號清單
            //[_resultArray replaceObjectAtIndex:2 withObject:modelString];
            [_resultArray[2] removeAllObjects];
            [_resultArray[2] addObject:modelString];
            [_mainView getDataSoruce:_resultArray];
        });
    });
    
    dispatch_async(myQueue, ^{
        NSString *createRemoteString = [self getCreateRemote];
        dispatch_async(mainQueue, ^{
            //創建遙控器
            //[_resultArray replaceObjectAtIndex:3 withObject:createRemoteString];
            [_resultArray[3] removeAllObjects];
            [_resultArray[3] addObject:createRemoteString];
            [_mainView getDataSoruce:_resultArray];
        });
        NSString *allKeyString = [self getAllKey];
        dispatch_async(mainQueue, ^{
            //按鍵清單
            //[_resultArray replaceObjectAtIndex:6 withObject:allKeyString];
            [_resultArray[6] removeAllObjects];
            [_resultArray[6] addObject:allKeyString];
            [_mainView getDataSoruce:_resultArray];
        });
    });
    
    dispatch_async(myQueue, ^{
        //創建大萬能
        NSString *bigCombine = [self getBigCombine];
        dispatch_async(mainQueue, ^{
            //[_resultArray replaceObjectAtIndex:4 withObject:bigCombine];
            [_resultArray[4] removeAllObjects];
            [_resultArray[4] addObject:bigCombine];
            [_mainView getDataSoruce:_resultArray];
        });
    });
    
    dispatch_async(myQueue, ^{
        //智慧選碼按鍵
        NSString *smartKeyList = [self getSmartKeyList];
        dispatch_async(mainQueue, ^{
            //[_resultArray replaceObjectAtIndex:5 withObject:smartKeyList];
            [_resultArray[5] removeAllObjects];
            [_resultArray[5] addObject:smartKeyList];
            [_mainView getDataSoruce:_resultArray];
        });
    });
    
    dispatch_async(myQueue, ^{
        //智慧選碼
        NSString *smartKey = [self getSmartKey];
        dispatch_async(mainQueue, ^{
            //[_resultArray replaceObjectAtIndex:7 withObject:smartKey];
            [_resultArray[7] removeAllObjects];
            [_resultArray[7] addObject:smartKey];
            [_mainView getDataSoruce:_resultArray];
        });
    });
}

@end
