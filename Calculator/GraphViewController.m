//
//  GraphViewController.m
//  Calculator
//
//  Created by Zhe Sun on 12/20/12.
//  Copyright (c) 2012 CocoaXcode.com. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController () <GraphViewDataSource>

@end


@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize descriptionOnGraph = _descriptionOnGraph;
@synthesize delegate = _delegate;
@synthesize program = _program;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *descriptionOfProgram = [self.delegate descriptionOfProgram:self.program];
    if (descriptionOfProgram) {
        self.descriptionOnGraph.text = [NSString stringWithFormat:@"y = %@", descriptionOfProgram];
    } else {
        self.descriptionOnGraph.text = nil;
    }
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [self setDescriptionOnGraph:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.graphView restoreOriginAndScale];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.graphView preserveOriginAndScale];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
}

- (void)setProgram:(NSArray *)program
{
    _program = program;
    
    NSString *descriptionOfProgram = [self.delegate descriptionOfProgram:self.program];
    if (descriptionOfProgram) {
        self.descriptionOnGraph.text = [NSString stringWithFormat:@"y = %@", descriptionOfProgram];
    } else {
        self.descriptionOnGraph.text = nil;
    }
    
    [self.graphView setNeedsDisplay];
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender 
{
    if (sender.state == UIGestureRecognizerStateChanged 
        || sender.state == UIGestureRecognizerStateEnded) {
        self.graphView.scale *= sender.scale;
        sender.scale = 1.0;
    }
}

- (IBAction)panWithOneTouch:(UIPanGestureRecognizer *)sender 
{
    if (sender.state == UIGestureRecognizerStateChanged 
        || sender.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [sender translationInView:self.graphView];
        self.graphView.origin = CGPointMake(self.graphView.origin.x + translation.x, self.graphView.origin.y + translation.y);
        [sender setTranslation:CGPointZero inView:self.graphView];
    }
}

- (IBAction)tripleTapWithOneTouch:(UITapGestureRecognizer *)sender 
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:self.graphView];
        self.graphView.origin = CGPointMake(location.x - self.graphView.centerOfBounds.x, location.y - self.graphView.centerOfBounds.y);
    }
}

- (IBAction)longPressWithOneTouch:(UILongPressGestureRecognizer *)sender 
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.graphView defaultOriginAndScale];
    }
}

- (double)valueOfYWithX:(double)valueOfX isValid:(BOOL *)valid 
{
    id valueOfY = [self.delegate runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:valueOfX] forKey:@"x"]];
    
    if (![valueOfY isKindOfClass:[NSNumber class]]) {
        *valid = NO;
        return 0.0;
    }
    
    *valid = YES;
    return [valueOfY doubleValue];
}

@end
