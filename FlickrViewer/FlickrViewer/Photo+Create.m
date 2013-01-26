//
//  Photo+Create.m
//  FlickrViewer
//
//  Created by nemo1 on 1/25/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "Photo+Create.h"
#import "Place+Create.h"
#import "Tag+Create.h"
#import "FlickrFetcher.h"

@implementation Photo (Create)
+ (Photo *)photoWithFlickrInfo:(NSDictionary *)info
              inManagedContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [info objectForKey:FLICKR_PHOTO_ID]];
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    if (!matches || ([matches count] > 1)){
        // error
    } else if ([matches count] == 0){
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [info objectForKey:FLICKR_PHOTO_ID];
        photo.name = [info objectForKey:FLICKR_PHOTO_TITLE];
        photo.url = [[FlickrFetcher urlForPhoto:info format:FlickrPhotoFormatLarge] absoluteString];
        photo.time = [NSDate date];
        photo.place = [Place placeWithFlickrInfo:info inManagedContext:context];
        photo.photo = [NSPropertyListSerialization dataFromPropertyList:info format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil];
        
        NSArray *tagArray = [[info objectForKey:FLICKR_TAGS] componentsSeparatedByString:@" "];
        for (NSString *tagString in tagArray){
            if ([tagString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@":"]].location == NSNotFound){
                [photo addTagsObject:[Tag tagWithName:tagString inManagedContext:context]];
            }
        }
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}
@end
