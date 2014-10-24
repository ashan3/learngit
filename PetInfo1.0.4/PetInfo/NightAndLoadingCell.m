//
//  NightAndLoadingCell.m
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "NightAndLoadingCell.h"
#import "Uifactory.h"
#import "ColumnModel.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"
#import "FMDatabase.h"
#import "FileUrl.h"

@implementation NightAndLoadingCell



-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BrownModelChangeNotification) name:kBrownModelChangeNofication object:nil];
        
    }
    return self;
}
- (id)initWithshoWImage:(BOOL)showImage type:(int)type 
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeDetailCell"];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BrownModelChangeNotification) name:kBrownModelChangeNofication object:nil];
        self.showImage = showImage;
        self.type = type;
        self.isselected = NO;
        [self _initView];
    }
    return self;
}
#define mark Notification
#pragma mark - NSNotification actions
//打开模式
-(void)BrownModelChangeNotification{
    [self setBrown];
//    [self setNeedsLayout];
}
//设置打开模式
-(void)setBrown{
    
    if (_showImage) {
        int brose = [[ThemeManager shareInstance]getBroseModel];
        if (brose == 0) {//智能模式
            if ([[DataCenter  getConnectionAvailable] isEqualToString:@"wifi"]) {
                [self addImage];
            }else{
                [self hiddenImage];
            }
        }else if(brose ==1){//无图
            [self hiddenImage];
        }else{//全部图
            [self addImage];
        }
    }else{
        [self hiddenImage];
    }
}
-(void)addImage{
    _titleLabel.frame = CGRectMake(100, 10, 320-100-20, 45);
    _contentLabel.frame =CGRectMake(100, 50, 320-100-20, 30);
    [_imageView setHidden:NO];
}
-(void)hiddenImage{
    _titleLabel.frame = CGRectMake(10, 10, 300, 45);
    _contentLabel.frame = CGRectMake(10, 50, 300, 30);
    [_imageView setHidden:YES];

}


-(void)_initCell {
    
    //    标题

    _titleLabel = [Uifactory createLabel:ktext];
    _titleLabel.frame = CGRectMake(100, 10, 320-100-20, 45);
    _titleLabel.numberOfLines = 0;
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.contentView addSubview:_titleLabel];
    //     摘要
    _contentLabel = [Uifactory createLabel:kselectText];

    _contentLabel.frame =CGRectMake(100, 50, 320-100-20, 30);
    _contentLabel.numberOfLines = 2;
    [_contentLabel setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_contentLabel];
    //图片视图
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 60)];
    _imageView.backgroundColor = CLEARCOLOR;
    [self.contentView addSubview:_imageView];
 
    [self setBrown];
  
    _imageTitleLabel = [Uifactory createLabel:ktext];
    _imageTitleLabel.frame = CGRectMake(20, 10, 320-20-50, 20);
    _imageTitleLabel.numberOfLines = 0;
    _imageTitleLabel.hidden = YES;
    [_imageTitleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [self.contentView addSubview:_imageTitleLabel];
}
-(void)_initView {
//    设置布局
    [self _initCell];

}

//layoutSubviews展示数据，子视图布局
-(void)layoutSubviews{
    [super layoutSubviews];

        _titleLabel.hidden=NO;
        _contentLabel.hidden=NO;
        _imageView.hidden = NO;
        _imageTitleLabel.hidden = YES;

        //    判断图片是否显示。确定titlelabel的point
        if (_model.COVERIMAGEURL.length<2) {
            [self hiddenImage];
        }else{
            int brose = [[ThemeManager shareInstance]getBroseModel];
            if (brose ==1) {
                [self hiddenImage];
            }else{
                [self addImage];
                if([[DataCenter getConnectionAvailable] isEqualToString:@"none"]){
                    NSString *filename = [[_model.COVERIMAGEURL componentsSeparatedByString:@"/"] lastObject];
                    NSString *name = [filename componentsSeparatedByString:@"."][0];
                    NSString *path = [[FileUrl getCacheImageURL] stringByAppendingPathComponent:name];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        [_imageView setImage:[[UIImage alloc]initWithData:[NSData dataWithContentsOfFile:path]]];
                    }else{
                        [_imageView setImageWithURL:[NSURL URLWithString:_model.COVERIMAGEURL] placeholderImage:LogoImage];
                    }
                }else{
                    [_imageView setImageWithURL:[NSURL URLWithString:_model.COVERIMAGEURL] placeholderImage:LogoImage];

                }
                
            }
        }
        //    标题
        _titleLabel.text = _model.RESOURCETITLE;
        //    标题自动换行，行数为2则隐藏简介
        [_titleLabel sizeToFit];

          if (_titleLabel.height>50) {
              [_contentLabel setHidden:YES];
          }else{
          [_contentLabel setHidden:NO];
            
          }
         _contentLabel.text = _model.RESOURCEPRC;
        if (_model.isselected==YES) {
            _titleLabel.colorName = kselectText;
        }else{
            _titleLabel.colorName = ktext;
        }

  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    _titleLabel.isSelect = selected;
    [super setSelected:selected animated:animated];
    if (selected) {
//        _isselected=YES;
        _model.isselected = YES;
    }
    

}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
