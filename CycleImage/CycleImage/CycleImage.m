//
//  CycleImage.m
//  CycleImage
//
//  Created by 吕浩轩 on 16/5/19.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "CycleImage.h"
#import "CycleImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"

static NSString * const cycleImageIdentifier = @"CycleImageCollectionViewCell";



@interface CycleImage ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/**
 *  海报
 */
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *customLayout;

/**
 *  page
 */
@property (nonatomic, strong) UIPageControl *page;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray *data;

/**
 *  底部图片
 */
@property (nonatomic, strong) UIImageView *bottomView;

@end

@implementation CycleImage

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.placeholderImage = placeholderImage;
        
        if (!_bottomView && _placeholderImage) {
            _bottomView = [[UIImageView alloc]initWithFrame:self.bounds];
            [_bottomView setImage:_placeholderImage];
            [self addSubview:_bottomView];
        }
        
        //默认五秒循环
        _timeInterval = 5.0;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        
        //创建广告位
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _customLayout = [[UICollectionViewFlowLayout alloc]init];
        _customLayout.itemSize = self.frame.size;
        _customLayout.minimumLineSpacing = 0;
        _customLayout.minimumInteritemSpacing = 0;
        _customLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_customLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[CycleImageCollectionViewCell class] forCellWithReuseIdentifier:cycleImageIdentifier];
        
    }
    return _collectionView;
}

- (UIPageControl *)page {
    
    if (!_page) {
        
        _page = [[UIPageControl alloc]init];
        _page.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height - 20);
        _page.bounds = CGRectMake(0, 0, self.frame.size.width, 0);
        _page.pageIndicatorTintColor = [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:0.50];
        _page.currentPageIndicatorTintColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.80];
    }
    return _page;
}

- (NSArray *)data {
    
    if (!_data) {
        
        _data = [NSArray array];
    }
    return _data;
}

#pragma mark - 加载数据,设置占位符图片.
- (void)setImages:(NSArray *)images placeholderImage:(UIImage *)placeholderImage timeInterval:(NSTimeInterval)timeInterval{
    
    /**
     * 移除底部图片
     */
    [_bottomView removeFromSuperview];
    _bottomView = nil;
    
    /**
     *  间隔时间,不想循环就填: 0   (默认 5 秒)
     */
    _timeInterval = timeInterval;
    
    
    /**
     *  进行预加载图片(这个方法有点投机取巧了,不是很好)
     */
    for (id image in images) {
        UIImageView *imageView = [[UIImageView alloc]init];
        if ([image isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[self hx_URLEncodedString:image]]];
        }else if ([image isKindOfClass:[NSURL class]]) {
            [imageView sd_setImageWithURL:image];
        }
    }
    
    /**
     *  先处理占位图
     */
    if (!placeholderImage) {
        _placeholderImage = placeholderImage;
    }
    
    
    /**
     *  再进行接下来的步骤
     */
    self.data = images;
    
    if (self.data.count <= 1) {
        
        _timeInterval = 0;
        
        [self removeTimer];
        
        self.collectionView.scrollEnabled = NO;
        
        [self.page removeFromSuperview];
        
        self.page = nil;
    }else{
        [self addTimer];
        
        self.collectionView.scrollEnabled = YES;
        
        self.page.numberOfPages = self.data.count;
        
        self.page.currentPage = 0;
        
        //创建页码
        [self addSubview:self.page];
    }
    
    
    
    [self.collectionView reloadData];
    
    if (!images || images.count == 0) {
        self.collectionView.allowsSelection = NO;
    }else{
        self.collectionView.allowsSelection = YES;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(50 * _data.count) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
    
}

#pragma mark 刷新数据
- (void)reloadData:(NSArray *)images {
    
    [self setImages:images placeholderImage:self.placeholderImage timeInterval:_timeInterval];
}

#pragma mark - 创建定时器
- (void)addTimer {
    if (_timeInterval <= 0) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark 下一页
- (void)next {
    
    CGFloat offset = self.collectionView.contentOffset.x + self.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

#pragma mark 删除定时器
- (void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark 当拖拽时,删除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

#pragma mark 当结束拖拽时,再次创建定时器
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self addTimer];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    /**
     *  这里将数据放大,实现无限循环(看上去至少是无限的)
     */
    return self.data.count * 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CycleImageCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cycleImageIdentifier forIndexPath:indexPath];
    
    cell.placeholderImage = self.placeholderImage;
    cell.imagePath = self.data[indexPath.item % self.data.count];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     *  取出当前可见单元格
     */
    NSIndexPath *visiablePath = [[collectionView indexPathsForVisibleItems] firstObject];
    if (visiablePath.item == 90) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }else if (visiablePath.item == 10) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    self.page.currentPage = visiablePath.item % self.data.count;
}

#pragma mark 点击 itme 回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self removeTimer];
    if ([self.delegate respondsToSelector:@selector(clickWithItme:)]) {
        [self.delegate clickWithItme:indexPath.item % self.data.count];
    }
    [self addTimer];
}

#pragma mark - 编码
- (NSString *)hx_URLEncodedString:(NSString *)string
{
    NSString *newString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    if (newString) {
        return newString;
    }
    
    return string;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
