//
//  CycleImage.h
//  CycleImage
//
//  Created by 吕浩轩 on 16/5/19.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleImageDelegate <NSObject>

/**
 *  点击事件回调
 *
 *  @param itme 你懂得...
 */
- (void)clickWithItme:(NSInteger)itme;

@end

@interface CycleImage : UIView

@property (nonatomic, weak) id<CycleImageDelegate> delegate;

/**
 *  加载数据,设置占位符图片
 *
 *  @param images           可以是 URLString 或 NSURL 或 UIImage
 *  @param placeholderImage 占位符图片
 *  @param timeInterval     间隔时间,不想循环就填: -1  (默认 5 秒)
 */
- (void)setImages:(NSArray *)images placeholderImage:(UIImage *)placeholderImage timeInterval:(NSTimeInterval)timeInterval;

/**
 *  刷新数据
 *
 *  @param images 新数据源
 */
- (void)reloadData:(NSArray *)images;

/**
 *  添加定时器
 */
- (void)addTimer;

/**
 *  移除定时器
 */
- (void)removeTimer;

@end
