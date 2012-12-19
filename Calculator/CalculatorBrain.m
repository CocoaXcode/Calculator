//
//  CalculatorBrain.m
//  Calculator
//
//  Created by LoveBingbing on 12/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

#define CALCULATORBRAIN_PI 3.14159

@interface CalculatorBrain ()

@property (strong, nonatomic) NSMutableArray *programStack;

@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

#pragma mark Accessors
- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

#pragma mark Instance Methods
- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (void)clearStack
{
    [self.programStack removeAllObjects];
}

- (NSString *)performDescription
{
    return [CalculatorBrain descriptionOfProgram:self.program];
}

#pragma mark Class Methods
+ (BOOL)isOperation:(NSString *)operation
{
    NSSet *setOfOperations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos", @"sqrt", @"π", @"+/-", nil];
    return [setOfOperations containsObject:operation];
}

+ (BOOL)isFunction:(NSString *)operation
{
    NSSet *setOfFunctions = [NSSet setWithObjects:@"sin", @"cos", @"sqrt", nil];
    return [setOfFunctions containsObject:operation];
}

+ (BOOL)isInfix:(NSString *)operation
{
    NSSet *setOfInfixes = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    return [setOfInfixes containsObject:operation];
}

+ (BOOL)canSuppressParenthesis:(NSString *)currentOperation 
         withPreviousOperation:(NSString *)previousOperation
{
    //If there is no previous operation or the previous operation is Function
    //Do suppress parenthesis
    if (!previousOperation || [self isFunction:previousOperation]) {
        return YES;
    }
    
    //Do suppress parenthesis reasonably
    if ([currentOperation isEqualToString:@"+"]
        || [currentOperation isEqualToString:@"-"]) {
        
        if ([previousOperation isEqualToString:@"+"]) {
            return YES;
        }
    } else if ([currentOperation isEqualToString:@"*"]
               || [currentOperation isEqualToString:@"/"]) {
        
        if ([previousOperation isEqualToString:@"+"]
            || [previousOperation isEqualToString:@"-"]
            || [previousOperation isEqualToString:@"*"]) {
            return YES;
        }
    }

    return NO;
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0; //default return value
    
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        //If top of stack is a number, return it directly
        result = [topOfStack doubleValue];
        
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        //If top of stack is a string, do the corresponding operation
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) {
                result = [self popOperandOffStack:stack] / divisor;
            }
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            double radicand = [self popOperandOffStack:stack];
            if (radicand >= 0) {
                result = sqrt(radicand);
            }
        } else if ([operation isEqualToString:@"π"]) {
            result = CALCULATORBRAIN_PI;
        } else if ([operation isEqualToString:@"+/-"]) {
            result = -[self popOperandOffStack:stack];
        }
    }
    
    return result;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack 
                withPreviousOperation:(NSString *)previousOperation;
{
    NSString *result = @"0"; //default return value
    
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        //If top of stack is a number, return it directly
        result = [topOfStack stringValue];
        
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        //If top of stack is a string, do the corresponding description
        NSString *operation = topOfStack;
        
        if ([self isFunction:topOfStack]) {
            //The Function is always with parentheses 
            result = [NSString stringWithFormat:@"%@(%@)", operation, [self descriptionOfTopOfStack:stack withPreviousOperation:operation]];
        } else if ([self isInfix:topOfStack]) {
            NSString *latterExpression = [self descriptionOfTopOfStack:stack withPreviousOperation:operation];
            NSString *formerExpression = [self descriptionOfTopOfStack:stack withPreviousOperation:operation];
            
            //The Infix do suppress parenthesis, if necessary
            if ([self canSuppressParenthesis:operation withPreviousOperation:previousOperation]) {
                result = [NSString stringWithFormat:@"%@ %@ %@", formerExpression, operation, latterExpression];
            } else {
                result = [NSString stringWithFormat:@"(%@ %@ %@)", formerExpression, operation, latterExpression];
            }

        } else if ([operation isEqualToString:@"+/-"]) {
            //If there is a previous operation, give the description with parentheses
            if (previousOperation) {
                result = [NSString stringWithFormat:@"(-%@)", [self descriptionOfTopOfStack:stack withPreviousOperation:operation]];
            } else {
                result = [NSString stringWithFormat:@"-%@", [self descriptionOfTopOfStack:stack withPreviousOperation:operation]];
            }
        } else {
            //If this happens, top of stack must be a variable name, return it directlhy
            result = topOfStack;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        //Iterate the whole program array, replace variables with corresponding values
        for (NSUInteger i = 0; i < [stack count]; ++i) {
            
            id objectOfStack = [stack objectAtIndex:i];
            //If the object is an NSString but not an operation, it must be a variable
            if ([objectOfStack isKindOfClass:[NSString class]] 
                && ![self isOperation:objectOfStack]) {
                
                NSNumber *value = [variableValues valueForKey:objectOfStack];
                //If the variable has no corresponding value, use 0 as its value
                if (!value) {
                    value = [NSNumber numberWithDouble:0];
                }
                
                [stack replaceObjectAtIndex:i withObject:value];
            }
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableArray *stack;
    NSMutableSet *setOfVariables;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        setOfVariables = [NSMutableSet set];
        //Iterate the whole program array, find out all of variables
        for (id objectOfStack in stack) {
            //If the object is an NSString but not an operation, it must be a variable
            if ([objectOfStack isKindOfClass:[NSString class]]
                && ![self isOperation:objectOfStack]) {
                
                [setOfVariables addObject:objectOfStack];
            }
        }
        
        //If there is no variable, return nil not an empty NSSet
        if ([setOfVariables count] == 0) {
            setOfVariables = nil;
        }
    }
    
    return setOfVariables;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    NSString *result;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        //Do description
        result = [self descriptionOfTopOfStack:stack withPreviousOperation:nil];
        //If stack is not empty after above step
        //Do description continuously and combine results with comma
        while ([stack count] > 0) {
            result = [result stringByAppendingFormat:@", %@", [self descriptionOfTopOfStack:stack withPreviousOperation:nil]];
        }
    }
    
    return result;
}

@end
