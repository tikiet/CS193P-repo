//
//  TagTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/26/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "TagTableViewController.h"
#import "TagPhotosTableViewController.h"
#import "Tag.h"

@interface TagTableViewController ()

@end

@implementation TagTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((TagPhotosTableViewController *)(segue.destinationViewController)).tagName =
        [((UITableViewCell *)sender).textLabel.text lowercaseString];
    
    ((TagPhotosTableViewController *)(segue.destinationViewController)).vacationName =
        self.vacationName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Tag Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [tag.name capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [tag.belongsTo count]];
    
    return cell;
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    // sort by viewed times
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:self.document.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}
@end
