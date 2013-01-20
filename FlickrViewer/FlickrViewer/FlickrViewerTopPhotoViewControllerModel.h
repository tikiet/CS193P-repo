//
//  FlickrViewerTopPhotoViewControllerModel.h
//  FlickrViewer
//
//  Created by nemo1 on 1/19/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrViewerTopPhotoViewControllerModel : NSObject
+ (NSData *)getFileData:(NSString *)name;
+ (void)storeFile:(NSString *)name withData:(NSData *)data;
@end
