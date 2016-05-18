//
//  QWViwepageView.m
//  QWViwepager
//
//  Created by 974872635 on 16/5/17.
//  Copyright © 2016年 QQ 974872635. All rights reserved.
//

#import "QWViwepageView.h"
#import "Masonry.h"

#define currentSelfWidth  self.bounds.size.width

@interface QWViwepageView()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray  *imageURLOrNameContainer;
@property (nonatomic,assign) NSInteger currentIndex ;
@property (nonatomic,strong) NSMutableDictionary *imageContainer ;
@property (nonatomic,strong) UILabel *flagLabel ;
@property (nonatomic,strong) UIImageView *leftImageView ;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIImageView *rightImageView ;
@property (nonatomic,weak) NSTimer *timer ;
@property (nonatomic,strong) UIImage *flagImage ;
@end


@implementation QWViwepageView


-(void)drawRect:(CGRect)rect{
     [self setupContentView];
     [self setupConstraints];
    [super drawRect:rect] ;
    [self setupPageControl];
   
}

#pragma mark - 公开接口
- (instancetype)initWithFrame:(CGRect)frame ViwepageImageArray:(NSArray*)array{
      self  = [super initWithFrame:frame];
    if (self) {
        [self.imageURLOrNameContainer addObjectsFromArray:array];
        [self loadImage];
        [self setupContentView];
        [self setupConstraints];
        [self setupScrollSelf];
        [self putOnImage];
        [self startScroll];
    }
    return self;
}
- (void)appendImages:(NSArray *)imageArray
{
    [self.imageURLOrNameContainer addObjectsFromArray:imageArray];
    [self loadImage];
}
- (void)deleteImages:(NSArray *)delegeImageArray
{
    [self.imageURLOrNameContainer removeObjectsInArray:delegeImageArray];
    [self.imageContainer removeAllObjects];
    [self loadImage];
}
- (void)clearImageCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [self getNetworkImagePathString];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:nil];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *fileName = nil ;
    while (fileName = [e nextObject]) {
        if ([fileName hasSuffix:@".data"]) {
            [fileManager removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
        }
    }
}

- (float )imageDiskCacheSize{
    NSString *folderPath = [self getNetworkImagePathString];
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (float)fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
    }
    return 0;
    
}

#pragma mark - touches method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"开始点击");
    [self.timer invalidate];
    NSLog(@"%@",[self.timer class]);
    __weak typeof(self) mySelf = self ;
     NSTimeInterval temp = self.userTouchWaitTime != 0 ? self.userTouchWaitTime: 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(temp * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(!self.timer){
           [mySelf startScroll];
        }
    });
}
#pragma mark - 私有方法


- (void)setupScrollSelf{
    self.showsHorizontalScrollIndicator = NO ;
    self.showsVerticalScrollIndicator = NO ;
    self.delegate = self ;
    self.backgroundColor = [UIColor redColor];
    self.bounces = NO ;
    self.pagingEnabled = YES ;
}

- (void)setupPageControl{
    if (!self.isShowPageControl) {
        return ;
    }
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.numberOfPages = self.imageURLOrNameContainer.count ;
    [self.superview addSubview:self.pageControl];
    switch (self.pageControlDirection) {
        case QWPageControlDirectionCenter:
            self.pageControl.center = CGPointMake(self.center.x, self.center.y + self.bounds.size.height * 0.5 -20);
            break;
        case QWPageControlDirectionLeft:
            self.pageControl.center = CGPointMake(self.pageControl.bounds.size.width * 0.5,self.bounds.size.height * 0.5 -20);
            break;
        case QWPageControlDirectionRight:
            self.pageControl.center = CGPointMake(currentSelfWidth - self.pageControl.bounds.size.width * 0.5,self.bounds.size.height * 0.5 -20);
            break;
    }
}

#pragma mark -  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self offsetIsChanged];
}


#pragma  mark - view 定制

- (void)setupConstraints{
    __weak typeof(self) mySelf = self ;
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(mySelf);
        make.width.equalTo(mySelf.mas_width).multipliedBy(1);
    }];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(mySelf);
        make.width.equalTo(mySelf.mas_width).multipliedBy(1);
        make.left.equalTo(mySelf.leftImageView.mas_right).mas_equalTo(0);
        make.top.equalTo(@0);
    }];
    [self.rightImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(mySelf);
        make.width.equalTo(mySelf.mas_width).multipliedBy(1);
        make.left.equalTo(mySelf.centerImageView.mas_right).mas_equalTo(0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
    }];
}

