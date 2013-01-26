//
//  Place+Create.h
//  FlickrViewer
//
//  Created by nemo1 on 1/26/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "Place.h"

@interface Place (Create)
+ (Place *)placeWithFlickrInfo:(NSDictionary *)info
              inManagedContext:(NSManagedObjectContext *)context;
@end
