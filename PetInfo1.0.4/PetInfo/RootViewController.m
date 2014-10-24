//
//  RootViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-19.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "RootViewController.h"
#import "Uifactory.h"
#import "FileUrl.h"
#import "ThemeManager.h"
#import "SpecialNightViewController.h"
#import "ContentView.h"
#import "SubscribeView.h"
@interface RootViewController (){
    BOOL _enable;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"岳麓地税";
    }
    return self;
}
//初始化按钮
-(NSArray *)_initButton {
    
    //栏目数组
    NSMutableArray *nameArrays = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:show_column]];
    //    用于存放按钮
    NSMutableArray *buttonArrays = [[NSMutableArray alloc]init];
    
    //    用于存放tableview
    NSMutableArray *tableArrays = [[NSMutableArray alloc]init];
    for (int i =0; i<nameArrays.count; i++) {
        int columnId = [[nameArrays[i] objectForKey:@"columnId"] intValue];
        UIButton *button = [Uifactory createButton:[nameArrays[i] objectForKey:@"name"]];
        button.frame = CGRectMake(10 + 70*i, 0, 60, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.tag = 1000+ i;
        [buttonArrays addObject:button];
        
        
        NewsNightModelTableView *newsTableView = [[NewsNightModelTableView alloc]initwithColumnID:columnId];
        newsTableView.frame = CGRectMake(340 *i, 0, ScreenWidth, App_Frame_Height -49-40-44);
        newsTableView.eventDelegate = self;
        newsTableView.changeDelegate = self;
        newsTableView.type = 0;
        NSString *key = [NSString stringWithFormat:@"columnid=%d",columnId];

//        获取上次更新时间
        NSDate *date = [[[NSUserDefaults standardUserDefaults] objectForKey:key] objectForKey:@"lastDate"];
        newsTableView.lastDate = date;
        if (date !=nil) {
            //        设置数据
            [self getData:newsTableView cache:1];
            [self getImageData:newsTableView cache:1];
        }
        [tableArrays addObject:newsTableView];
        
    }
    //    用于存放按钮和tableview
    NSArray *arrays = @[buttonArrays,tableArrays];
    return arrays;
}


#pragma mark UIScrollViewEventDelegate
-(void)addButtonAction{
    ColumnTabelViewController *columnVC = [[ColumnTabelViewController alloc]initWithType:0];
    columnVC.eventDelegate = self;
    _po(self.navigationController);
    [self.navigationController pushViewController:columnVC animated:YES];
}

-(void)autoRefreshData:(NewsNightModelTableView *)tableView{
    if ([self getConnectionAlert]) {
      [self getData:tableView cache:0];
       [self getImageData:tableView cache:0];
    }else{
    }
}

#pragma mark
#pragma mark UI
- (void)viewDidLoad
{
    
    [super viewDidLoad];
//    初始化设置当前为未加载状态
    self.isLoading = NO;
//    初始化滚动视图，冰添加
    _sc = [[BaseScrollView alloc]initwithButtons:[self _initButton] WithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-49-40)];
    _sc.eventDelegate = self;
    [self.view addSubview:_sc];

//    获取当前时间
    NSDate *nowDate = [NSDate date];

//    如果第一个栏目时间为空或者距离上次刷新大于10分钟 则自动刷新
    NewsNightModelTableView *table  = (NewsNightModelTableView *) VIEWWITHTAG( VIEWWITHTAG(_sc, 10001), 1300);
