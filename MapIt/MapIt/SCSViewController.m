//
//  SCSViewController.m
//  MapIt
//
//  Created by nemo1 on 1/16/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "SCSViewController.h"
#import "SCSPlacesOfInterest.h"
#import "SCSPlace.h"

@interface SCSViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mapTitleField;
@property (nonatomic, strong) SCSPlacesOfInterest *places;
@property (nonatomic) CGPoint viewPoint;
@end

@implementation SCSViewController

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineView *lineView = [[MKPolylineView alloc] initWithPolyline:[self.places happyTrail]];
    lineView.strokeColor = [UIColor blueColor];
    lineView.lineDashPattern = @[@4, @6];
    lineView.lineWidth = 2;
    return lineView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]
                                           initWithAnnotation:annotation
                                              reuseIdentifier:@"pinView"];
    annotationView.pinColor = ((SCSPlace *)annotation).pinColor;
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    
    if (annotationView.pinColor == MKPinAnnotationColorPurple){
        annotationView.draggable = YES;
    }
    
    return annotationView;
}

- (SCSPlacesOfInterest *)places
{
    if (!_places){
        _places = [[SCSPlacesOfInterest alloc] init];
    }
    return _places;
}

- (IBAction)mapTapped:(UITapGestureRecognizer *)sender {
    self.viewPoint = [sender locationInView:self.mapView];
    self.mapTitleField.hidden = NO;
    [self.mapTitleField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CLLocationCoordinate2D mapPoint
        = [self.mapView convertPoint:self.viewPoint
                toCoordinateFromView:self.mapView];
    SCSPlace *place = [self.places annotationForLocation:mapPoint title:textField.text];
    [self.mapView addAnnotation:place];
    textField.hidden = YES;
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.places = [[SCSPlacesOfInterest alloc] init];
    self.mapView.region = MKCoordinateRegionMakeWithDistance([self.places centerOfMap], 500, 500);
    [self.mapView addAnnotations:self.places.annotations];
    [self.mapView addOverlay:[self.places happyTrail]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}@end
