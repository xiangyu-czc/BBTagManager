//
//  BBTagHeaderReusableView.h
//  标签管理
//
//  Created by 项羽 on 17/1/5.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CollectionHeaderViewStatusDefault,
    CollectionHeaderViewStatusEditing
}CollectionHeaderViewStatus;

typedef void(^EditBtnBlock)(UIButton *eBtn);

@interface BBTagHeaderReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic,copy)EditBtnBlock editBtnClickHandler;
@property (nonatomic,assign)CollectionHeaderViewStatus editStatus;


@end
