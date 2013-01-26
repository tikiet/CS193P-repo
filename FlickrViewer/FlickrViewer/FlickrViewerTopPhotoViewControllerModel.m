//
//  FlickrViewerTopPhotoViewControllerModel.m
//  FlickrViewer
//
//  Created by nemo1 on 1/19/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "FlickrViewerTopPhotoViewControllerModel.h"

#define FLICKR_VIEWER_CACHE_KEY @"cached.photo"
#define CACHED_DIR_NAME @"cache"

@interface FlickrViewerTopPhotoViewControllerModel()
+ (void)clearOldData;
@end

@implementation FlickrViewerTopPhotoViewControllerModel

+ (void)clearOldData{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSLog(@"clear old data");
    
    unsigned long long totalSize = 0;
    unsigned long long maxSize = 10*1024*1024;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentPhotos = [defaults objectForKey:FLICKR_VIEWER_CACHE_KEY];
    NSMutableArray *remained = [[NSMutableArray alloc] init];
    
    NSLog(@"recent photo: %@", recentPhotos);
    bool full = NO;
    for (int i = 0; i < [recentPhotos count]; i ++){
        if (!full){
            NSDictionary *entry = recentPhotos[i];
            if (totalSize + [[entry objectForKey:@"size"] unsignedLongLongValue] > maxSize){
                full = YES;
            }
            else{
                NSLog(@"not full, current size: %lld/%lld", totalSize,maxSize);
                totalSize += [[entry objectForKey:@"size"] unsignedLongLongValue];
                [remained addObject:entry];
            }
        }
        
        if (full){
            NSDictionary *entry = recentPhotos[i];
            NSString *name = [entry objectForKey:@"name"];
            NSLog(@"cache full, delete %@", name);
            if ([manager removeItemAtPath:name error:nil]){
                NSLog(@"delete succeed");
            }
            else{
                NSLog(@"delete failed");
            }
        }
    }
    
    [defaults setObject:remained forKey:FLICKR_VIEWER_CACHE_KEY];
    [defaults synchronize];
}

+ (NSData *)getFileData:(NSString *)name{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *dir = [path stringByAppendingPathComponent:CACHED_DIR_NAME];
    NSString *filePath = [dir stringByAppendingPathComponent:name];
    
    NSLog(@"get file at %@", filePath);
    NSData *data = [manager contentsAtPath:filePath];
    
    if (data)
        NSLog(@"success");
    else
        NSLog(@"failed");
    return data;
}

+ (void)storeFile:(NSString *)name withData:(NSData *)data{
    [self clearOldData];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *dir = [path stringByAppendingPathComponent:CACHED_DIR_NAME];
    
    if (![manager fileExistsAtPath:dir]){
        NSLog(@"create dir");
        if ([manager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil])
            NSLog(@"success");
        else
            NSLog(@"failed");
    }
    
    NSString *filePath = [dir stringByAppendingPathComponent:name];
    NSLog(@"store file at %@", filePath);
    if ([manager createFileAtPath:filePath contents:data attributes:nil]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *recentPhotos = [[defaults objectForKey:FLICKR_VIEWER_CACHE_KEY] mutableCopy];
        if (!recentPhotos)
            recentPhotos = [[NSMutableArray alloc] init];
        NSMutableDictionary *cacheEntry = [[NSMutableDictionary alloc] init];
        [cacheEntry setObject:filePath
                       forKey:@"name"];
        [cacheEntry setObject:[[manager attributesOfItemAtPath:filePath
                                                         error:nil]
                               objectForKey:NSFileSize]
                       forKey:@"size"];
        [recentPhotos insertObject:cacheEntry atIndex:0];
        [defaults setObject:recentPhotos forKey:FLICKR_VIEWER_CACHE_KEY];
        [defaults synchronize];
        NSLog(@"success");
    }
    else
        NSLog(@"failed");
}
@end
