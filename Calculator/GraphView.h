//
//  GraphView.h
//  Calculator
//
//  Created by Zhe Sun on 12/20/12.
//  Copyright (c) 2012 CocoaXcode.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDataSource <NSObject>

- (id)valueOfYWithX:(double)X;

@end


@interface GraphView : UIView

#define GRAPH_VIEW_DEFAULT_SCALE 50.0

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@property (nonatomic, readonly) CGPoint centerOfBounds;

@property (weak, nonatomic) id <GraphViewDataSource> dataSource;

@end
