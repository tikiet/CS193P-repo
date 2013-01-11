//
//  CalculatorViewController.m
//  Calculator
//
//  Created by nemo on 1/4/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasEnteredDot;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSMutableDictionary * testVariableValue;
@end

@implementation CalculatorViewController

@synthesize brain = _brain;

- (NSMutableDictionary *)testVariableValue
{
    if (!_testVariableValue)
        _testVariableValue = [[NSMutableDictionary alloc] init];
    return _testVariableValue;
}

- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitTapped:(UIButton *)sender
{
    NSString * digit = [sender currentTitle];
    if ([digit isEqualToString:@"."] && self.userHasEnteredDot){
        return;
    }else if(self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
        if([digit isEqualToString:@"."])
            self.userHasEnteredDot = YES;
    }else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        if([digit isEqualToString:@"."])
            self.userHasEnteredDot = YES;
    }
}

- (IBAction)enterTapped
{
    if(self.userIsInTheMiddleOfEnteringANumber){
        NSScanner *scanner = [NSScanner scannerWithString:self.display.text];
        if ([scanner scanDouble: NULL] && [scanner isAtEnd])
            [self.brain pushOperand: [self.display.text doubleValue]];
        else
            [self.brain push:self.display.text];
    
    
        self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.userHasEnteredDot = NO;
    
        [self updateVariableLabel];
    }
}

- (void) operationCPressed
{
    [self.brain clearData];
    self.userHasEnteredDot = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.display.text = @"0";
    self.history.text = @"";
}

- (void) operationBackPressed
{
    if([self.display.text length] > 1){
        if([[self.display.text
             substringFromIndex:[self.display.text length] -1]
            isEqualToString: @"."]){
            self.userHasEnteredDot = NO;
        }
        
        self.display.text = [self.display.text
                             substringToIndex:[self.display.text length] - 1];
    }
    else{
        if([self.display.text isEqualToString:@"."])
            self.userHasEnteredDot = NO;
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)operationTapped:(UIButton *)sender
{
    NSString *operation = sender.currentTitle;
    
    if([operation isEqualToString:@"C"]){
        [self operationCPressed];
        return;
    }
    
    if([operation isEqualToString:@"←"]){
        [self operationBackPressed];
        return;
    }
    
    if(self.userIsInTheMiddleOfEnteringANumber){
        if([self.display.text hasPrefix:@"-"]
           && [operation isEqualToString:@"+"]){
            self.display.text = [self.display.text substringFromIndex:1];
            return;
        }else if(![self.display.text hasPrefix:@"-"]
                 && [operation isEqualToString:@"-"]){
            self.display.text = [@"-" stringByAppendingString:self.display.text];
            return;
        }else if([operation isEqualToString:@"-"]
                 || [operation isEqualToString:@"+"])
            return;
            
        [self enterTapped];
    }
    
    [self.brain pushOperator:operation];
    [self updateResults];
}

- (void)updateResults
{
    self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    id result = [CalculatorBrain runProgram:self.brain.program
                        usingVariableValues:self.testVariableValue];
    if ([result isKindOfClass:[NSNumber class]])
        self.display.text = [NSString stringWithFormat:@"%g",[(NSNumber *)result doubleValue]];
    else
        self.display.text =
            (NSString *)result;
}
- (void)updateVariableLabel
{
    NSSet *vars = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    NSString *result = @"";
    for (NSString *key in vars){
        result  = [result stringByAppendingFormat:@"%@=%@ ", key, self.testVariableValue[key]];
    }
    self.variableLabel.text = result;
}

- (IBAction)pushVarX {
    [self.testVariableValue
     setObject:[NSNumber numberWithDouble:2.5]
        forKey:@"X"];
    
    self.display.text = @"X";
    [self updateVariableLabel];
}
- (IBAction)pushVarY {
    [self.testVariableValue
     setObject:[NSNumber numberWithDouble:1.1]
        forKey:@"Y"];
    
    self.display.text = @"Y";
    [self updateVariableLabel];
}

- (IBAction)test1Tapped {
    self.testVariableValue = nil;
    [self updateVariableLabel];
}

- (IBAction)undoPressed {
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self operationBackPressed];
    
    if(!self.userIsInTheMiddleOfEnteringANumber){
        [self.brain popAnItemFromProgramStack];
        [self updateResults];
    }
}
@end
