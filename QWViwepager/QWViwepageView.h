//
//  QWViwepageView.h
//  QWViwepager
//
//  Created by 涂清文 on 16/5/17.
//  Copyright © 2016年 涂清文. All rights reserved.
//

/**
 支持: 
     1.  载入图片数组可添加 UIImage对象,网络图片URL字符串,本地图片名,自动识别,并添加
     2.  网络图片自动缓存到磁盘
     3.  点击图片响应
     4.  支持追加图片
     5.  用户交互时停止滚动,完成后恢复滚动
     6.  可以设置滚动方法
     7.  frame , 约束 自由设置和添加
     8.  是否需要动画,以及动画时间设置
 */

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , QWScrollDirection) {
    QWScrollDirectionRight = 0,
    QWScrollDirectionLeft ,
};
typedef NS_ENUM(NSInteger ,QWPageControlDirection) {
    QWPageControlDirectionCenter ,
    QWPageControlDirectionLeft ,
    QWPageControlDirectionRight,
};

@protocol QWViwepageViewDelegate
@optional
/**
 *  图片被点击时调用
 *
 *  @param pictureImage 被点击的图片
 *  @param index        被点击图片的下标
 */
- (void)viwepageViewPicture:(UIImage*)pictureImage Index:(NSInteger)index;
@end


@interface QWViwepageView : UIScrollView
/** 是否显示PageControl 默认不显示 pageControl */
@property (nonatomic,assign,getter=isShowPageControl ) BOOL showPageControl;
/** 要显示的PageControl */
@property (nonatomic,strong) UIPageControl *pageControl ;
/** 设置page 所在的方位置 默认下居中  */
@property (nonatomic,assign) QWPageControlDirection pageControlDirection;
/** 设置不自动滚动  默认自动滚动*/
@property (nonatomic,assign,getter=isNoAutoScroll) BOOL noAutoScroll ;
/** 设置没有滚动动画 默认有滚动动画 */
@property (nonatomic,assign,getter=isNoScrollAnimation) BOOL NoScrolleAnimation ;
/** 设置滚动的方向 默认向右 */
@property (nonatomic,assign) QWScrollDirection scrollDirection ;
/** 设置Viwepage 代理 */
@property (nonatomic,weak)  id<QWViwepageViewDelegate>  QWViwepageViewDelegate;
/** 切换到下一页后等待时间 默认 1.5 s*/
@property (nonatomic,assign) NSTimeInterval scrollWaitTimeInterval ;
/** 滚动动画持续时间  默认 1.5s*/
@property (nonatomic,assign) NSTimeInterval scrollAnimationDurationTimeInterval ;
/** 用户触摸后的等待时间 默认为5 s */
@property (nonatomic,assign) NSTimeInterval userTouchWaitTime ;
/** 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame ViwepageImageArray:(NSArray*)array;
/** 追加图片 */
- (void)appendImages:(NSArray *)imageArray;
/** 删除指定图片 */
- (void)deleteImages:(NSArray *)delegeImageArray ;
/** 删除图片缓存 */
- (void)clearImageCache;
/** 获取缓存大小 */
- (float)imageDiskCacheSize;
@end
