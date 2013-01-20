//
//  FlickrViewerTopPhotoViewController.h
//  FlickrViewer
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrViewerTopPhotoViewController : UIViewController <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic, weak) NSDictionary *photo;
- (void) setNewImage;
@end
