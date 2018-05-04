//
//  GSPageSelectView.h
//  CoreUITest
//
//  Created by Sheng on 2018/5/4.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GSPageSelectMoved,//下标移动
    GSPageSelectAlwaysMiddle, //选择项总是中间
} GSPageSelectStyle;


@interface GSPageSelectCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGRect flagRect;
@property (nonatomic, strong) UIView *flag;

@end
@class GSPageSelectView;
@protocol GSPageSelectDelegate <NSObject>
- (void)pageSelectView:(GSPageSelectView*)selectView didSelectAtIndex:(NSInteger)index;
@end

@interface GSPageSelectView : UIView
@property (nonatomic, assign) GSPageSelectStyle style;
@property (nonatomic, strong) NSArray* titles;
@property (nonatomic, weak) id <GSPageSelectDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(GSPageSelectStyle)style
                       titles:(NSArray <NSString *>*)array;

@end
