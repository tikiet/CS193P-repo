//
//  FlickrViewerTopPhotosTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "FlickrViewerTopPhotosTableViewController.h"
#import "FlickrViewerTopPhotoViewController.h"
#import "FlickrViewerMapViewController.h"
#import "FlickrFetcher.h"
#import "FlickrViewerMapViewController.h"
#import "FlickrViewerAnnotation.h"

@interface FlickrViewerTopPhotosTableViewController () <FlickrViewerMapViewDelegate>
@property (nonatomic, strong) NSArray *topPhotos;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *viewInMapBarButton;
@end

@implementation FlickrViewerTopPhotosTableViewController

- (NSArray *)getAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    [self.topPhotos enumerateObjectsUsingBlock:^(NSDictionary *photo, NSUInteger index, BOOL *stop){
        FlickrViewerAnnotation *annotation = [[FlickrViewerAnnotation alloc]
                                              initWithLocation:CLLocationCoordinate2DMake([[photo objectForKey:FLICKR_LATITUDE] doubleValue],[[photo objectForKey:FLICKR_LONGITUDE] doubleValue])
                                              title:[photo objectForKey:FLICKR_PHOTO_TITLE]
                                              subtitle:[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]
                                              pinColor:MKPinAnnotationColorRed];
        annotation.tag = photo;
        [annotations addObject:annotation];
    }];
    return annotations;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKAnnotationView *backup = view;
    dispatch_queue_t downloadThumbnail = dispatch_queue_create("download thumbnail", NULL);
    dispatch_async(downloadThumbnail, ^{
        NSData *data = [NSData dataWithContentsOfURL:[FlickrFetcher
                                                      urlForPhoto:((FlickrViewerAnnotation *)(view.annotation)).tag
                                                      format:FlickrPhotoFormatSquare]];
        UIImage *image = [UIImage imageWithData:data];
        
        if (view == backup){
            dispatch_async(dispatch_get_main_queue(), ^{
                [((UIImageView *)(view.leftCalloutAccessoryView)) setImage:image];
                view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            });
        }
    });
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView =
    (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    if (!annotationView){
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        annotationView.canShowCallout = YES;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,31,31)];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    annotationView.pinColor = ((FlickrViewerAnnotation *)annotation).pinColor;
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    annotationView.annotation = annotation;
    [((UIImageView *)(annotationView.leftCalloutAccessoryView)) setImage:nil];
    return annotationView;
}

- (void)delegatePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((FlickrViewerTopPhotoViewController *)(segue.destinationViewController)).photo =
    ((FlickrViewerAnnotation *)(((MKAnnotationView *)sender).annotation)).tag;
    
    ((FlickrViewerTopPhotoViewController *)(segue.destinationViewController)).navigationItem.title =
    ((FlickrViewerAnnotation *)(((MKAnnotationView *)sender).annotation)).title;
}

- (void)controller:(UIViewController *)controller mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if (![self splitViewController]){
        [controller performSegueWithIdentifier:@"View Top Photo" sender:view];
    }
    else{
        NSLog(@"%@", ((FlickrViewerAnnotation *)((MKAnnotationView *)view).annotation).tag);
        ((FlickrViewerTopPhotoViewController *)([[self splitViewController].viewControllers lastObject])).photo =
            ((FlickrViewerAnnotation *)((MKAnnotationView *)view).annotation).tag;
        [((FlickrViewerTopPhotoViewController *)([[self splitViewController].viewControllers lastObject])) setNewImage];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Map of place"]){
        ((FlickrViewerMapViewController *)(segue.destinationViewController)).delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"View Top Photo"]){
        ((FlickrViewerTopPhotoViewController *)(segue.destinationViewController)).photo = [self.topPhotos objectAtIndex:[self.tableView indexPathForCell:sender].row];
        ((FlickrViewerTopPhotoViewController *)(segue.destinationViewController)).navigationItem.title = ((UITableViewCell *)sender).textLabel.text;
    }
}

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIActivityIndicatorView *indicator =
        [[UIActivityIndicatorView alloc]
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    [[self navigationItem] setRightBarButtonItem:barButton];
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    
    dispatch_queue_t downloadPhotos = dispatch_queue_create("download top photos", NULL);
    
    dispatch_async(downloadPhotos, ^{
        self.topPhotos = [FlickrFetcher photosInPlace:self.place maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [indicator stopAnimating];
            [[self navigationItem] setRightBarButtonItem:self.viewInMapBarButton];
        });
    });
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ((FlickrViewerTopPhotoViewController *)([[self splitViewController].viewControllers lastObject])).photo =
    
        [self.topPhotos objectAtIndex:indexPath.row];
    [((FlickrViewerTopPhotoViewController *)([[self splitViewController].viewControllers lastObject])) setNewImage];
}

@end
