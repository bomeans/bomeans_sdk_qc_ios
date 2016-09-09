//
//  FGLanguageTool.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/16.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "AppDelegate.h"
#import "FGLanguageTool.h"
//#import "TVMatchViewController.h"

NSString* Loc(NSString* key){
    return [[FGLanguageTool sharedInstance] getStringForKey:key withTable:@"Language"];
}

static FGLanguageTool *sharedModel;

@interface FGLanguageTool()

@property(nonatomic,strong)NSBundle *bundle;
@property(nonatomic,copy)NSString *language;

@end

@implementation FGLanguageTool

+(id)sharedInstance
{
    if (!sharedModel)
    {
        sharedModel = [[FGLanguageTool alloc]init];
    }
    
    return sharedModel;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initLanguage];
    }
    
    return self;
}

-(void)initLanguage
{
    //NSString *tmp = [UserSetting getString:LANGUAGE_SET];
    NSString *tmp = [[NSUserDefaults standardUserDefaults]objectForKey:LANGUAGE_SET];
    NSString *path;
    //預設是英文
    if (!tmp)
    {
        tmp = EN;
        //[UserSetting setStringValue:tmp Key:LANGUAGE_SET];
        [[NSUserDefaults standardUserDefaults] setObject:tmp forKey:LANGUAGE_SET];
    }
    
    self.language = tmp;
    path = [[NSBundle mainBundle]pathForResource:self.language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
    self.languageArray = [[NSArray alloc] initWithObjects:@"English",@"繁體中文",@"簡體中文", nil];
}

-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table
{
    if (self.bundle)
    {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    
    return NSLocalizedStringFromTable(key, table, @"");
}

-(void)changeNowLanguage:(int) newLanguageNum
{
    NSString *tmp;
    switch (newLanguageNum) {
        case 1:
            tmp = CNT;
            break;
        case 2:
            tmp = CNS;
            break;
        default:
            tmp = EN;
            break;
    }
    
    if (![self.language isEqualToString:tmp]) {
        [self setNewLanguage:tmp];
    }
    
}

-(void)setNewLanguage:(NSString *)language
{
    if ([language isEqualToString:self.language])
    {
        return;
    }
    
    if ([language isEqualToString:EN] || [language isEqualToString:CNT] || [language isEqualToString:CNS])
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    
    self.language = language;
    [[NSUserDefaults standardUserDefaults]setObject:language forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self resetRootViewController];
}

//重新设置
-(void)resetRootViewController
{
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = [storyBoard instantiateViewControllerWithIdentifier:@"mainNav"];
    UINavigationController *classNav = [storyBoard instantiateViewControllerWithIdentifier:@"classNav"];
    UINavigationController *settingNav = [storyBoard instantiateViewControllerWithIdentifier:@"settingNav"];
    UITabBarController *tabVC = (UITabBarController*)appDelegate.window.rootViewController;
    
    tabVC.viewControllers = @[mainNav,classNav,settingNav];
}

@end
