//
//  GraphView.m
//  Calculator
//
//  Created by Zhe Sun on 12/20/12.
//  Copyright (c) 2012 CocoaXcode.com. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView ()

@end


@implementation GraphView

@synthesize origin = _origin;
@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

- (CGPoint)centerOfBounds
{
    return CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
}

- (void)setup
{
    NSNumber *defaultOriginX = [[NSUserDefaults standardUserDefaults] objectForKey:@"GraphViewOriginX"];    
    NSNumber *defaultOriginY = [[NSUserDefaults standardUserDefaults] objectForKey:@"GraphViewOriginY"];
    if (defaultOriginX && defaultOriginY) {
        self.origin = CGPointMake([defaultOriginX floatValue], [defaultOriginY floatValue]);
    } else {
        self.origin = CGPointZero;
    }
    
    NSNumber *defaultScale = [[NSUserDefaults standardUserDefaults] objectForKey:@"GraphViewScale"];
    if (defaultScale) {
        self.scale = [defaultScale floatValue] > 0? [defaultScale floatValue]: GRAPH_VIEW_DEFAULT_SCALE;
    } else {
        self.scale = GRAPH_VIEW_DEFAULT_SCALE;
    }
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setOrigin:(CGPoint)origin
{
    _origin = origin;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:origin.x] forKey:@"GraphViewOriginX"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:origin.y] forKey:@"GraphViewOriginY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setNeedsDisplay];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:scale] forKey:@"GraphViewScale"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#define DRAW_GRAPH_MAX_POINTS 4000

- (void)drawGraphInRect:(CGRect)bounds
         originAtPoint:(CGPoint)axisOrigin
                 scale:(CGFloat)pointsPerUnit
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);
    CGPoint points[DRAW_GRAPH_MAX_POINTS] = {CGPointZero};
    CGPoint currentPoint = CGPointZero;
    size_t count = 0;
    
    id valueOfY;
    do {
        valueOfY = [self.dataSource valueOfYWithX:(currentPoint.x - axisOrigin.x) / pointsPerUnit];
        if (![valueOfY isKindOfClass:[NSNumber class]]) {
            currentPoint.x += 1.0;
            continue;
        }
        
        currentPoint.y = axisOrigin.y - ([valueOfY doubleValue] * pointsPerUnit);
        points[count] = currentPoint;
        
        currentPoint.x += 1.0;
        ++count;
        
    } while (currentPoint.x < bounds.size.width && count < DRAW_GRAPH_MAX_POINTS);
    CGContextAddLines(context, points, count);
    [[UIColor blueColor] setStroke];
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:CGPointMake(self.centerOfBounds.x + self.origin.x, self.centerOfBounds.y + self.origin.y) scale:self.scale];
    [self drawGraphInRect:self.bounds originAtPoint:CGPointMake(self.centerOfBounds.x + self.origin.x, self.centerOfBounds.y + self.origin.y) scale:self.scale];
}

@end
