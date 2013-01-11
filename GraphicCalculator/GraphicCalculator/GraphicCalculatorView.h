//
//  GraphicCalculatorView.h
//  GraphicCalculator
//
//  Created by nemo on 1/7/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphicCalculatorViewDataSource;

@interface GraphicCalculatorView : UIView
@property (weak, nonatomic) IBOutlet id <GraphicCalculatorViewDataSource> dataSource;
@end

@protocol GraphicCalculatorViewDataSource <NSObject>
- (NSArray *)getProgram;
@property (nonatomic) float scale;
@property (nonatomic) CGPoint origin;
@end
