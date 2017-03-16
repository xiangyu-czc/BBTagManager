//
//  HeaderReusableView.m
//  标签管理
//
//  Created by 项羽 on 17/1/5.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import "BBTagHeaderReusableView.h"

@implementation BBTagHeaderReusableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    self.editBtn.layer.cornerRadius = self.editBtn.bounds.size.height/2;
    self.editBtn.clipsToBounds = YES;
}


-(void)setEditStatus:(CollectionHeaderViewStatus)editStatus
{
    _editStatus = editStatus;
    switch (_editStatus) {
        case CollectionHeaderViewStatusDefault:
        {
            self.statusLabel.text = @"Long press to edit";
            self.editBtn.selected = NO;
        }
            break;
        case CollectionHeaderViewStatusEditing:
        {
            self.statusLabel.text = @"Drag to reorder";
            self.editBtn.selected = YES;
        }
            break;
        default:
            break;
    }
}



- (IBAction)editAction:(UIButton *)sender {
    
    
    if (self.editBtnClickHandler) {
        self.editBtnClickHandler(sender);
    }
    
}




@end
