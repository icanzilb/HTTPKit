////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPRequestSerializer.h
//
//  Created by Dalton Cherry on 5/7/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DCHTTPRequestSerializerErrorCode) {
    DCHTTPRequestSerializerErrorCodeInvalidParameter = 1,
};

@protocol DCHTTPRequestSerializerDelegate <NSObject>

/**
 This is used to serialize the request parameters and create a new NSURLRequest to send.
 This method is called when a request is going to be sent.
 @param: url is the url that should be used in the request creation.
 @param: HTTPMethod is the HTTP method (verb, e.g. GET,POST,PUT,etc) that should be used in the request creation.
 @param: parameters is the parameters that need to be serialized.
 @param: error should be set to a value if an error occurs with serializing the request.
 @return: This is the new NSURLRequest that will be used.
 */
-(NSURLRequest*)requestBySerializingUrl:(NSURL*)url
                                 method:(NSString*)HTTPMethod
                             parameters:(id)parameters
                                  error:(NSError * __autoreleasing *)error;

@end

///-------------------------------
/// @name Default request serializer
///-------------------------------

@interface DCHTTPRequestSerializer : NSObject<DCHTTPRequestSerializerDelegate>

/**
 Add or set a header value to send with the request.
 */
-(void)setValue:(id)value forHTTPHeaderField:(NSString*)key;

/**
 The string encoding used to serialize parameters. `NSUTF8StringEncoding` by default.
 */
@property (nonatomic, assign) NSStringEncoding stringEncoding;

/**
 Whether this request can use the device’s cellular radio (if present). `YES` by default.
 @see NSMutableURLRequest -setAllowsCellularAccess:
 */
@property (nonatomic, assign) BOOL allowsCellularAccess;

/**
 The cache policy of this request. `NSURLRequestUseProtocolCachePolicy` by default.
 @see NSMutableURLRequest -setCachePolicy:
 */
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

/**
 Whether this request should use the default cookie handling. `YES` by default.
 
 @see NSMutableURLRequest -setHTTPShouldHandleCookies:
 */
@property (nonatomic, assign) BOOL HTTPShouldHandleCookies;

/**
 Whether this request can continue transmitting data before receiving a response from an earlier transmission. `NO` by default
 @see NSMutableURLRequest -setHTTPShouldUsePipelining:
 */
@property (nonatomic, assign) BOOL HTTPShouldUsePipelining;

/**
 The network service type for this request. `NSURLNetworkServiceTypeDefault` by default.
 @see NSMutableURLRequest -setNetworkServiceType:
 */
@property (nonatomic, assign) NSURLRequestNetworkServiceType networkServiceType;

/**
 The timeout interval, in seconds, for this requests. The default timeout interval is 60 seconds.
 @see NSMutableURLRequest -setTimeoutInterval:
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@end

///-------------------------------
/// @name JSON request serializer
///-------------------------------

@interface DCJSONRequestSerializer : DCHTTPRequestSerializer

@end