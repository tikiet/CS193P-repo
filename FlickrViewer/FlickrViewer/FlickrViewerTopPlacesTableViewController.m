//
//  FlickrViewerTopPlacesTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "FlickrViewerTopPlacesTableViewController.h"
#import "FlickrViewerTopPhotosTableViewController.h"
#import "FlickrFetcher.h"

@interface FlickrViewerTopPlacesTableViewController ()
@property (nonatomic, strong) NSArray *topPlaces;
@property (nonatomic, strong) NSMutableDictionary *groupedTopPlaces;
@property (nonatomic, strong) NSMutableArray *groupedTopPlacesNames;
@end

@implementation FlickrViewerTopPlacesTableViewController

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
    self.topPlaces = [FlickrFetcher topPlaces];
    self.groupedTopPlaces = [[NSMutableDictionary alloc] init];
    self.groupedTopPlacesNames = [[NSMutableArray alloc] init];
    
    for (NSDictionary *place in self.topPlaces){
        NSString *placeName = [place objectForKey:@"_content"];
        NSArray *placeNameArray = [placeName componentsSeparatedByString:@", "];
        NSString *country = [placeNameArray lastObject];
        
        NSMutableArray *group = [self.groupedTopPlaces objectForKey:country];
        if(group == nil)
            group = [[NSMutableArray alloc] init];
        
        [group addObject:place];
        if (![self.groupedTopPlacesNames containsObject:country])
            [self.groupedTopPlacesNames addObject:country];
        [self.groupedTopPlaces setObject:group forKey:country];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((FlickrViewerTopPhotosTableViewController *)(segue.destinationViewController)).place =
    [self.groupedTopPlaces objectForKey:self.groupedTopPlacesNames[[self.tableView indexPathForCell:sender].section]][[self.tableView indexPathForCell:sender].row];
//    [self.topPlaces objectAtIndex:[self.tableView indexPathForCell:sender].row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%d", [self.groupedTopPlacesNames count]);
    return [self.groupedTopPlacesNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.groupedTopPlaces objectForKey:self.groupedTopPlacesNames[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Place Table Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *place = [self.groupedTopPlaces objectForKey:self.groupedTopPlacesNames[indexPath.section]][indexPath.row];
    NSString *placeName = [place objectForKey:@"_content"]; 
    NSArray *placeNameArray = [placeName componentsSeparatedByString:@", "];
    
    cell.textLabel.text = [placeNameArray objectAtIndex:0];
    cell.detailTextLabel.text = [placeName substringFromIndex:([[placeNameArray objectAtIndex:0]length] + 2)];
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.groupedTopPlacesNames[section];
}

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
