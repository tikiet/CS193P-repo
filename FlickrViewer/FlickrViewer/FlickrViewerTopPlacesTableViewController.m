//
//  FlickrViewerTopPlacesTableViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/12/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "FlickrViewerTopPlacesTableViewController.h"
#import "FlickrViewerTopPhotosTableViewController.h"
#import "FlickrViewerTopPhotoViewController.h"
#import "FlickrFetcher.h"
#import "FlickrViewerMapViewController.h"
#import "FlickrViewerAnnotation.h"

@interface FlickrViewerTopPlacesTableViewController () <FlickrViewerMapViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *viewInMapBarButton;
@property (nonatomic, strong) NSArray *topPlaces;
@property (nonatomic, strong) NSMutableDictionary *groupedTopPlaces;
@property (nonatomic, strong) NSMutableArray *groupedTopPlacesNames;
@end

@implementation FlickrViewerTopPlacesTableViewController
- (NSArray *)getAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    [self.topPlaces enumerateObjectsUsingBlock:^(NSDictionary *place, NSUInteger index, BOOL *stop){
        FlickrViewerAnnotation *annotation = [[FlickrViewerAnnotation alloc]
          initWithLocation:CLLocationCoordinate2DMake(
              [[place objectForKey:FLICKR_LATITUDE] doubleValue],
              [[place objectForKey:FLICKR_LONGITUDE] doubleValue])
          title:[[place objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "][0]
          subtitle:@""
          pinColor:MKPinAnnotationColorRed];
        annotation.tag = place;
        [annotations addObject:annotation];
    }];
    return annotations;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView =
    (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    if (!annotationView){
        annotationView =
            [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView =
            [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    annotationView.pinColor = ((FlickrViewerAnnotation *)annotation).pinColor;
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)delegatePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((FlickrViewerTopPhotosTableViewController *)(segue.destinationViewController)).place =
    ((FlickrViewerAnnotation *)(((MKAnnotationView *)sender).annotation)).tag;
    
    ((FlickrViewerTopPhotosTableViewController *)(segue.destinationViewController)).navigationItem.title =
    ((FlickrViewerAnnotation *)(((MKAnnotationView *)sender).annotation)).title;
}

- (void)controller:(UIViewController *)controller mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [controller performSegueWithIdentifier:@"Map Of Places" sender:view];
}

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    [[self navigationItem] setRightBarButtonItem:barButton];
    [indicator startAnimating];
    indicator.hidesWhenStopped = YES;
    
    dispatch_queue_t downloadTopPlaces = dispatch_queue_create("download top places", NULL);
    dispatch_async(downloadTopPlaces, ^{
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [indicator stopAnimating];
            [[self navigationItem] setRightBarButtonItem:self.viewInMapBarButton];

        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Top Photos Of Place"]){
        ((FlickrViewerTopPhotosTableViewController *)(segue.destinationViewController)).place =
        [self.groupedTopPlaces objectForKey:self.groupedTopPlacesNames[[self.tableView indexPathForCell:sender].section]][[self.tableView indexPathForCell:sender].row];
    }
    else if ([segue.identifier isEqualToString:@"Map Of Places"]){
        ((FlickrViewerMapViewController *)(segue.destinationViewController)).delegate = self;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.groupedTopPlacesNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.groupedTopPlaces objectForKey:self.groupedTopPlacesNames[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Top Place Table Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *place = [self.groupedTopPlaces objectForKey:self.groupedTopPlacesNames[indexPath.section]][indexPath.row];
    NSString *placeName = [place objectForKey:@"_content"]; 
    NSArray *placeNameArray = [placeName componentsSeparatedByString:@", "];
    
    cell.textLabel.text = [placeNameArray objectAtIndex:0];
    cell.detailTextLabel.text = [placeName substringFromIndex:([[placeNameArray objectAtIndex:0]length] + 2)];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.groupedTopPlacesNames[section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
