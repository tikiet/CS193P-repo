//
//  VacationTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/25/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "VacationTableViewController.h"
#import "VacationHelper.h"

@interface VacationTableViewController ()
@end

@implementation VacationTableViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)setupFetchedResultsController
{
    // need to be subclassed
}

- (void)setupDocument{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]){
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            [self setupFetchedResultsController];
        }];
    }else if(self.document.documentState == UIDocumentStateClosed){
        [self.document openWithCompletionHandler:^(BOOL success){
            [self setupFetchedResultsController];
        }];
    }else if (self.document.documentState == UIDocumentStateNormal){
        [self setupFetchedResultsController];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.document = [VacationHelper sharedManagedDocumentForVacation:self.vacationName];
    [self setupDocument];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
