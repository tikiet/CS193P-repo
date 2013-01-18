//
//  SCSPlacesOfInterest.h
//  MapIt
//
//  Created by nemo1 on 1/16/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class SCSPlace;

@interface SCSPlacesOfInterest : NSObject
@property (strong, nonatomic, readonly) NSMutableArray *annotations;
- (CLLocationCoordinate2D) centerOfMap;
- (MKPolyline *) happyTrail;
- (SCSPlace *)annotationForLocation:(CLLocationCoordinate2D)coordinate title:(NSString *)title;
@end
