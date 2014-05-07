////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPUpload.h
//
//  Created by Dalton Cherry on 5/7/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface DCHTTPUpload : NSObject

/**
  This is to specific the fileName.
 */
@property(nonatomic,copy)NSString *fileName;

/**
 This is to specific the mimeType.
 fileURLs will attempt an automatic lookup based on file extension
 */
@property(nonatomic,copy)NSString *mimeType;

/**
 This is to upload a file from memory
 */
@property(nonatomic,strong)NSData *data;

/**
 This is to upload a file from disk
 */
@property(nonatomic,strong)NSURL *fileURL;

@end
