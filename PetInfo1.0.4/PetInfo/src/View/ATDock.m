//
//  QQDock.m
//  01-QQ
//
//  Created by apple on 13-12-13.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "ATDock.h"
#import "ATDockItem.h"

@interface ATDock()
{
    ATDockItem *_selectedItem;
}
@end

@implementation ATDock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark 添加一个Dock上的小按钮
- (void)addDockItem:(NSString *)title icon:(NSString *)icon selectedIcon:(NSString *)selectedIcon
{
    ATDockItem *item = [ATDockItem buttonWithType:UIButtonTypeCustom];
    // 按钮的图标
    [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
    // 按钮的文字
    [item setTitle:title forState:UIControlStateNormal];
    // 监听按钮的点击 (UIControlEventTouchDown 一按下去就会触发点击事件)
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:item];
    
    // 取出所有的按钮，排列frame
    [self adjustItemFrames];
}

- (void)adjustItemFrames
{
    NSInteger count = self.subviews.count;
    CGFloat itemW = self.frame.size.width / count;
    CGFloat itemH = self.frame.size.height;
    CGFloat itemY = 0;
    for (int i = 0; i<count; i++) {
        CGFloat itemX = i * itemW;
        ATDockItem *child = self.subviews[i];
        child.frame = CGRectMake(itemX, itemY, itemW, itemH);
        // 绑定tag
        child.tag = i;
        
        // 按钮被选中时的背景图片
        NSString *selectedBg = nil;
        if (i == 0) { // 最左边
            selectedBg = @"tabbar_sel_left.png";
            
            // 默认选中最左边的按钮 (相当于 点击了这个按钮)
            [self itemClick:child];
        } else if (i == count - 1) { // 最右边
            selectedBg = @"tabbar_sel_right.png";
        } else { // 中间
            selectedBg = @"tabbar_sel_middle.png";
        }
        [child setBackgroundImage:[UIImage imageNamed:selectedBg] forState:UIControlStateSelected];
    }
}

- (void)itemSelect:(int)index
{
    NSLog(@"%i",index);
}

- (void)itemClick:(ATDockItem *)item
{
    // 0.通知代理
    if ([_delegate respondsToSelector:@selector(dock:didSelectedFromIndex:toIndex:)])
    {
        [_delegate dock:self didSelectedFromIndex:(int)_selectedItem.tag toIndex:(int)item.tag];
    }
    
    // 1.取消选中 当前选中的按钮
    _selectedItem.selected = NO;
    
    // 2.选中 新点击的按钮
    item.selected = YES;
    
    // 3.让 新点击的按钮 成为 当前选中的按钮
    _selectedItem = item;
}

@end
