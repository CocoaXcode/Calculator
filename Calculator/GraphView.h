//
//  GraphView.h
//  Calculator
//
//  Created by Zhe Sun on 12/20/12.
//  Copyright (c) 2012 CocoaXcode.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDataSource <NSObject>

- (double)valueOfYWithX:(double)valueOfX isValid:(BOOL *)valid;

@end


@interface GraphView : UIView

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@property (nonatomic, readonly) CGPoint centerOfBounds;

@property (weak, nonatomic) id <GraphViewDataSource> dataSource;

- (void)restoreOriginAndScale;
- (void)preserveOriginAndScale;
- (void)defaultOriginAndScale;

@end
