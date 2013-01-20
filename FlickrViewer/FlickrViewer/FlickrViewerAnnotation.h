//
//  FlickrViewerAnnotation.h
//  FlickrViewer
//
//  Created by nemo1 on 1/18/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FlickrViewerAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) MKPinAnnotationColor pinColor;
@property (nonatomic, weak) NSDictionary *tag;
- (id)initWithLocation:(CLLocationCoordinate2D)coordinate
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
              pinColor:(MKPinAnnotationColor)pinColor;
@end
