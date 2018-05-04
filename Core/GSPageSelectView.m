//
//  GSPageSelectView.m
//  CoreUITest
//
//  Created by Sheng on 2018/5/4.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "GSPageSelectView.h"

static NSString * GSPageSelectCellChangeNotification = @"GSPageSelectCellChangeNotification";

@implementation GSPageSelectCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.center = self.contentView.center;
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = self.bounds;
        
        _flag = [[UIView alloc]init];
        _flag.backgroundColor = [UIColor colorWithRed:105 green:105 blue:105 alpha:1.f];
        _flag.frame = CGRectMake((self.contentView.bounds.size.width - 40)/2, (self.contentView.bounds.size.height - 4 - 2), 40, 4);
        [self.contentView addSubview:_flag];
        [self.contentView addSubview:_titleLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleColor:) name:GSPageSelectCellChangeNotification object:nil];
    }
    return self;
}

- (void)handleColor:(NSNotification *)noti {
    
}

- (void)setFlagRect:(CGRect)flagRect {
    _flagRect = flagRect;
    _flag.frame = CGRectMake(self.bounds.size.height - flagRect.size.height, (self.bounds.size.width - flagRect.size.height), (self.bounds.size.width - flagRect.size.width)/2, flagRect.size.height);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        _flag.backgroundColor = [UIColor yellowColor];
    }else{
        _flag.backgroundColor = [UIColor colorWithRed:105 green:105 blue:105 alpha:1.f];
    }
}



@end

@interface GSPageSelectView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collection;
@end
static NSString * const reuseIdentifier = @"GSPageSelectCell";
@implementation GSPageSelectView
{
    int itemW;
}
- (instancetype)initWithFrame:(CGRect)frame style:(GSPageSelectStyle)style titles:(NSArray<NSString *> *)array{
    if (self = [super initWithFrame:frame]) {
        _titles = array;
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.minimumLineSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.itemSize = CGSizeMake(frame.size.width / _titles.count, frame.size.height);
        
        itemW = frame.size.width / _titles.count;
        
        flow.sectionInset = UIEdgeInsetsMake(0, (frame.size.width - itemW)/2, 0, (frame.size.width - itemW)/2);
        
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flow];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.scrollEnabled = NO;
        [_collection registerClass:[GSPageSelectCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [self addSubview:_collection];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _collection.backgroundColor = self.backgroundColor;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.collection) {
        NSInteger index = self.collection.contentOffset.x/itemW;
        [self.collection setContentOffset:CGPointMake(index*itemW, 0) animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSPageSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = _titles[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageSelectView:didSelectAtIndex:)]) {
        [self.delegate pageSelectView:self didSelectAtIndex:indexPath.item];
    }
    
}

@end
