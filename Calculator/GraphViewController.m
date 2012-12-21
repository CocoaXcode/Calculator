//
//  GraphViewController.m
//  Calculator
//
//  Created by Zhe Sun on 12/20/12.
//  Copyright (c) 2012 CocoaXcode.com. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController
@synthesize graphView = _graphView;

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
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
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
        self.graphView.origin = location;
    }
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender 
{
    if (sender.state == UIGestureRecognizerStateChanged 
        || sender.state == UIGestureRecognizerStateEnded) {
        self.graphView.scale *= sender.scale;
        sender.scale = 1.0;
    }
}

@end
