//
//  CalculatorBrain.m
//  Calculator
//
//  Created by LoveBingbing on 12/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()

@property (strong, nonatomic) NSMutableArray *programStack;

@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    
    return _programStack;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id)program
{
    return [self.programStack copy];
}

+ (BOOL)isOperation:(NSString *)operation
{
    NSSet *setOfOperations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos", @"sqrt", @"π", @"+/-", nil];
    
    return [setOfOperations containsObject:operation];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
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
            result = 3.14159;
        } else if ([operation isEqualToString:@"+/-"]) {
            result = -[self popOperandOffStack:stack];
        }
    }
    
    return result;
}

- (void)clearStack
{
    [self.programStack removeAllObjects];
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
    return @"TO DO";
}

@end
