//
//  FlickrViewerMapViewController.h
//  FlickrViewer
//
//  Created by nemo1 on 1/18/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol FlickrViewerMapViewDelegate <NSObject>
- (NSArray *)getAnnotations;
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation;
- (void)delegatePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
-  (void)controller:(UIViewController *)controller mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
@end
@interface FlickrViewerMapViewController : UIViewController
@property (nonatomic, strong) id < FlickrViewerMapViewDelegate> delegate;
@end
