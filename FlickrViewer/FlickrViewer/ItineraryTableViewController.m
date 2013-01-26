//
//  ItineraryTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/25/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "ItineraryTableViewController.h"
#import "ItineraryPhotosTableViewController.h"
#import "Place.h"

@interface ItineraryTableViewController ()

@end

@implementation ItineraryTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    ((ItineraryPhotosTableViewController *)(segue.destinationViewController)).placeName =
    ((UITableViewCell *)sender).textLabel.text;
    
    ((ItineraryPhotosTableViewController *)(segue.destinationViewController)).vacationName = self.vacationName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Itinerary Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text =
        [NSString stringWithFormat:@"%d photos", [place.photos count]];
    
    return cell;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"create_time" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:self.document.managedObjectContext
                                       sectionNameKeyPath:nil
                                                cacheName:nil];
}

@end
