//
//  ViewController.m
//  CycleImage
//
//  Created by 吕浩轩 on 16/5/19.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "ViewController.h"
#import "CycleImage.h"

//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------

@interface ViewController ()<CycleImageDelegate>

@property (nonatomic, strong) CycleImage *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    /**
     *  这五张图片很大很大
     */
    NSArray *imageArray = @[@"http://img1.3lian.com/2015/w7/98/d/22.jpg",@"http://pic9.nipic.com/20100904/4845745_195609329636_2.jpg", @"http://pic1.nipic.com/2008-12-09/200812910493588_2.jpg", @"http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg", @"http://pic28.nipic.com/20130424/3822951_133339307000_2.jpg"];
    
    self.images = [[CycleImage alloc]initWithFrame:CGRectMake(0, 100, 414, 200)];
    self.images.delegate = self;
    [self.images setImages:imageArray placeholderImage:nil timeInterval:10];//更详细的过程请点进去
    [self.view addSubview:self.images];
    
    /**
     *  刷新数据
     */
    [self.images reloadData:imageArray];
        
}

#pragma mark CycleImageDelegate
- (void)clickWithItme:(NSInteger)itme {
    
    NSLog(@"点击: %ld",itme);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
