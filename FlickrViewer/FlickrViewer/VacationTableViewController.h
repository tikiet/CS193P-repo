//
//  VacationTableViewController.h
//  FlickrViewer
//
//  Created by nemo1 on 1/25/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface VacationTableViewController : CoreDataTableViewController
@property (nonatomic, strong) NSString *vacationName;
@property (nonatomic, strong) UIManagedDocument *document;
- (void)setupFetchedResultsController;
@end
