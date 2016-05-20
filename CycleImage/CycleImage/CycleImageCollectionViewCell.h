//
//  CycleImageCollectionViewCell.h
//  CycleImage
//
//  Created by 吕浩轩 on 16/5/20.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImage *placeholderImage;//图像占位符
@property (nonatomic, strong) id imagePath;

@end
