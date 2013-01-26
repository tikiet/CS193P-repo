//
//  Tag+Create.h
//  FlickrViewer
//
//  Created by nemo1 on 1/26/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)
+ (Tag *)tagWithName:(NSString *)name
    inManagedContext:(NSManagedObjectContext *)context;
@end
