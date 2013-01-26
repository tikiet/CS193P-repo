//
//  Photo+Create.h
//  FlickrViewer
//
//  Created by nemo1 on 1/25/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "Photo.h"

@interface Photo (Create)
+ (Photo *)photoWithFlickrInfo:(NSDictionary *)info
              inManagedContext:(NSManagedObjectContext *)context;
@end
