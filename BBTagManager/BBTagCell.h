//
//  BBTagCell.h
//  标签管理
//
//  Created by 项羽 on 17/1/5.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CollectionCellViewStatusDefault,
    CollectionCellViewStatusEditing
}CollectionCellViewStatus;

@interface BBTagCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagTitle;
@property (nonatomic,assign)CollectionCellViewStatus editStatus;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic,assign)BOOL isHighlighted;//文字是否高亮


@end
