//
//  CalculatorBrain.h
//  Calculator
//
//  Created by nemo on 1/4/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushOperator:(NSString *)operator;
- (void)push:(NSString *)something;
- (void)popAnItemFromProgramStack;
//- (double)performOperation:(NSString *)operation;
- (void)clearData;

@property (readonly) id program;
+ (id)runProgram:(id)program;
+ (id)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;
@end
