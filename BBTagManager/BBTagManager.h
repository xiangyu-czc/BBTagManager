//
//  BBTagManager.h
//  标签管理
//
//  Created by 项羽 on 17/1/9.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBTagManager;
@protocol BBTagManagerDelegate <NSObject>

@optional
-(void)BBTagManager:(BBTagManager *)tagMgr finishEditingDataSource:(NSMutableArray *)dataSource;

@end


@interface BBTagManager : UIView

-(instancetype)initWithDataSource:(NSMutableArray<NSArray *> *)datas selectedIndex:(NSInteger)index;
@property (nonatomic,weak)id<BBTagManagerDelegate> delegate;
@property (nonatomic,assign)NSInteger highlightedIndex;


@end
