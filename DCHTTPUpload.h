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

/**
 This is a factory method to create an upload object off a file url.
 @param: fileURL is the url to the file you want to upload. It MUST be a file url.
 @return: A newly initialized DCHTTPUpload.
 */
+(DCHTTPUpload*)uploadWithFile:(NSURL*)fileURL;

/**
 This is a factory method to create an upload object off a data object in memory.
 @param: data is the data to upload.
 @param: fileName is the name of the file.
 @param: type is the mimeType of the data being uploaded.
 @return: A newly initialized DCHTTPUpload.
 */
+(DCHTTPUpload*)uploadWithData:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)type;

@end
