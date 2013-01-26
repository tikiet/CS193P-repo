//
//  VacationsTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/25/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "VacationsTableViewController.h"
#import "ChooseVacationTypeTableViewController.h"

@interface VacationsTableViewController ()
@property (nonatomic, strong) NSArray *files;
@end

@implementation VacationsTableViewController

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
    NSFileManager *manager = [NSFileManager defaultManager];
    self.files =
        [manager contentsOfDirectoryAtURL:[[manager URLsForDirectory:NSDocumentDirectory
                                                           inDomains:NSUserDomainMask] lastObject]
                        includingPropertiesForKeys:nil
                                           options:NSDirectoryEnumerationSkipsHiddenFiles
                                             error:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    NSURL *url = [self.files objectAtIndex:indexPath.row];
    cell.textLabel.text = [url lastPathComponent];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    ((ChooseVacationTypeTableViewController *)(segue.destinationViewController)).vacationName = ((UITableViewCell *)sender).textLabel.text;
}

@end
