//
//  FlickrViewerAnnotation.m
//  FlickrViewer
//
//  Created by nemo1 on 1/18/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "FlickrViewerAnnotation.h"

@interface FlickrViewerAnnotation()
@property (nonatomic, readwrite) MKPinAnnotationColor pinColor;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@end

@implementation FlickrViewerAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coordinate
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
              pinColor:(MKPinAnnotationColor)pinColor
{
    self = [super init];
    if (self){
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
        _pinColor = pinColor;
    }
    return self;
}

- (id) init{
    return [self initWithLocation:CLLocationCoordinate2DMake(0, 0)
                            title:nil
                         subtitle:nil
                         pinColor:0];
}
@end
