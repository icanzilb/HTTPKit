////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPTask.h
//
//  Created by Dalton Cherry on 5/5/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCTask.h"
#import "DCHTTPRequestSerializer.h"
#import "DCHTTPResponseSerializer.h"

typedef void (^DCHTTPTaskProgress)(CGFloat progress);

@interface DCHTTPResponse : NSObject

/**
 The response headers when the request finishes.
 */
@property(nonatomic,strong)NSDictionary *headers;

/**
 The response object that is returned after the responseSerializer has serialized/parsed it.
 */
@property(nonatomic,strong)id responseObject;

@end

@interface DCHTTPTask : DCTask<NSURLSessionDelegate>

/**
 The url you want to load.
 */
@property(nonatomic,copy)NSString *url;

/**
 The parameters you want to send with the request.
 */
@property(nonatomic,strong)NSDictionary *parameters;

/**
 The serializer you want to encode the parameters with. Default is to use the standard DCHTTPRequestSerializer.
 */
@property(nonatomic,strong)DCHTTPRequestSerializer *requestSerializer;

/**
 The serializer you want to encode the response with (JSON,XML,etc). Default is nil, which means a NSData object will be returned.
 */
@property(nonatomic,strong)id<DCHTTPResponseSerializerDelegate> responseSerializer;

/**
 The HTTP method for this request. The default is GET.
 @see NSMutableURLRequest -setHTTPMethod:
 */
@property (nonatomic, copy) NSString *HTTPMethod;

/**
 This BOOL controls if  the request needs to be done as a background downloaded.
 This ONLY needs to be set if the desired is for the request to be in the background.
 The request must be a download.
 */
@property(nonatomic,assign,getter = isDownload)BOOL download;

/**
 This BOOL controls if  the request needs to be done as a background upload.
 This ONLY needs to be set if the desired is for the request to be in the background.
 The request must be a upload.
 */
@property(nonatomic,assign,getter = isUpload)BOOL upload;

/**
 This can be used to allow different serializer for different content types. 
 This differs from the responseSerializer property as it is used only for the content type defined, 
 where the responseSerializer property is use for all responses not specified in this method.
 @param: responseSerializer is responseSerializer object to use for the response serializing/parsing of the contentType choosen. 
 @param: contentType is the content type to map to the response Serializer (e.g application/json to DCJSONResponseSerializer).
 */
-(void)setResponseSerializer:(id<DCHTTPResponseSerializerDelegate>)responseSerializer forContentType:(NSString*)contentType;

/**
 This is used to get called back on a download/upload progress.
 The progress return is between 0 and 1, just like NSProgressView or UIProgressView (your welcome).
 @param: block is the progress block to add.
 */
-(void)setProgress:(DCHTTPTaskProgress)block;

/**
 Factory method to create a request with HTTPMethod of GET.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)GET:(NSString*)url;

/**
 Factory method to create a request with HTTPMethod of GET.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)GET:(NSString*)url parameters:(NSDictionary*)parameters;

/**
 Factory method to create a request with HTTPMethod of HEAD.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)HEAD:(NSString*)url;

/**
 Factory method to create a request with HTTPMethod of HEAD.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)HEAD:(NSString*)url parameters:(NSDictionary*)parameters;

/**
 Factory method to create a request with HTTPMethod of DELETE.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)DELETE:(NSString*)url parameters:(NSDictionary*)parameters;

/**
 Factory method to create a request with HTTPMethod of POST.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)POST:(NSString*)url parameters:(NSDictionary*)parameters;

/**
 Factory method to create a request with HTTPMethod of PUT.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)PUT:(NSString*)url parameters:(NSDictionary*)parameters;

@end
