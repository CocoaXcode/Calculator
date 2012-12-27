//
//  CalculatorViewController.m
//  Calculator
//
//  Created by LoveBingbing on 12/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController () <GraphViewControllerDelegate>

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL pointIsInTheMiddleOfANumber;
@property (strong, nonatomic) CalculatorBrain *brain;

@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize description = _description;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize pointIsInTheMiddleOfANumber = _pointIsInTheMiddleOfANumber;
@synthesize brain = _brain;

#pragma mark View Related
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.splitViewController.delegate = self;
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setDescription:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.splitViewController) {
        return YES;
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowGraph"]) {
        GraphViewController *graphVC = segue.destinationViewController;
        graphVC.delegate = self;
        graphVC.program = self.brain.program;
    }
}

#pragma mark Accessors
- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

#pragma mark Press Action
- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    [self.brain pushOperation:sender.currentTitle];
    id result = [CalculatorBrain runProgram:self.brain.program];
    if ([result isKindOfClass:[NSNumber class]]) {
        self.display.text = [result stringValue];
    } else if ([result isKindOfClass:[NSString class]]) {
        self.display.text = result;
    }
    self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.pointIsInTheMiddleOfANumber = NO;
}

- (IBAction)pointPressed 
{
    if (self.pointIsInTheMiddleOfANumber) {
        return;
    }
    
    //Point pressed while displaying the result
    //whole display text will be cleared and start off with @"0."
    //It is a little tricky, but fully reasonable
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    } else {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
    self.pointIsInTheMiddleOfANumber = YES;
}

- (IBAction)clearPressed 
{
    [self.brain clearStack];
    self.display.text = @"0";
    self.description.text = @"Please enter your formula.";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.pointIsInTheMiddleOfANumber = NO;
}

- (IBAction)changeSignPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        double newValueOfDisplayText = [self.display.text doubleValue] * (-1);
        self.display.text = [NSString stringWithFormat:@"%g", newValueOfDisplayText];
    } else {
        [self operationPressed:sender];
    }
}

- (IBAction)undoPressed:(UIButton *)sender 
{
    id result;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSUInteger lengthOfDisplayText = self.display.text.length;
        if (lengthOfDisplayText > 1) {
            //If last char of display text BEFORE substring equals to '.', then do something 
            unichar lastCharOfDisplayText = [self.display.text characterAtIndex: (lengthOfDisplayText - 1)];
            if (lastCharOfDisplayText == '.') {
                self.pointIsInTheMiddleOfANumber = NO;
            }
            
            //Perform substring
            self.display.text = [self.display.text substringToIndex: (lengthOfDisplayText - 1)];
        } else {
            result = [CalculatorBrain runProgram:self.brain.program];
            if ([result isKindOfClass:[NSNumber class]]) {
                self.display.text = [result stringValue];
            } else if ([result isKindOfClass:[NSString class]]) {
                self.display.text = result;
            }
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    } else {
        
        [self.brain popTopOfStack];
        result = [CalculatorBrain runProgram:self.brain.program];
        if ([result isKindOfClass:[NSNumber class]]) {
            self.display.text = [result stringValue];
        } else if ([result isKindOfClass:[NSString class]]) {
            self.display.text = result;
        }
        self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    }
}

- (IBAction)graphPressed:(UIButton *)sender 
{
    if (self.splitViewController) {
        GraphViewController *graphVC = [self.splitViewController.viewControllers lastObject];
        graphVC.delegate = self;
        graphVC.program = self.brain.program;
    }
}

- (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    return [CalculatorBrain runProgram:program usingVariableValues:variableValues];
}

- (NSString *)descriptionOfProgram:(id)program
{
    return [CalculatorBrain descriptionOfProgram:program];
}

- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{
    return (UIInterfaceOrientationIsPortrait(orientation));
}

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc
{
    GraphViewController *graphVC = [svc.viewControllers lastObject];
    barButtonItem.title = self.navigationItem.title;
    graphVC.splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    GraphViewController *graphVC = [svc.viewControllers lastObject];
    graphVC.splitViewBarButtonItem = nil;
}

@end
