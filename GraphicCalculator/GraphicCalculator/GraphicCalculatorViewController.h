//
//  GraphicCalculatorViewController.h
//  GraphicCalculator
//
//  Created by nemo on 1/7/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphicCalculatorView.h"
#import "SplitViewBarButtonItemPresenter.h"

@protocol GraphicCalculatorControllerDataSource;

@interface GraphicCalculatorViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property (weak, nonatomic) IBOutlet GraphicCalculatorView *graphView;
@property (weak, nonatomic) IBOutlet id <GraphicCalculatorControllerDataSource> dataSource;
@end

@protocol GraphicCalculatorControllerDataSource
- (NSArray *) getProgram;
@end