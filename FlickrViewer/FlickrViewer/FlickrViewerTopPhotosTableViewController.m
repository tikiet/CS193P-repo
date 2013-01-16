//
//  FlickrViewerTopPhotosTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "FlickrViewerTopPhotosTableViewController.h"
#import "FlickrViewerTopPhotoViewController.h"
#import "FlickrFetcher.h"

@interface FlickrViewerTopPhotosTableViewController () @property (nonatomic, strong) NSArray *topPhotos;
@end

@implementation FlickrViewerTopPhotosTableViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((FlickrViewerTopPhotoViewController *)(segue.destinationViewController)).photo = [self.topPhotos objectAtIndex:[self.tableView indexPathForCell:sender].row];
    ((FlickrViewerTopPhotoViewController *)(segue.destinationViewController)).navigationItem.title = ((UITableViewCell *)sender).textLabel.text;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.topPhotos = [FlickrFetcher photosInPlace:self.place maxResults:50];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Photos Table Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *photo = [self.topPhotos objectAtIndex:indexPath.row];
    NSString *title = [photo valueForKey:@"title"];
    NSString *description = [photo valueForKeyPath:@"description._content"];
    
    
    if ( [title isEqualToString:@""] && [description isEqualToString:@""]){
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text = @"";
    }
    else if( [title isEqualToString:@""]){
        cell.textLabel.text = description;
        cell.detailTextLabel.text = @"";
    }
    else{
        cell.textLabel.text = title;
        cell.detailTextLabel.text = description;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