//    获取上次时间+10分钟
    NSDate *lastDate = [table.lastDate dateByAddingTimeInterval: loaddata_date];
    if(lastDate ==nil){
        [table autoRefreshData];
        [self getData:table cache:0];
        [self getImageData:table cache:0];
    }else{
        if (nowDate ==[lastDate laterDate:nowDate]) {
            [table autoRefreshData];
            [self getData:table cache:0];
          [self getImageData:table cache:0];
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //    开启左滑、右滑菜单
  
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //    禁用左滑、右滑菜单
   
    
}

#pragma mark UIScrollViewEventDelegate
-(void)ImageViewDidSelected:(NSInteger)index andData:(NSArray *)imageData{
  
  ContentView *con= [[ContentView alloc]init];
  con.articleId =[imageData[index] objectForKey:@"RESOURCEID"];
  [self.navigationController pushViewController:con animated:YES];
  [con release];

}

-(ColumnModel *)addisselected :(ColumnModel *)model {
    NSString *newsId = model.RESOURCEID;
    FMResultSet *rs =[self.db executeQuery:@"select * from columnData where newsId = ?",newsId];
    while (rs.next) {
        model.isselected = YES;
        return model;
    }
    return model;
}
-(void)getImageData :(NewsNightModelTableView *)tableView cache:(int)cache
{
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  [self getConnectionAlert];
  int columnID=tableView.columnID;
   NSString *Url = [NSString stringWithFormat:@"ResourceService/getCommonThemeResourceInfoList/%d/%@",columnID,userId];
  if (cache ==0)
{
      [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
        tableView.imageData = [result objectForKey:@"data"];
        [tableView reloadData];
      } andErrorBlock:^(NSError *error) {
      }];
  }
  else
  {
    //        只读本地
    [DataService nocacheWithURL:Url andparams:nil completeBlock:^(id result) {
      tableView.imageData = [result objectForKey:@"data"];
      [tableView reloadData];
    } andErrorBlock:^(NSError *error) {
    }];
  }

}
#pragma mark UItableviewEventDelegate
//cache 0:正常缓存 1代表只读本地
-(void)getData :(NewsNightModelTableView *)tableView cache:(int)cache{
    [self getConnectionAlert];
    int columnID=tableView.columnID;
    tableView.curPage=1;
  NSString *Url = [NSString stringWithFormat:@"ResourceService/getResourceInfoList/%d/%d/%d",columnID,tableView.curPage,KPageSize];
//    正常访问网络
    if (cache ==0) {
      
        [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
          
            tableView.lastDate = [NSDate date];
            tableView.isMore = true;
            NSArray *array =  [result objectForKey:@"data"];
            if (array.count ==0) {
                [tableView doneLoadingTableViewData];
                return ;
            }
          NSArray * pagearray =[result objectForKey:@"page"];
          tableView.maxPage = [[[pagearray firstObject] objectForKey:@"PAGECOUNT"] intValue];
          NSMutableArray *listData = [[NSMutableArray alloc]init];
            for (NSDictionary *dic  in array) {
                ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
                model = [self addisselected:model];
                [listData addObject:model];
            }

            tableView.data =listData;
            [tableView reloadData];
            [tableView doneLoadingTableViewData];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSDictionary *columnDIC = @{@"lastDate":tableView.lastDate};
            [userDefault setValue:columnDIC forKey:[NSString stringWithFormat:@"columnid=%d",tableView.columnID]];
            [userDefault synchronize];

        } andErrorBlock:^(NSError *error) {
            [tableView doneLoadingTableViewData];
        }];
    }else{
//        只读本地
        [DataService nocacheWithURL:Url andparams:nil completeBlock:^(id result) {
            tableView.isMore = true;
            NSArray *array =  [result objectForKey:@"data"];
            if (array.count ==0) {
                [tableView doneLoadingTableViewData];
                return ;
            }
           NSArray * pagearray =[result objectForKey:@"page"];
           tableView.maxPage = [[[pagearray firstObject] objectForKey:@"PAGECOUNT"] intValue];
            NSMutableArray *listData = [[NSMutableArray alloc]init];
            for (NSDictionary *dic  in array) {
                ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
                model = [self addisselected:model];
                [listData addObject:model];
            }
            tableView.data =listData;
            [tableView reloadData];
            [tableView doneLoadingTableViewData];
//            设置tableview的最后更新时间
            
            NSDate *date = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"columnid=%d",tableView.columnID]] objectForKey:@"lastDate"];
            if (date ==nil) {
                
            }else{
                tableView.lastDate =date;

            }
            
        } andErrorBlock:^(NSError *error) {
            [tableView doneLoadingTableViewData];
        }];
    }
}

//上拉刷新
-(void)pullDown:(NewsNightModelTableView *)tableView{
    if (![self getConnectionAlert]) {
        [tableView doneLoadingTableViewData];

        return;
    }
    [self getData:tableView cache:0];
    [self getImageData:tableView cache:0];
    
}
//下拉加载
-(void)pullUp:(NewsNightModelTableView *)tableView{
    if (_isLoading ) {
        return;
    }
    
    if (![self getConnectionAlert]) {
        [tableView doneLoadingTableViewData];

        return;
    }

  int columnID=tableView.columnID;
  tableView.curPage++;
  NSString *Url = [NSString stringWithFormat:@"ResourceService/getResourceInfoList/%d/%d/%d",columnID,tableView.curPage,KPageSize];

    [self getConnectionAlert];
    self.isLoading = YES;
    [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
       NSArray *array =  [result objectForKey:@"data"];
      if (array.count ==0) {
        [tableView doneLoadingTableViewData];
        return ;
      }
      NSArray * pagearray =[result objectForKey:@"page"];
      tableView.maxPage = [[[pagearray firstObject] objectForKey:@"PAGECOUNT"] intValue];
      
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        for (NSDictionary *dic  in array) {
            ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
            model = [self addisselected:model];
            [listData addObject:model];
        }
        [tableView doneLoadingTableViewData];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:tableView.data];
        [arr addObjectsFromArray:listData];
        tableView.data  = arr;
        [tableView reloadData];
        self.isLoading = NO;
    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
        self.isLoading = NO;

    }];
    
    
    
}
-(void)tableView:(NewsNightModelTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.imageData.count >0&&indexPath.section==0) {
        
    }else{
      ColumnModel *model =tableView.data[indexPath.row];
      ContentView *con= [[ContentView alloc]init];
      con.articleId =model.RESOURCEID;
      [self.navigationController pushViewController:con animated:YES];
      [con release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




#pragma mark columnchangeDelegate
-(void)columnChanged:(NSArray *)array{
    _sc.buttonsNameArray = [self _initButton];
}
#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    RELEASE_SAFELY(_sc);
    [super dealloc];
}

@end
