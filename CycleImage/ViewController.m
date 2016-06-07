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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSArray *imageArray = nil;
//    [self.images reloadData:imageArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.images = [[CycleImage alloc]initWithFrame:CGRectMake(0, 100, 414, 200) placeholderImage:nil];
    
    
    [self.view addSubview:self.images];
    
    
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
