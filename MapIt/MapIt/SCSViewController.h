//
//  SCSViewController.h
//  MapIt
//
//  Created by nemo1 on 1/16/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SCSViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
