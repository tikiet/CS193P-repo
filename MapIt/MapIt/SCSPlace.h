//
//  SCSPlace.h
//  MapIt
//
//  Created by nemo1 on 1/16/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SCSPlace : NSObject <MKAnnotation>
@property (nonatomic, readonly) MKPinAnnotationColor pinColor;
- (id)initWithLocation:(CLLocationCoordinate2D)coordinate
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
              pinColor:(MKPinAnnotationColor)pinColor;
@end
