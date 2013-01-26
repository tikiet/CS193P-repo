//
//  ChooseVacationTypeTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/25/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "ChooseVacationTypeTableViewController.h"
#import "ItineraryTableViewController.h"
#import "TagTableViewController.h"

@implementation ChooseVacationTypeTableViewController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"[ChooseVacationTypeTableViewController] vacation name:%@", self.vacationName);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Itinerary"]){
        ((ItineraryTableViewController *)(segue.destinationViewController)).vacationName =
            self.vacationName;
    } else if ([segue.identifier isEqualToString:@"Show Tags"]){
        ((TagTableViewController *)(segue.destinationViewController)).vacationName =
            self.vacationName;
    }
}
@end
