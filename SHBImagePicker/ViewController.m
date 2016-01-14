//
//  ViewController.m
//  SHBImagePicker
//
//  Created by 沈红榜 on 16/1/14.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import "ViewController.h"
#import "SHBPhotoVC.h"


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ViewController {
    NSMutableArray      *_dataArray;
    UICollectionView    *_view;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    
    _view = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _view.dataSource = self;
    _view.delegate = self;
    _view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view];
    [_view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
    [self setToolbarItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc] initWithTitle:@"选择照片" style:UIBarButtonItemStylePlain target:self action:@selector(goToChoosePictures)]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:false animated:false];
    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setToolbarHidden:true animated:true];
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)goToChoosePictures {
    SHBPhotoVC *vc = [[SHBPhotoVC alloc] init];
    
    vc.selectedImages = ^(NSArray <NSData *>*array) {
        NSMutableArray *index = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < array.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_dataArray.count + i inSection:0];
            [index addObject:indexPath];
        }
        [_dataArray addObjectsFromArray:array];
        [_view insertItemsAtIndexPaths:index];
    };
    
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:na animated:true completion:nil];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    item.backgroundColor = [UIColor yellowColor];
    
    UIImageView *imgView = [item viewWithTag:1000];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(item.frame), CGRectGetHeight(item.frame))];
        imgView.tag = 1000;
        [item addSubview:imgView];
    }
    
    id asset = _dataArray[indexPath.row];
    imgView.image = [UIImage imageWithData:asset];
    
    return item;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
