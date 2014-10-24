//
//  QQDockItem.m
//  01-QQ
//
//  Created by apple on 13-12-13.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "ATDockItem.h"

#define kImageScale 0.6

@implementation ATDockItem

#pragma mark init方法内部默认会调用initWithFrame:
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 里面的图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 里面的文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

#pragma mark 当按钮达到高亮状态的时候会调用，并且默认会在这个方法中进行高亮处理
- (void)setHighlighted:(BOOL)highlighted { }

#pragma mark 设置内部imageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imgW = contentRect.size.width;
    CGFloat imgH = contentRect.size.height * kImageScale;
    return CGRectMake(0, 0, imgW, imgH);
}

#pragma mark 设置内部titleLabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width;
    CGFloat titleY = contentRect.size.height * kImageScale;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}
@end