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

@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize input = _input;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize pointIsInTheMiddleOfANumber = _pointIsInTheMiddleOfANumber;
@synthesize brain = _brain;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setInput:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

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
    double result = [self.brain performOperation:sender.currentTitle];
    //first erase the equal sign at the end of input text, then add operation with equal sign
    //that keeps only one equal sign at the end of input text
    self.input.text = [self.input.text stringByReplacingOccurrencesOfString:@"=" withString:@""];
    self.input.text = [self.input.text stringByAppendingFormat:@"%@ =", sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    //when enter key pressed, erase the equal sign at the end of input text
    //so that user can distinguish what is input and what is result
    self.input.text = [self.input.text stringByReplacingOccurrencesOfString:@"=" withString:@""];
    self.input.text = [self.input.text stringByAppendingFormat:@"%@ ", self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.pointIsInTheMiddleOfANumber = NO;
}

- (IBAction)pointPressed 
{
    if (self.pointIsInTheMiddleOfANumber) {
        return;
    }
    
    //point pressed while displaying the result
    //whole display text will be cleared and start off with "0."
    //it is a little tricky, but fully reasonable
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
    self.input.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.pointIsInTheMiddleOfANumber = NO;
}

- (IBAction)backspacePressed 
{
    //backspace pressed while displaying the result
    //whole display text will be cleared and start off with "0"
    //it is a little tricky, but fully reasonable
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = @"0";
        return;
    }
    
    NSUInteger lengthOfDisplayText = self.display.text.length;
    if (lengthOfDisplayText > 1) {
        //if last char of display text BEFORE substring equals to '.', then do something 
        unichar lastCharOfDisplayText = [self.display.text characterAtIndex: (lengthOfDisplayText - 1)];
        if (lastCharOfDisplayText == '.') {
            self.pointIsInTheMiddleOfANumber = NO;
        }
        
        //perform substring
        self.display.text = [self.display.text substringToIndex: (lengthOfDisplayText - 1)];
    } else {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
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

@end
