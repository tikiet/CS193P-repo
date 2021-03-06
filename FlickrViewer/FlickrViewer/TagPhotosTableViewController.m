//
//  TagPhotosTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/26/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "TagPhotosTableViewController.h"
#import "FlickrViewerTopPhotoViewController.h"
#import "Tag.h"
#import "Photo.h"

@interface TagPhotosTableViewController ()

@end

@implementation TagPhotosTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    ((FlickrViewerTopPhotoViewController *)(segue.destinationViewController)).photo =
    (NSDictionary *)[NSPropertyListSerialization propertyListWithData:photo.photo
                                                              options:NSPropertyListImmutable
                                                               format:NULL
                                                                error:nil];

}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Tag Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.name;
    
    return cell;
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *tagRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    tagRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    tagRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", self.tagName];
    NSArray *matches = [self.document.managedObjectContext executeFetchRequest:tagRequest
                                                                         error:nil];
    Tag *tag = [matches lastObject];
                            
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                                                     ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"self IN %@", tag.belongsTo];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:self.document.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}
@end
