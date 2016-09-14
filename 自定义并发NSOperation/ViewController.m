//
//  ViewController.m
//  自定义并发NSOperation
//
//  Created by MrZhao on 16/9/13.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ViewController.h"
#import "ZCCurrentOperation.h"
#import "ZCNetWorkingTool.h"
#import "MJExtension.h"
#import "ZCLiveUser.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,currentOperationDelegate>

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSOperationQueue *myQueue;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableDictionary *operations;
@property (nonatomic, strong)NSMutableDictionary *images;

@end

@implementation ViewController
static int page = 1;
#pragma mark life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //发送网络请求获取数据
    
    [self loadData];
}
- (void)viewDidLayoutSubviews {
    
    self.tableView.frame = self.view.bounds;
}
#pragma mark tableViewDataSourece
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (self.dataSource.count >0) {
        
        ZCLiveUser *liveUser = self.dataSource[indexPath.row];
        
        //保证一个url对应一个image对象
        UIImage *image = self.images[liveUser.photo];
        
       if (image) {//缓存中有图片
           
           cell.imageView.image = image;
           
       }
       else {   //  缓存中没有图片，得下载
                 //先设置一张占位图片
                cell.imageView.image = [UIImage imageNamed:@"reflesh1_60x55"];
           
                ZCCurrentOperation *operation = self.operations[liveUser.photo];
           
                   if (operation) {//正在下载
                       
                          //什么都不做
                   }else {
                          //当前没有下载，那就创建操作
                          operation = [[ZCCurrentOperation alloc]init];
                          operation.urlStr = liveUser.photo;
                          operation.indexPath = indexPath;
                          operation.delegate = self;
                          [self.myQueue addOperation:operation];//异步下载
                          self.operations[liveUser.photo] = operation;
                       }
                 }
    }
    
    return cell;
}

- (void)loadData {
    
    NSString *url = [NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=%ld",(unsigned long)page];
    
    ZCNetWorkingTool *tool = [ZCNetWorkingTool shareNetWorking];
    
    [tool GETWithURL:url parameters:nil sucess:^(id reponseBody) {
        
        NSArray *array = reponseBody[@"data"][@"list"];
        //将字典数组转成模型数组
        NSArray *arrayM =[ZCLiveUser objectArrayWithKeyValuesArray:array];
        if (arrayM.count>0) {
            
            [self.dataSource addObjectsFromArray:arrayM];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"数据加载失败");
        
    }];
    
}

- (void)downLoadOperation:(ZCCurrentOperation *)operation didFishedDownLoad:(UIImage *)image{
    
    //1.移除执行完毕的操作
    [self.operations removeObjectForKey:operation.urlStr];
    
    //2.将图片放到缓存中
    self.images[operation.urlStr]=image;
    
    //3.刷新表格（只刷新下载的那一行）
   [self.tableView reloadRowsAtIndexPaths:@[operation.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark懒加载相关
- (NSOperationQueue *)myQueue {
    
    if (!_myQueue) {
        
        self.myQueue = [[NSOperationQueue alloc] init];
        self.myQueue.maxConcurrentOperationCount = 3;
        
    }
    return _myQueue;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableDictionary *)operations {
    if (!_operations) {
        self.operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (NSMutableDictionary *)images {
    if (!_images) {
        self.images = [NSMutableDictionary dictionary];
    }
    return _images;
}
@end
