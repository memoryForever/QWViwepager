# QWViwepager
支持: <br \>
1.  载入图片数组可添加 UIImage对象,网络图片URL字符串,本地图片名,自动识别,并添加<br \>
2.  网络图片自动缓存到磁盘<br \>
3.  点击图片响应<br \>
4.  支持追加图片<br \>
5.  用户交互时停止滚动,完成后恢复滚动<br \>
6.  可以设置滚动方法<br \>
7.  frame , 约束 自由设置和添加<br \>
8.  是否需要动画,以及动画时间设置<br \>
使用示例:<br \>
[QWViwepageView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width,44) ViwepageImageArray:@[@"1",@"2",@"3",@"4",@"5"];<br \>
数组中可以填加: 图片名(NSString), UIImage,URL(NSString) 对象;<br \>
可设置<br \>
/** 是否显示PageControl 默认不显示 pageControl */<br \>
@property (nonatomic,assign,getter=isShowPageControl ) BOOL showPageControl;<br \>
/** 要显示的PageControl */<br \>
@property (nonatomic,strong) UIPageControl *pageControl ;<br \>
/** 设置page 所在的方位置 默认下居中  */<br \>
@property (nonatomic,assign) QWPageControlDirection pageControlDirection;<br \>
/** 设置不自动滚动  默认自动滚动*/<br \>
@property (nonatomic,assign,getter=isNoAutoScroll) BOOL noAutoScroll ;<br \>
/** 设置没有滚动动画 默认有滚动动画 */<br \>
@property (nonatomic,assign,getter=isNoScrollAnimation) BOOL NoScrolleAnimation ;<br \>
/** 设置滚动的方向 默认向右 */<br \>
@property (nonatomic,assign) QWScrollDirection scrollDirection ;<br \>
/** 设置Viwepage 代理 */<br \>
@property (nonatomic,weak)  id<QWViwepageViewDelegate>  QWViwepageViewDelegate;<br \>
/** 切换到下一页后等待时间 默认 1.5 s*/<br \>
@property (nonatomic,assign) NSTimeInterval scrollWaitTimeInterval ;<br \>
/** 滚动动画持续时间  默认 1.5s*/<br \>
@property (nonatomic,assign) NSTimeInterval scrollAnimationDurationTimeInterval ;<br \>
/** 用户触摸后的等待时间 默认为5 s */<br \>
@property (nonatomic,assign) NSTimeInterval userTouchWaitTime ;<br \>
/** 初始化方法 */<br \>
- (instancetype)initWithFrame:(CGRect)frame ViwepageImageArray:(NSArray*)array;<br \>
/** 追加图片 */<br \>
- (void)appendImages:(NSArray *)imageArray;<br \>
/** 删除指定图片 */<br \>
- (void)deleteImages:(NSArray *)delegeImageArray ;<br \>
/** 删除图片缓存 */<br \>
- (void)clearImageCache;<br \>
/** 获取缓存大小 */<br \>
- (float)imageDiskCacheSize;<br \>
<br \>