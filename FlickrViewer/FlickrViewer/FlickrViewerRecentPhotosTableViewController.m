//
//  FlickrViewerRecentPhotosTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "FlickrViewerRecentPhotosTableViewController.h"
#import "FlickrViewerTopPhotoViewController.h"
#define FLICKER_VIEWER_RECENT_PHOTOS @"FlickrViewer.recentPhotos"

@interface FlickrViewerRecentPhotosTableViewController ()
@property (nonatomic, strong) NSArray *recentPhotoArray;
@end

@implementation FlickrViewerRecentPhotosTableViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((FlickrViewerTopPhotoViewController *)(segue.destinationViewController)).photo = [self.recentPhotoArray objectAtIndex:[self.tableView indexPathForCell:sender].row];
    ((FlickrViewerTopPhotoViewController *)(segue.destinationViewController)).navigationItem.title = ((UITableViewCell *)sender).textLabel.text;
}

- (NSArray *)recentPhotoArray
{
    NSUserDefaults *recentPhotos = [NSUserDefaults standardUserDefaults];
    return [recentPhotos objectForKey:FLICKER_VIEWER_RECENT_PHOTOS];
}

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
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recentPhotoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Recent Photo Table Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *photo = [self.recentPhotoArray objectAtIndex:indexPath.row];
    
    NSString *title = [photo objectForKey:@"title"];
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

@end
