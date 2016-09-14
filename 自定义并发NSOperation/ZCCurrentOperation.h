//
//  ZCCurrentOperation.h
//  自定义非并发NSOPeration
//
//  Created by MrZhao on 16/9/13.
//  Copyright © 2016年 MrZhao. All rights reserved.
//
/*
 *自定义并发的NSOperation需要以下步骤：
 1.start方法：该方法必须实现，
 2.main:该方法可选，如果你在start方法中定义了你的任务，则这个方法就可以不实现，但通常为了代码逻辑清晰，通常会在该方法中定义自己的任务
 3.isExecuting  isFinished 主要作用是在线程状态改变时，产生适当的KVO通知
 4.isConcurrent :必须覆盖并返回YES;
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ZCCurrentOperation;
@protocol currentOperationDelegate <NSObject>
-(void)downLoadOperation:(ZCCurrentOperation*)operation didFishedDownLoad:(UIImage *)image;
@end

@interface ZCCurrentOperation : NSOperation {
    BOOL executing;
    BOOL finished;
}

@property (nonatomic, copy)NSString *urlStr;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, weak)id<currentOperationDelegate>delegate;
@end
