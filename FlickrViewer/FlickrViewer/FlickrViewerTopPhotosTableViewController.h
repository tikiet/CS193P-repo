//
//  FlickrViewerTopPhotosTableViewController.h
//  FlickrViewer
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrViewerTopPhotosTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) NSDictionary *place;
@end
