//
//  CalculatorViewController.m
//  Calculator
//
//  Created by LoveBingbing on 12/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL pointIsInTheMiddleOfANumber;
@property (strong, nonatomic) CalculatorBrain *brain;
@property (strong, nonatomic) NSMutableDictionary *testVariableValues;

@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize description = _description;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize pointIsInTheMiddleOfANumber = _pointIsInTheMiddleOfANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

#pragma mark View Related
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Accessors
- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (NSMutableDictionary *)testVariableValues
{
    if (!_testVariableValues) {
        _testVariableValues = [[NSMutableDictionary alloc] init];
    }
    return _testVariableValues;
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
    self.display.text = [self.brain performOperation:sender.currentTitle];
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
    self.description.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.pointIsInTheMiddleOfANumber = NO;
    [self.testVariableValues removeAllObjects];
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
            self.display.text = [CalculatorBrain runProgram:self.brain.program usingVariableValues:[self.testVariableValues copy]];
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    } else {
        
        [self.brain popTopOfStack];
        self.display.text = [CalculatorBrain runProgram:self.brain.program usingVariableValues:[self.testVariableValues copy]];
        self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    }
}

@end
