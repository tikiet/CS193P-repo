//
//  CalculatorBrain.m
//  Calculator
//
//  Created by nemo on 1/4/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if(!_programStack){
        _programStack = [[NSMutableArray alloc] init];
    }
    
    return _programStack;
}

- (id) program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgramFirstExpression:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    NSString *result = [self popOperandOffProgramStackAndDescribe:stack];
    
    return result;
}
+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    NSString *result = [self popOperandOffProgramStackAndDescribe:stack];
    while ([stack count] > 0){
        result = [NSString stringWithFormat:@"%@, %@", result,
                  [self popOperandOffProgramStackAndDescribe:stack]];
    }
    return result;
}

- (void)popAnItemFromProgramStack
{
    if ([self.programStack count] > 0)
        [self.programStack removeLastObject];
}

- (void)push:(NSString *)something
{
    [self.programStack addObject:something];
}

- (void)pushOperator:(NSString *)operator
{
    [self.programStack addObject:operator];
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.programStack lastObject];
    if (operandObject) [self.programStack removeLastObject];
    return [operandObject doubleValue];
}

+ (NSString *)popOperandOffProgramStackAndDescribe:(NSMutableArray *) stack
{
    NSString *result = @"";
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [NSString stringWithFormat:@"%@", topOfStack];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            NSString *first = [self popOperandOffProgramStackAndDescribe:stack];
            NSString *second = [self popOperandOffProgramStackAndDescribe:stack];
            result = [NSString stringWithFormat:@"(%@ + %@)", second, first];
        }else if([@"*" isEqualToString:operation]){
            NSString *first = [self popOperandOffProgramStackAndDescribe:stack];
            NSString *second = [self popOperandOffProgramStackAndDescribe:stack];
            result = [NSString stringWithFormat:@"(%@ * %@)", second, first];
        }else if([operation isEqualToString:@"-"]){
            NSString *subtrahend = [self popOperandOffProgramStackAndDescribe:stack];
            result = [NSString stringWithFormat:@"(%@ - %@)",
                      [self popOperandOffProgramStackAndDescribe:stack], subtrahend];
        }else if([operation isEqualToString:@"/"]){
            NSString *divisor = [self popOperandOffProgramStackAndDescribe:stack];
            result = [NSString stringWithFormat:@"(%@ / %@)",
                      [self popOperandOffProgramStackAndDescribe:stack],divisor];
        }else if([operation isEqualToString:@"sin"]){
            result = [NSString stringWithFormat:@"sin(%@)",
                      [self popOperandOffProgramStackAndDescribe:stack]];
        }else if([operation isEqualToString:@"cos"]){
            result = [NSString stringWithFormat:@"cos(%@)",
                      [self popOperandOffProgramStackAndDescribe:stack]];
        }else if([operation isEqualToString:@"sqrt"]){
            result = [NSString stringWithFormat:@"sqrt(%@)",
                      [self popOperandOffProgramStackAndDescribe:stack]];
        }else if([operation isEqualToString:@"π"]){
            result = @"π";
        }else
            result = operation;
    }

    return result;
}

+ (id)popOperandOffProgramStack:(NSMutableArray *)stack
{
    id result;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = topOfStack;
    }
    else if ([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            id first = [self popOperandOffProgramStack:stack];
            id second = [self popOperandOffProgramStack:stack];
            if ([first isKindOfClass:[NSNumber class]] &&
                [second isKindOfClass:[NSNumber class]])
                result = [NSNumber numberWithDouble: [first doubleValue] + [second doubleValue]];
            else
                result = @"Insufficient operands";
        }else if([@"*" isEqualToString:operation]){
            id first = [self popOperandOffProgramStack:stack];
            id second = [self popOperandOffProgramStack:stack];
            if ([first isKindOfClass:[NSNumber class]] &&
                [second isKindOfClass:[NSNumber class]])
                result = [NSNumber numberWithDouble: [first doubleValue] * [second doubleValue]];
            else
                result = @"Insufficient operands";
        }else if([operation isEqualToString:@"-"]){
            id first = [self popOperandOffProgramStack:stack];
            id second = [self popOperandOffProgramStack:stack];
            if ([first isKindOfClass:[NSNumber class]] &&
                [second isKindOfClass:[NSNumber class]])
                result = [NSNumber numberWithDouble:
                          [second doubleValue] - [first doubleValue]];
            else
                result = @"Insufficient operands";
        }else if([operation isEqualToString:@"/"]){
            id first = [self popOperandOffProgramStack:stack];
            id second = [self popOperandOffProgramStack:stack];
            if ([first isKindOfClass:[NSNumber class]] &&
                [second isKindOfClass:[NSNumber class]])
                result = [NSNumber numberWithDouble:
                          [second doubleValue] / [first doubleValue]];
            else
                result = @"Insufficient operands";
        }else if([operation isEqualToString:@"sin"]){
            id item = [self popOperandOffProgramStack:stack];
            if ([item isKindOfClass:[NSNumber class]])
                result = [NSNumber numberWithDouble:sin([item doubleValue])];
            else
                result = @"Insufficient operands";
        }else if([operation isEqualToString:@"cos"]){
            id item = [self popOperandOffProgramStack:stack];
            if ([item isKindOfClass:[NSNumber class]])
                result = [NSNumber numberWithDouble:cos([item doubleValue])];
            else
                result = @"Insufficient operands";
        }else if([operation isEqualToString:@"sqrt"]){
            id item = [self popOperandOffProgramStack:stack];
            if ([item isKindOfClass:[NSNumber class]])
                result = [NSNumber numberWithDouble:sqrt([item doubleValue])];
            else
                result = @"Insufficient operands";
        }else if([operation isEqualToString:@"π"]){
            result = @(3.1415926);
        }
    }
    
    return result;
}

- (void)clearData
{
    _programStack = nil;
}

+ (id)runProgram:(id)program
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (id)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffProgramStack:
            [self replaceVariablesAt:stack
                      withDictionary:variableValues]];
}

+ (NSMutableArray *)replaceVariablesAt:(NSMutableArray *)stack
                        withDictionary:(NSDictionary *)dictionary
{
    NSSet *builtInOperations =
        [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos", @"sqrt", @"π", nil];
    
    for(int i = 0; i < [stack count]; i++){
        if (![builtInOperations containsObject:stack[i]]
            && ![stack[i] isKindOfClass:[NSNumber class]]){
            NSNumber *number = dictionary[stack[i]];
            if(number)
                [stack replaceObjectAtIndex:i withObject:number];
            else
                [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:0.0]];
        }
    }

    return stack;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSSet *builtInOperations =
    [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos", @"sqrt", @"π", nil];
    
    NSMutableSet *variablesUsed = [[NSMutableSet alloc] init];
    for(id operation in program){
        if(![operation isKindOfClass:[NSNumber class]]
           && ![builtInOperations containsObject:operation])
            [variablesUsed addObject: operation];
    }
    
    if ([variablesUsed count] == 0)
        return nil;
    else
        return [variablesUsed copy];
}
@end
