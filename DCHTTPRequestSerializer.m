////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPRequestSerializer.m
//
//  Created by Dalton Cherry on 5/7/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCHTTPRequestSerializer.h"
#import "DCHTTPUpload.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
//local class used to encode parameters
@interface QueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;
- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface DCHTTPRequestSerializer ()

@property(nonatomic,assign)DCHTTPRequestSerializerRequestType type;
@property(nonatomic,strong)NSSet *HTTPMethodsEncodingParametersInURI;
@property(nonatomic,strong)NSSet *HTTPMethodsUploadVerb;

@end

@implementation DCHTTPRequestSerializer

////////////////////////////////////////////////////////////////////////////////////////////////////
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.stringEncoding = NSUTF8StringEncoding;
        self.allowsCellularAccess = YES;
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        self.HTTPShouldHandleCookies = YES;
        self.HTTPShouldUsePipelining = NO;
        self.networkServiceType = NSURLNetworkServiceTypeDefault;
        self.timeoutInterval = 60;
        self.type = DCHTTPRequestSerializerRequestTypeNormal;
        self.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
        self.HTTPMethodsUploadVerb = [NSSet setWithObjects:@"PUT", @"POST", nil];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSURLRequest*)requestBySerializingUrl:(NSURL*)url
                                 method:(NSString*)HTTPMethod
                             parameters:(id)parameters
                                  error:(NSError * __autoreleasing *)error
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:self.cachePolicy
                                                       timeoutInterval:self.timeoutInterval];
    request.HTTPMethod = HTTPMethod;
    request.allowsCellularAccess = self.allowsCellularAccess;
    request.cachePolicy = self.cachePolicy;
    request.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies;
    request.HTTPShouldUsePipelining = self.HTTPShouldUsePipelining;
    request.timeoutInterval = self.timeoutInterval;
    request.networkServiceType = self.networkServiceType;
    BOOL isUpload = NO;
    for(id param in parameters)
    {
        if([param isKindOfClass:[DCHTTPUpload class]])
        {
            isUpload = YES;
            break;
        }
    }
    if(isUpload)
    {
        if(![self.HTTPMethodsUploadVerb containsObject:request.HTTPMethod])
        {
            *error = [self errorWithDetail:NSLocalizedString(@"File uploads must be preformed with a POST or PUT HTTPMethod.", nil)
                                      code:DCHTTPRequestSerializerErrorCodeInvalidParameter];
            return nil;
        }
        NSString *boundary = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
        //do multi form stuff....
        return request;
    }
    
    NSString *query = [[self class] queryStringFromParametersWithEncoding:parameters encoding:self.stringEncoding];
    if(![self.HTTPMethodsEncodingParametersInURI containsObject:request.HTTPMethod]) {
        request.URL = [NSURL URLWithString:[[request.URL absoluteString] stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", query]];
    } else {
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
        [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
    }
    return request;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(DCHTTPRequestSerializerRequestType)requestType
{
    return self.type;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSError*)errorWithDetail:(NSString*)detail code:(DCHTTPRequestSerializerErrorCode)code
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:detail forKey:NSLocalizedDescriptionKey];
    return [[NSError alloc] initWithDomain:NSLocalizedString(@"DCHTTPRequestSerializer", nil) code:code userInfo:details];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
//I borrowed this parameter encoding from the AFNetworking implementation (AFURLRequestSerialization.m).
//Thanks!!!
////////////////////////////////////////////////////////////////////////////////////////////////////
+(NSString*)queryStringFromParametersWithEncoding:(NSDictionary *)parameters encoding:(NSStringEncoding)stringEncoding
{
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for(QueryStringPair *pair in [[self class] queryStringPairsFromDictionary:parameters]) {
        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
    }
    return [mutablePairs componentsJoinedByString:@"&"];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(NSArray*)queryStringPairsFromDictionary:(NSDictionary*)dictionary
{
    return [[self class] queryStringPairsFromKey:nil andValue:dictionary];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(NSArray*)queryStringPairsFromKey:(NSString*)key andValue:(id)value
{
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]]) {
            id nestedValue = [dictionary objectForKey:nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:[[self class] queryStringPairsFromKey:(key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey)
                                                                                               andValue:nestedValue]];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:[[self class] queryStringPairsFromKey:[NSString stringWithFormat:@"%@[]", key] andValue:nestedValue]];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:[[self class] queryStringPairsFromKey:key andValue:obj]];
        }
    } else {
        [mutableQueryStringComponents addObject:[[QueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation QueryStringPair

static NSString * const kDCCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * DCPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string,
                                                                                  (__bridge CFStringRef)kAFCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kDCCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * DCPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL,
                                                                                  (__bridge CFStringRef)kDCCharactersToBeEscapedInQueryString,
                                                                                  CFStringConvertNSStringEncodingToEncoding(encoding));
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithField:(id)field value:(id)value
{
    self = [super init];
    if (self)
    {
        self.field = field;
        self.value = value;
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding
{
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return DCPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding);
    } else {
        return [NSString stringWithFormat:@"%@=%@", DCPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding),
                DCPercentEscapedQueryStringValueFromStringWithEncoding([self.value description], stringEncoding)];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end
