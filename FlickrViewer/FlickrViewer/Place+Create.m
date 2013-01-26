//
//  Place+Create.m
//  FlickrViewer
//
//  Created by nemo1 on 1/26/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "Place+Create.h"
#import "FlickrFetcher.h"

@implementation Place (Create)

+ (Place *)placeWithFlickrInfo:(NSDictionary *)info
              inManagedContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [info objectForKey:FLICKR_PHOTO_PLACE_NAME]];
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    if (!matches || ([matches count] > 1)){
        // error
    } else if ([matches count] == 0){
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = [info objectForKey:FLICKR_PHOTO_PLACE_NAME];
        place.create_time = [NSDate date];
    } else {
        place = [matches lastObject];
    }
    
    return place;
}
@end
