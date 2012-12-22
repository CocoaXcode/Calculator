//
//  GraphViewController.m
//  Calculator
//
//  Created by Zhe Sun on 12/20/12.
//  Copyright (c) 2012 CocoaXcode.com. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController () <GraphViewDataSource>

@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionOnGraph;

@end


@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize descriptionOnGraph = _descriptionOnGraph;
@synthesize delegate = _delegate;
@synthesize descriptionOfProgram = _descriptionOfProgram;

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
    self.descriptionOnGraph.text = [NSString stringWithFormat:@"y = %@", self.descriptionOfProgram];
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [self setDescriptionOnGraph:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
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
        self.graphView.origin = CGPointZero;
        self.graphView.scale = GRAPH_VIEW_DEFAULT_SCALE;
    }
}

- (id)valueOfYWithX:(double)X
{
    return [self.delegate resultOfProgramWithVariableValues:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:X] forKey:@"x"]];
}

@end
