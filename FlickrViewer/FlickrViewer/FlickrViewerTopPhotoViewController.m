//
//  FlickrViewerTopPhotoViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FlickrViewerTopPhotoViewController.h"
#import "FlickrViewerTopPhotoViewControllerModel.h"
#import "FlickrFetcher.h"
#import "VacationHelper.h"
#import "Photo+Create.h"

#define FLICKER_VIEWER_RECENT_PHOTOS @"FlickrViewer.recentPhotos"
#define VISIT_BUTTON_VISIT @"Visit"
#define VISIT_BUTTON_UNVISIT @"Unvisit"

@interface FlickrViewerTopPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UIPopoverController *masterPopOverController;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *visitButton;
@end

@implementation FlickrViewerTopPhotoViewController

- (IBAction)visitButtonTapped:(id)sender {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [self.photo objectForKey:FLICKR_PHOTO_ID]];
    NSArray *matches = [[VacationHelper currentContext] executeFetchRequest:request error:nil];
    
    if (!matches || ([matches count] > 1)){
        NSLog(@"error");
    } else if ([matches count] == 0){
        [Photo photoWithFlickrInfo:self.photo inManagedContext:[VacationHelper currentContext]];
        self.visitButton.title = VISIT_BUTTON_UNVISIT;
    } else {
        [[VacationHelper currentContext] deleteObject:[matches lastObject]];
        self.visitButton.title = VISIT_BUTTON_VISIT;
    }
    
    [[VacationHelper currentDocument]
            saveToURL:[VacationHelper currentDocument].fileURL
     forSaveOperation: UIDocumentSaveForOverwriting
    completionHandler:^(BOOL success){
    // wtf
    }];
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc{
    barButtonItem.title = @"Master";
    
    self.toolbar.items = [NSArray arrayWithObject:barButtonItem];
    self.masterPopOverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopOverController = nil;
    self.toolbar.items = nil;
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)setNewImage{
    [self.indicator startAnimating];
    self.indicator.hidden = NO;
    self.indicator.center = CGPointMake(CGRectGetMidX(self.imageView.bounds), CGRectGetMidY(self.imageView.bounds));
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("download flickr image", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *data = 
            [FlickrViewerTopPhotoViewControllerModel
             getFileData:[self.photo valueForKey:FLICKR_PHOTO_ID]];
        NSLog(@"data got");
        if (!data){
            data = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:self.photo                                    format:FlickrPhotoFormatSquare]];
            [FlickrViewerTopPhotoViewControllerModel storeFile:[self.photo valueForKey:FLICKR_PHOTO_ID] withData:data];
        }
        
        NSLog(@"set image");
        UIImage *topImage = [UIImage imageWithData:data];
        NSLog(@"%@", data);
        NSLog(@"%f %f", topImage.size.height,
              topImage.size.width);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"set image view");
            NSLog(@"%f %f",
                  self.imageView.frame.size.height,
                  self.imageView.frame.size.width);
            self.imageView.image = topImage;
            self.scrollView.contentSize = CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height);
            self.imageView.frame = CGRectMake(0,0,self.imageView.image.size.width, self.imageView.image.size.height);
            
            float x, y;
            float ratio = self.scrollView.bounds.size.height / self.scrollView.bounds.size.width;
            if (self.imageView.bounds.size.width * ratio > self.imageView.bounds.size.height ){
                y = self.imageView.bounds.size.height;
                x = y / ratio;
            }
            else{
                x = self.imageView.bounds.size.width;
                y = x * ratio;
            }
            [self.scrollView zoomToRect:CGRectMake(0, 0, x, y) animated:YES];
            [self.indicator stopAnimating];
            self.indicator.hidden = YES;
            [self.imageView setNeedsDisplay];
        });
        
        if (self.photo) {
            NSUserDefaults *recentPhotos = [NSUserDefaults standardUserDefaults];
            NSMutableArray *recentPhotosArray = [[recentPhotos objectForKey:FLICKER_VIEWER_RECENT_PHOTOS] mutableCopy];
            if (recentPhotosArray == nil)
                recentPhotosArray = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < [recentPhotosArray count]; i++){
                if ([recentPhotosArray[i] valueForKey:@"id"] == [self.photo valueForKey:@"id"]){
                    [recentPhotosArray removeObject:recentPhotosArray[i]];
                    break;
                }
            }
            
            [recentPhotosArray insertObject:self.photo atIndex:0];
            if ([recentPhotosArray count] > 20)
                [recentPhotosArray removeLastObject];
            
            [recentPhotos setObject:recentPhotosArray forKey:FLICKER_VIEWER_RECENT_PHOTOS];
                [recentPhotos synchronize];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.photo)
        return;
    [self setNewImage];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [self.photo objectForKey:FLICKR_PHOTO_ID]];
    NSArray *matches = [[VacationHelper currentContext] executeFetchRequest:request error:nil];
    
    if (!matches || ([matches count] > 1)){
        NSLog(@"error");
    } else if ([matches count] == 0){
        self.visitButton.title =VISIT_BUTTON_VISIT;
    } else {
        self.visitButton.title = VISIT_BUTTON_UNVISIT;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    if ([self splitViewController]){
        NSLog(@"set split view controller delegate");
        [self splitViewController].delegate = self;
    }
}

@end
