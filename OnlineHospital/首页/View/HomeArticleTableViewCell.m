//
//  HomeArticleTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeArticleTableViewCell.h"
#define image_w 120
#define image_h 90
#define image_between (bgView.size.height - image_h)/2
@interface HomeArticleTableViewCell()

@end
@implementation HomeArticleTableViewCell

//-(void)setModle:(HomeModel *)modle{
//    _modle = modle;
//    if (_modle) {
//
//        self.titleLabel.text = [NSString stringWithFormat:@"%@",modle.title];
//        self.secondLable.text = [NSString stringWithFormat:@"%@",modle.introduction];
//        [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:modle.imgUrl]];
//        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:modle.headUrl] placeholderImage:[UIImage imageNamed:@"defalt_headImage"]];
//        [self.CountBtn setTitle:[NSString stringWithFormat:@"%@",modle.count] forState:UIControlStateNormal];
//        self.nameLable.text = [NSString stringWithFormat:@"%@",modle.inputMan];
//
//    }
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BG_COLOR;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews{//118
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(12, 0, Screen_W-24, 118);
    bgView.backgroundColor = BG_COLOR_WHITE;
//    bgView.layer.cornerRadius = REDIUS;
    [self.contentView addSubview:bgView];
    
    // 创建头部图片

    self.ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.size.width - image_w - image_between, image_between, image_w, image_h)];
    self.ImgView.backgroundColor = [UIColor redColor];
    self.ImgView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.ImgView sd_setImageWithURL:[NSURL URLWithString:_imagePath] placeholderImage:[UIImage imageNamed:@"timg"]];
    [bgView addSubview:self.ImgView];
    
    // 创建标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(image_between, image_between, bgView.size.width - image_w - (image_between * 3), 50)];
    self.titleLabel.textColor = TEXT_COLOR_MAIN;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
//    self.titleLabel.text = _title;
    [bgView addSubview:self.titleLabel];
    
    // 创建副标题
    self.detailLable = [[UILabel alloc] initWithFrame:CGRectMake(image_between, image_between*2 + 50, bgView.size.width - image_w - (image_between * 3), bgView.size.height - self.titleLabel.size.height - (image_between * 3))];
    self.detailLable.textAlignment = NSTextAlignmentLeft;
    self.detailLable.textColor = TEXT_COLOR_DETAIL;
    self.detailLable.font = [UIFont systemFontOfSize:12];
//    self.detailLable.text = _detail;
    [bgView addSubview:self.detailLable];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