- (void)setupContentView{
    self.contentSize = CGSizeMake(self.bounds.size.width * 3 , self.bounds.size.height);
}


#pragma mark - 滚动逻辑

- (void)putOnImage {
    self.leftImageView.image = [self getImageWithIndex:self.currentIndex - 1];
    self.centerImageView.image = [self getImageWithIndex:self.currentIndex];
    self.rightImageView.image = [self getImageWithIndex:self.currentIndex + 1];
}
- (void)startScroll{
    if (self.isNoAutoScroll) {
        return ;
    }
    NSTimeInterval temp = self.scrollAnimationDurationTimeInterval + self.scrollWaitTimeInterval != 0 ? self.scrollAnimationDurationTimeInterval + self.scrollWaitTimeInterval: 3;
    if (self.isNoScrollAnimation) {
        temp = 0 ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSTimer scheduledTimerWithTimeInterval:temp target:self selector:@selector(scrollMethod:) userInfo:nil repeats:YES];
    });
}

- (void) scrollMethod:(NSTimer*)timer{
    self.timer = timer;
    NSTimeInterval temp = self.scrollAnimationDurationTimeInterval != 0 ? self.scrollAnimationDurationTimeInterval: 1.5;
    __weak typeof(self) mySelf = self ;
    [UIView animateWithDuration:temp animations:^{
        if (mySelf.scrollDirection == QWScrollDirectionLeft) {
            [mySelf ScrollToLeft];
        }
        if (mySelf.scrollDirection == QWScrollDirectionRight) {
            [mySelf ScrollToRight];
        }
    } completion:^(BOOL finished) {
         [self offsetIsChanged];
    }];
}

- (void) ScrollToRight{
    self.contentOffset = CGPointMake(currentSelfWidth * 2, 0);
}
- (void) ScrollToLeft{
    self.contentOffset = CGPointMake(0, 0);
}

- (void)offsetIsChanged{
      CGFloat offsetX = self.contentOffset.x ;
    if (offsetX > currentSelfWidth * 1) {
        self.currentIndex ++ ;
    }
    if (offsetX  < currentSelfWidth * 1) {
        self.currentIndex -- ;
    }
}

- (UIImage *)getImageWithIndex:(NSInteger)index{
    if (index < 0 ) {
        index = self.imageURLOrNameContainer.count - 1;
    }
    if (index > self.imageURLOrNameContainer.count - 1) {
        index = 0 ;
    }
    NSString *key = [self getImageKeyStringWith:index];
    if (!key) {
        return self.flagImage ;
    }
    UIImage *image = self.imageContainer[key];
    if (![image isKindOfClass:[UIImage class]]) {
        return self.flagImage ;
    }
    return  image;
}

- (NSString *) getImageKeyStringWith:(NSInteger)index{
 
    id temp = [self.imageURLOrNameContainer objectAtIndex:index];
    if ([temp isKindOfClass:[UIImage class]]) {
        UIImage *tempImage = temp ;
        return [NSString stringWithFormat:@"%ld",tempImage.hash];
    }
    if ([temp isKindOfClass:[NSString class]]) {
       return [temp lastPathComponent];
    }
    return nil ;
}

- (void)loadImage{
    if (self.imageURLOrNameContainer.count == 0 ) {
        return ;
    }
    for (id subItem in self.imageURLOrNameContainer) {
        
        if ([subItem isKindOfClass:[NSString class]]) {
            [self loadImageFormsubString:subItem];
        }
        if ([subItem isKindOfClass:[UIImage class]]) {
           
            [self loadImageFormImage:subItem];
        }
    }
}
- (void)loadImageFormImage:(UIImage*)subImage{
     self.imageContainer[[NSString stringWithFormat:@"%ld",subImage.hash]] = subImage;
}

- (void)loadImageFormsubString:(NSString *)subString{
    if ([subString hasPrefix:@"http://"]||[subString hasPrefix:@"https://"]) {
        if ([self isExistsFileName:[subString lastPathComponent]]) {
            [self loadImageFormNetworkWithCache:[subString lastPathComponent]];
        }else{
            [self loadImageFormNetworkWithURL:[NSURL URLWithString:subString]];
        }
    }else{
        self.imageContainer[[subString lastPathComponent]]= [UIImage imageNamed:subString];
    }
}

