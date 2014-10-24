//
//  MainViewController.m
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "MainViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "BaseNavViewController.h"
#import "ThemeManager.h"
#import "FileUrl.h"
#import "FMDB/src/FMDatabase.h"


#import "ManageListView.h"
#import "SubscribeView.h"
#import "NoticeView1.h"
#import "InstallView1.h"
#import "ATDock.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.title = @"岳麓地税";
    }
    return self;
}


//添加rootview
-(void)_initViewController{
  _root = [[RootViewController alloc]init];
  [self addChildViewController:_root];

  ManageListView *manage = [[ManageListView alloc] init];
   NoticeView1 *noice = [[NoticeView1 alloc] init];
   InstallView1 *install = [[InstallView1 alloc] init];
  [self addChildViewController:manage];
  [self addChildViewController:noice];
  [self addChildViewController:install];
  ATDock *dock = [[ATDock alloc] init];
  CGFloat dockH = dockHH;
  CGFloat dockY = self.view.frame.size.height - dockHH;
  CGFloat dockW = self.view.frame.size.width;
  CGFloat dockX = 0;
  dock.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  dock.frame = CGRectMake(dockX, dockY, dockW, dockH);
  dock.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_bg.png"]];
  dock.delegate = self;

  _dock = dock;
  [_dock addDockItem:@"新闻" icon:@"dy.png" selectedIcon:@"dy_press.png"];
  [_dock addDockItem:@"互动" icon:@"hd.png" selectedIcon:@"hd_press.png"];
  [_dock addDockItem:@"公告" icon:@"gg.png" selectedIcon:@"gg_press.png"];
  [_dock addDockItem:@"通讯录" icon:@"gl.png" selectedIcon:@"gl_press.png"];
  
  [self.view addSubview:dock];
  

}
//进入应用后大图

-(void)dingyue{
  SubscribeView *sub  = [[SubscribeView alloc]init];
   sub.eventDelegate = self;
  [self.navigationController pushViewController:sub animated:YES];
  [sub release];
  
}
-(void)_initDB{
    //初始化数据库
    FMDatabase *db = [FileUrl getDB];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
//    栏目表
//    栏目id   栏目名称  是否有主图(0隐藏1显示)  是否显示(0隐藏1显示)  后台隐藏(0隐藏1显示)  订阅（takepart）


//    收藏表
//    titleid  标题  type类型
    [db executeUpdate:@"CREATE TABLE collectionList (newsId TEXT PRIMARY KEY, title TEXT, type INTEGER)"];
//   数据源列表
    
//    1.columndata表
//    titleid type类型  newsAbstract描述 title标题 img主图  isselected是否选过DEFAULT 0
    [db executeUpdate:@"CREATE TABLE columnData (newsId TEXT PRIMARY KEY, title TEXT, newsAbstract  TEXT, type INTEGER,img TEXT, isselected INTEGER DEFAULT 0)"];
    FMDatabase *dbs = [FileUrl getDB];
    [db open];
    [dbs close];
}
-(void)_initplist{
    
    //    创建图片缓存文件夹
    NSFileManager *manager=  [NSFileManager defaultManager];
    NSString *createFile = [FileUrl getCacheImageURL];
    [manager createDirectoryAtPath:createFile withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *plistPath1 = [FileUrl getDocumentsFile];
    //写入初始化数据文件
    NSDictionary *dica = [[NSDictionary alloc]init];

//    搜藏列表
    NSString *collectionName = [plistPath1 stringByAppendingPathComponent:kCollection_file_name];
    [dica writeToFile:collectionName atomically:YES];
    
    //搜索历史文件
    NSString *searchPath = [plistPath1 stringByAppendingPathComponent:kSearchHistory_file_name];
    NSArray *searchArray = [[NSArray alloc]init];
    [searchArray writeToFile:searchPath atomically:YES];
    
    //设置夜间模式
    [_userDefaults setBool:YES forKey:kisNightModel];
    [_userDefaults setInteger:1 forKey:kpageCount];
    //初始化菜单 写到userdefaults里


    
}
-(void)_updataDB{
//    创建图片缓存文件夹
    NSFileManager *manager=  [NSFileManager defaultManager];
    NSString *createFile = [FileUrl getCacheImageURL];
    [manager createDirectoryAtPath:createFile withIntermediateDirectories:YES attributes:nil error:nil];
}
#pragma mark UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    _userDefaults=[NSUserDefaults standardUserDefaults];
  
    NSString *curversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *oldVersion = [_userDefaults stringForKey:kbundleVersion];
//    
    if (![oldVersion isEqualToString:curversion]) {
//        第一次进入。 直接初始化  出引导图
      [_userDefaults setObject:curversion forKey:kbundleVersion];
      [_userDefaults synchronize];

        if (oldVersion == nil) {
            [self _initDB];
            [self _initplist];
            [_userDefaults synchronize];
            }
        else{//更新内容
            [self _updataDB];
        }
        
    }
 // [self getColumnList];
  [self _initViewController];

    bool  nightModel=[_userDefaults boolForKey:kisNightModel];
    if (nightModel) {
        [ThemeManager shareInstance].nigthModelName =@"day";
    }else{
        [ThemeManager shareInstance].nigthModelName =@"night";
    }
}

- (void)dock:(ATDock *)dock didSelectedFromIndex:(int)from toIndex:(int)to
{
  // 1.移除旧控制器的view
  UIViewController *oldVC = self.childViewControllers[from];
  [oldVC.view removeFromSuperview];
  
  // 2.添加新控制器的view
  UIViewController *newVC = self.childViewControllers[to];
  CGFloat viewW = self.view.frame.size.width;
  CGFloat viewH = self.view.frame.size.height - _dock.frame.size.height;
  newVC.view.frame = CGRectMake(0, 0, viewW, viewH);
  [self.view addSubview:newVC.view];
  
  [self.view bringSubviewToFront:_dock];

}
-(void)columnChanged:(NSArray *)array{
  [_root columnChanged:array];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewDidUnload{
 [super viewDidUnload];
}
-(void)dealloc{
  [_dock release];
  [super dealloc];
}
@end
