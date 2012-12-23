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

- (void)setOrigin:(CGPoint)origin
{
    if (!CGPointEqualToPoint(_origin, origin)) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale > 0 && _scale != scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)restoreOriginAndScale
{
    NSNumber *defaultOriginX = [[NSUserDefaults standardUserDefaults] objectForKey:@"GraphViewOriginX"];    
    NSNumber *defaultOriginY = [[NSUserDefaults standardUserDefaults] objectForKey:@"GraphViewOriginY"];
    NSNumber *defaultScale = [[NSUserDefaults standardUserDefaults] objectForKey:@"GraphViewScale"];
    
    if (defaultOriginX && defaultOriginY && defaultScale) {
        self.origin = CGPointMake([defaultOriginX floatValue], [defaultOriginY floatValue]);
        self.scale = [defaultScale doubleValue];
    } else {
        [self defaultOriginAndScale];
    }
}

- (void)preserveOriginAndScale
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.origin.x] forKey:@"GraphViewOriginX"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.origin.y] forKey:@"GraphViewOriginY"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.scale] forKey:@"GraphViewScale"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#define GRAPH_VIEW_DEFAULT_SCALE 25.0
- (void)defaultOriginAndScale
{
    self.origin = CGPointZero;
    self.scale = GRAPH_VIEW_DEFAULT_SCALE;
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
    CGFloat increment = 1.0 / self.contentScaleFactor;    
    double valueOfY = 0.0;
    BOOL valid = NO;
    do {
        valueOfY = [self.dataSource valueOfYWithX:((currentPoint.x - axisOrigin.x) / pointsPerUnit) isValid:&valid];
        if (!valid) {
            if (count > 1) {
                CGContextAddLines(context, points, count);
            }
            
            currentPoint.x += increment;
            count = 0;
            continue;
        }
        
        currentPoint.y = axisOrigin.y - (valueOfY * pointsPerUnit);
        points[count] = currentPoint;
        
        currentPoint.x += increment;
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
