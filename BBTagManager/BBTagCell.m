//
//  BBTagCell.m
//  标签管理
//
//  Created by 项羽 on 17/1/5.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import "BBTagCell.h"

@interface BBTagCell()


@end
@implementation BBTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
   
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.clipsToBounds = NO;
}

-(void)setEditStatus:(CollectionCellViewStatus)editStatus
{
    _editStatus = editStatus;
    switch (_editStatus) {
        case CollectionCellViewStatusDefault:
            self.closeBtn.hidden = YES;
            break;
        case CollectionCellViewStatusEditing:
            self.closeBtn.hidden = NO;
            break;
        default:
            break;
    }
}

-(void)setIsHighlighted:(BOOL)isHighlighted
{
    _isHighlighted = isHighlighted;
    if (_isHighlighted) {
        self.tagTitle.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0f];
        self.tagTitle.font = [UIFont boldSystemFontOfSize:17];
    }else{
        self.tagTitle.textColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0f];
        self.tagTitle.font = [UIFont systemFontOfSize:16];
    }
}






@end
