//
//  PlaceFetcherViewController.m
//  PlaceFetcher
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "PlaceFetcherViewController.h"
#import "FlickrFetcher.h"

@interface PlaceFetcherViewController ()

@end

@implementation PlaceFetcherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", [FlickrFetcher topPlaces]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
