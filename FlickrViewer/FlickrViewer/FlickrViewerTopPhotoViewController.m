//
//  FlickrViewerTopPhotoViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "FlickrViewerTopPhotoViewController.h"
#import "FlickrFetcher.h"

#define FLICKER_VIEWER_RECENT_PHOTOS @"FlickrViewer.recentPhotos"

@interface FlickrViewerTopPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation FlickrViewerTopPhotoViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSData *data = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:self.photo
                                                                     format:FlickrPhotoFormatLarge]];
    UIImage *topImage = [UIImage imageWithData:data];
    
    self.imageView.image = topImage;
    self.scrollView.contentSize = CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height);
    self.imageView.frame = CGRectMake(0,0,self.imageView.image.size.width, self.imageView.image.size.height);
    
    float ratio, x, y;
    
    /*
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)){
        NSLog(@"hi");
        NSLog(@"imageview %f %f", self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        
        ratio = self.scrollView.bounds.size.height / self.scrollView.bounds.size.width;
        if (self.imageView.bounds.size.height * ratio > self.imageView.bounds.size.width){
            NSLog(@"first");
            x = self.imageView.frame.size.width;
            y = x / ratio;
        }
        else{
            NSLog(@"second");
            y = self.imageView.frame.size.height;
            x = y * ratio;
        }
        
        [self.scrollView zoomToRect:CGRectMake(0, 0, y, x) animated:YES];
    }
    else{*/
        ratio = self.scrollView.bounds.size.height / self.scrollView.bounds.size.width;
        if (self.imageView.bounds.size.width * ratio > self.imageView.bounds.size.height ){
            y = self.imageView.bounds.size.height;
            x = y / ratio;
        }
        else{
            x = self.imageView.bounds.size.width;
            y = x * ratio;
        }
        
        [self.scrollView zoomToRect:CGRectMake(0, 0, x, y) animated:YES];
   // }
    
    NSLog(@"%f %f", self.imageView.frame.size.width, self.imageView.frame.size.height);
    
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

@end
