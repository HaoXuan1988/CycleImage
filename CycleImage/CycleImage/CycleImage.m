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
static NSTimeInterval _timeInterval = 5.0;


@interface CycleImage ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

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
 *  图像占位符
 */
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation CycleImage

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        /**
         
         创建广告位
         
         */
        self.customLayout = [[UICollectionViewFlowLayout alloc]init];
        self.customLayout.itemSize = frame.size;
        self.customLayout.minimumLineSpacing = 0;
        self.customLayout.minimumInteritemSpacing = 0;
        self.customLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.customLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[CycleImageCollectionViewCell class] forCellWithReuseIdentifier:cycleImageIdentifier];
        [self addSubview:self.collectionView];
        
        /**
         
         创建页码
         
         */
        self.page = [[UIPageControl alloc]init];
        self.page.center = CGPointMake(frame.size.width * 0.5, frame.size.height - 20);
        self.page.bounds = CGRectMake(0, 0, frame.size.width, 0);
        self.page.pageIndicatorTintColor = [UIColor grayColor];
        self.page.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:self.page];
        
        /**
         
         创建定时器
         
         */
        [self addTimer];
    }
    return self;
}

#pragma mark - 加载数据,设置占位符图片.
- (void)setImages:(NSArray *)images placeholderImage:(UIImage *)placeholderImage timeInterval:(NSTimeInterval)timeInterval{
    
    /**
     *  间隔时间,不想循环就填: -1  (默认 5 秒)
     */
    if (timeInterval != _timeInterval && timeInterval >= 0) {
        _timeInterval = timeInterval;
        [self removeTimer];
        [self addTimer];
    }
    
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
        self.placeholderImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"hx_photo_default" ofType:@"png"]];
    }else{
        self.placeholderImage = placeholderImage;
    }
    
    /**
     *  再进行接下来的步骤
     */
    self.data = [images copy];
    
    self.page.numberOfPages = self.data.count;
    
    self.page.currentPage = 50 % self.data.count;
    
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
}

#pragma mark 刷新数据
- (void)reloadData:(NSArray *)images {
    
    [self setImages:images placeholderImage:self.placeholderImage timeInterval:_timeInterval];
}

#pragma mark - 创建定时器
- (void)addTimer {
    
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
    
    [self.delegate clickWithItme:indexPath.item % self.data.count];
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
