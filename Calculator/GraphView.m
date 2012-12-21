//
//  GraphView.m
//  Calculator
//
//  Created by Zhe Sun on 12/20/12.
//  Copyright (c) 2012 CocoaXcode.com. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize origin = _origin;
@synthesize scale = _scale;

- (void)setup
{
    self.origin = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
    self.scale = 1.0;
}

- (void)setOrigin:(CGPoint)origin
{
    _origin = origin;
    [self setNeedsDisplay];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
}

@end
