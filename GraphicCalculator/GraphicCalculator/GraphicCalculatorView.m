//
//  GraphicCalculatorView.m
//  GraphicCalculator
//
//  Created by nemo on 1/7/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "GraphicCalculatorView.h"
#import "AxesDrawer.h"
#import "CalculatorBrain.h"

@interface GraphicCalculatorView()
@property BOOL originSet;
@end

@implementation GraphicCalculatorView : UIView
@synthesize dataSource = _dataSource;

- (void) drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.dataSource.origin scale:self.dataSource.scale];
    
    float xOffset = self.bounds.size.width / 2 - self.dataSource.origin.x;
    float yOffset = self.bounds.size.height / 2 - self.dataSource.origin.y;
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@(0) forKey:@"X"];
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for (int x = (int)(xOffset - self.bounds.size.width / 2);
         x <= (int)(xOffset + self.bounds.size.width / 2);
         x += 1){
        
        dict[@"X"] = [NSNumber numberWithDouble:x / self.dataSource.scale];
        if ([self.dataSource getProgram])
            [results addObject:[CalculatorBrain
                                runProgram:[self.dataSource getProgram]
                       usingVariableValues:dict]];
        else
            return;
    }
    
    for (int x = (int)(xOffset - self.bounds.size.width / 2);
         x <= (int)(xOffset + self.bounds.size.width / 2);
         x += 1){
        CGRect dot = CGRectMake(
                        self.bounds.size.width / 2 + x -xOffset,
                       self.bounds.size.height / 2  - yOffset -  self.dataSource.scale * [[results objectAtIndex:0] doubleValue],
                        2,
                        2);
        [results removeObjectAtIndex:0];
        CGContextFillRect(UIGraphicsGetCurrentContext(), dot);
    }
    
}
@end