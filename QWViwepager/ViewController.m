//
//  ViewController.m
//  QWViwepager
//
//  Created by 涂清文 on 16/5/17.
//  Copyright © 2016年 涂清文. All rights reserved.
//
/**
 使用示例
 */

#import "ViewController.h"
#import "QWViwepageView.h"
#import "Masonry.h"

@interface ViewController ()<QWViwepageViewDelegate>
@property (nonatomic,strong) QWViwepageView *viwepage;
@property (nonatomic,strong) QWViwepageView *viewpage2 ;
@property (nonatomic,strong) QWViwepageView *viewPage3 ;
@property (nonatomic,strong) QWViwepageView *viewpageBottom;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viwepage];
    [self viewpage2];
    [self viewPage3];
    [self viewpageBottom];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viwepageViewPicture:(UIImage *)pictureImage Index:(NSInteger)index{
    NSLog(@"图片被点击了");
}

- (QWViwepageView *)viwepage{
    if (!_viwepage) {
        _viwepage = [[QWViwepageView alloc]initWithFrame:CGRectZero ViwepageImageArray:@[@"1",@"2",@"3",@"4",@"5"]];
        [self.view addSubview:_viwepage];
        _viwepage.frame = CGRectMake(0, 0, 100, 200);
        _viwepage.QWViwepageViewDelegate = self ;
    }
    return _viwepage    ;
}
- (QWViwepageView *)viewpage2{
    if (!_viewpage2) {
        _viewpage2 = [[QWViwepageView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width,44) ViwepageImageArray:@[@"1",@"2",@"3",@"4",@"5"]];
        [self.view addSubview:_viewpage2];
    }
    return  _viewpage2 ;
}
- (QWViwepageView *)viewPage3{
    if (!_viewPage3) {
        _viewPage3 = [[QWViwepageView alloc]initWithFrame:CGRectZero ViwepageImageArray:@[@"1",@"2",@"3",@"4",@"5"]];
        _viewPage3.center = self.view.center ;
        _viewPage3.bounds = CGRectMake(0, 0, 200, 400);
        [self.view addSubview:_viewPage3];
    }
    return _viewPage3;
}
- (QWViwepageView *)viewpageBottom{
    if (!_viewpageBottom) {
        _viewpageBottom = [[QWViwepageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44) ViwepageImageArray:@[@"1",@"2",@"3",@"4",@"5"]];
        [self.view addSubview:_viewpageBottom];
    }
    return _viewpageBottom;
}

@end
