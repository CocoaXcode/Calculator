//
//  CalculatorBrain.h
//  Calculator
//
//  Created by LoveBingbing on 12/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (NSString *)performOperation:(NSString *)operation;
- (void)clearStack;
- (id)popTopOfStack;

@property (readonly) id program;

+ (NSString *)runProgram:(id)program;
+ (NSString *)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@end
