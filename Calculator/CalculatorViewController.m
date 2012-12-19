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
@synthesize input = _input;
@synthesize description = _description;
@synthesize variable = _variable;
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
    [self setInput:nil];
    [self setDescription:nil];
    [self setVariable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    } else if (![digit isEqualToString:@"0"]) {
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
    self.description.text = [self.brain performDescription];
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    //when enter key pressed, erase the equal sign at the end of input text
    //so that user can distinguish what is input and what is result
    self.input.text = [self.input.text stringByReplacingOccurrencesOfString:@"=" withString:@""];
    self.input.text = [self.input.text stringByAppendingFormat:@"%@ ", self.display.text];
    self.description.text = [self.brain performDescription];
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
    self.description.text = @"";
    self.variable.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.pointIsInTheMiddleOfANumber = NO;
    [self.testVariableValues removeAllObjects];
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

- (IBAction)testPressed:(UIButton *)sender 
{
    [self.testVariableValues removeAllObjects];
    
    if ([sender.currentTitle isEqualToString:@"Test1"]) {
        [self.testVariableValues setValue:[NSNumber numberWithDouble:19] forKey:@"z"];
    } else if ([sender.currentTitle isEqualToString:@"Test2"]) {
        [self.testVariableValues setValue:[NSNumber numberWithDouble:8.5] forKey:@"y"];
        [self.testVariableValues setValue:[NSNumber numberWithDouble:-205] forKey:@"z"];
    } else if ([sender.currentTitle isEqualToString:@"Test3"]) {
        [self.testVariableValues setValue:[NSNumber numberWithDouble:19.92] forKey:@"x"];
        [self.testVariableValues setValue:[NSNumber numberWithDouble:50] forKey:@"y"];
        [self.testVariableValues setValue:[NSNumber numberWithDouble:9] forKey:@"z"];
    }
    
    NSString *variableDescription = @"";
    NSSet *variablesUsed;
    variablesUsed = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    
    for (id variable in variablesUsed) {
        if ([variable isKindOfClass:[NSString class]]) {
            id value = [self.testVariableValues valueForKey:variable];
            if ([value isKindOfClass:[NSNumber class]]) {
                variableDescription = [variableDescription stringByAppendingFormat:@" %@ = %g ", variable, [value doubleValue]];
            }
        }
    }
    
    self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.brain.program usingVariableValues:[self.testVariableValues copy]]];
    
    self.variable.text = variableDescription;
}

@end