- (void)loadImageFormNetworkWithURL:(NSURL*)URL{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *keyString =  [[URL absoluteString] lastPathComponent];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || data.length == 0) {
            [self showAlertString:@"亲,载入图片失败了呢"];
        }else{
            UIImage *image = [UIImage imageWithData:data];
            __weak typeof(self) mySelf = self ;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [mySelf cacheNetworkImage:image andCacheImageFileName:keyString];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                mySelf.imageContainer[keyString] = image;
            });
        }
    }];
    self.imageContainer[keyString] = self.flagLabel;
    [task resume];
}

- (void)loadImageFormNetworkWithCache:(NSString *)FileName{
    NSString *stringPath = [self getFileName:FileName];
    NSData *data = [NSData dataWithContentsOfFile:stringPath];
    UIImage *image = [UIImage imageWithData:data];
    __weak typeof(self) mySelf = self ;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [mySelf cacheNetworkImage:image andCacheImageFileName:FileName];
    });
     self.imageContainer[FileName] = self.flagLabel;
}

- (BOOL)isExistsFileName:(NSString *)fileName{
    NSString *path = [self getFileName:fileName];
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL isDirectory = NO ;
    if ([manger fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
        return YES ;
    }
    return NO ;
}

- (void)cacheNetworkImage:(UIImage *)image andCacheImageFileName:(NSString*)fileName{
    NSData *imageData = UIImagePNGRepresentation(image);
    [self writeImageFile:imageData fileName:fileName];
}

- (NSString *)getNetworkImagePathString{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory  = NO ;
    if (![manager fileExistsAtPath:path isDirectory:&isDirectory] || !isDirectory) {
        NSError *createDiectoryError = nil ;
        [manager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&createDiectoryError];
        if (createDiectoryError) {
            [self showAlertString:@"创建缓存目录错误"];
        }
    }
    return  path ;
}

- (void)writeImageFile:(NSData *)data fileName:(NSString *)fileName{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath = [self getFileName:fileName];
    [manager createFileAtPath:filePath contents:data attributes:nil];
}

- (NSString *)getFileName:(NSString *)fileName{
     NSString *filePath = [[self getNetworkImagePathString] stringByAppendingPathComponent:fileName];
     filePath = [filePath stringByAppendingString:@".data"];
    return filePath;
}
- (void)showAlertString:(NSString *)string{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示:" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [[self getCurrentViewController] presentViewController:alertController animated:YES completion:^{
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(returnCurrentViewController:) userInfo:nil repeats:NO];
    }];
}

-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)returnCurrentViewController:(NSTimer*)timer{
    UIViewController *vc = timer.userInfo;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)pictureClicked{
    [self.QWViwepageViewDelegate viwepageViewPicture:self.centerImageView.image Index:self.currentIndex];
}

#pragma mark - 图片绘制
- (UIImage *)createImageWithNSString:(NSString*)string {
    UIGraphicsBeginImageContext(CGSizeMake(currentSelfWidth, self.bounds.size.height));
    [string drawAtPoint:CGPointZero withAttributes:nil];
    //[self.flagLabel drawRect:CGRectMake(0, 0, self., <#CGFloat height#>)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - setter and getter

- (NSMutableArray*)imageURLOrNameContainer{
    if (!_imageURLOrNameContainer) {
        _imageURLOrNameContainer = @[].mutableCopy;
    }
    return _imageURLOrNameContainer;
}
- (NSMutableDictionary *)imageContainer{
    if (!_imageContainer) {
        _imageContainer = @{}.mutableCopy;
    }
    return _imageContainer;
}
- (UILabel *)flagLabel{
    if (!_flagLabel) {
        _flagLabel = [UILabel new] ;
        _flagLabel.text = @"哎呀,图片去哪里了...";
    }
    return _flagLabel;
}

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
        [self addSubview:_leftImageView];
    }
    return _leftImageView   ;
}

- (UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]init];
        _centerImageView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pictureClicked)];
        [_centerImageView addGestureRecognizer:tap];
        [self addSubview:_centerImageView];
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        [self addSubview:_rightImageView];
    }
    return _rightImageView;
}

- (void)setCurrentIndex:(NSInteger )currentIndex{
    _currentIndex = currentIndex ;
    if (_currentIndex < 0) {
        _currentIndex  = self.imageURLOrNameContainer.count - 1 ;
    }
    if (_currentIndex > self.imageURLOrNameContainer.count - 1) {
        _currentIndex = 0 ;
    }
    [self putOnImage];
    self.contentOffset = CGPointMake(currentSelfWidth, 0);
    self.pageControl.currentPage = self.currentIndex;
}

- (UIImage *)flagImage{
    if (!_flagImage) {
        _flagImage = [self createImageWithNSString:@"亲,你的图片你"];
    }
    return _flagImage;
}

@end
