//
//  GraphicCalculatorViewController.m
//  GraphicCalculator
//
//  Created by nemo on 1/7/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "GraphicCalculatorViewController.h"
#import "GraphicCalculatorView.h"
#import "CalculatorBrain.h"

@interface GraphicCalculatorViewController () <GraphicCalculatorViewDataSource>
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property BOOL originSet;
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation GraphicCalculatorViewController

@synthesize graphView = _graphView;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;
@synthesize originSet = _originSet;
@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize defaults = _defaults;

- (NSUserDefaults *)defaults{
    if (!_defaults)
        _defaults = [NSUserDefaults standardUserDefaults];
    return _defaults;
}

- (CGPoint) origin
{
    NSLog(@"originSet: %d", [self.defaults boolForKey:@"originSet"]);
    if ([self.defaults boolForKey:@"originSet"] == NO){
        _origin = CGPointMake(self.graphView.bounds.size.width / 2,
                              self.graphView.bounds.size.height / 2);
        [self.defaults setBool:YES forKey:@"originSet"];
        [self.defaults setFloat:_origin.x forKey:@"originX"];
        [self.defaults setFloat:_origin.y forKey:@"originY"];
    }
    else{
        _origin = CGPointMake([self.defaults floatForKey:@"originX"],
                              [self.defaults floatForKey:@"originY"]);
    }
    
    return _origin;
}

- (void)setOrigin:(CGPoint)origin
{
    [self.defaults setFloat:origin.x forKey:@"originX"];
    [self.defaults setFloat:origin.y forKey:@"originY"];
    _origin = origin;
}

- (float) scale
{
    if ([self.defaults floatForKey:@"scale"] == 0)
        _scale = 1;
    else
        _scale = [self.defaults floatForKey:@"scale"];
    
    return _scale;
}

- (void)setScale:(float)scale
{
    _scale = scale;
    [self.defaults setFloat:scale forKey:@"scale"];
}

- (IBAction) resetPosition:(UITapGestureRecognizer *)sender{
    CGPoint location = [sender locationInView:self.graphView];
    self.origin = location;
}

- (IBAction) adjustPosition:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self.graphView];
    self.origin = CGPointMake(self.origin.x + translation.x,
                              self.origin.y + translation.y);
    [sender setTranslation:CGPointZero inView:self.graphView];
    NSLog(@"%g", translation.x);
    [self.graphView setNeedsDisplay];
}

- (IBAction) adjustScale:(UIPinchGestureRecognizer *)sender{
    NSLog(@"%g", sender.scale);
    self.scale *= sender.scale;
    sender.scale = 1;
    [self.graphView setNeedsDisplay];
}

- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem){
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}
- (void) setGraphView:(GraphicCalculatorView *)graphView
{
    self.navigationItem.title = [CalculatorBrain descriptionOfProgramFirstExpression:[self getProgram]];
    _graphView = graphView;
    graphView.dataSource = self;
}

- (NSArray *)getProgram
{
    return [self.dataSource getProgram];
}
@end
