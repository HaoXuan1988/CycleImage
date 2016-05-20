//
//  CycleImageCollectionViewCell.m
//  CycleImage
//
//  Created by 吕浩轩 on 16/5/20.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "CycleImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CycleImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        self.image.clipsToBounds = YES;
        [self.contentView addSubview:self.image];
    }
    return self;
}

- (void)setImagePath:(id)imagePath {
    
    if ([imagePath isKindOfClass:[NSString class]]) {
        [self.image sd_setImageWithURL:[NSURL URLWithString:[self hx_URLEncodedString:imagePath]] placeholderImage:self.placeholderImage];
    }else if ([imagePath isKindOfClass:[NSURL class]]) {
        [self.image sd_setImageWithURL:imagePath placeholderImage:self.placeholderImage];
    }else if ([imagePath isKindOfClass:[UIImage class]]) {
        [self.image setImage:imagePath];
    }else{
        [self.image setImage:self.placeholderImage];
    }
}

//编码
- (NSString *)hx_URLEncodedString:(NSString *)string
{
    NSString *newString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    if (newString) {
        return newString;
    }
    
    return string;
}

@end
