//
//  FlickrViewerMapViewController.m
//  FlickrViewer
//
//  Created by nemo1 on 1/18/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "FlickrViewerMapViewController.h"
#import "FlickrViewerAnnotation.h"
#import "FlickrViewerTopPhotoViewController.h"

@interface FlickrViewerMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation FlickrViewerMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSArray *annotations = [self.delegate getAnnotations];
    CLLocationCoordinate2D coordinates[[annotations count]];
    for (int i = 0; i < [annotations count]; i++){
        coordinates[i] = ((FlickrViewerAnnotation *)annotations[i]).coordinate;
    }
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coordinates count:[annotations count]];
    MKCoordinateRegion region = MKCoordinateRegionForMapRect([polygon boundingMapRect]);
    region.span.latitudeDelta *= 1.1;
    region.span.longitudeDelta *= 1.1;
    [self.mapView setRegion:region];
    
    [self.mapView addAnnotations:[self.delegate getAnnotations]];
    self.mapView.delegate = self;
}

- (void)mapView:(MKMapView *)mapView
    didSelectAnnotationView:(MKAnnotationView *)view{
    [self.delegate mapView:mapView didSelectAnnotationView:view];
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control{
    [self.delegate controller:self mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self.delegate delegatePrepareForSegue:segue sender:sender];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation{
    return [self.delegate mapView:mapView viewForAnnotation:annotation];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
