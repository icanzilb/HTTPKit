////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPTaskManager.m
//
//  Created by Dalton Cherry on 5/9/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCHTTPTaskManager.h"

@interface DCHTTPTaskManager ()

@property(nonatomic,strong)NSMutableDictionary *serializers;
@property(nonatomic,strong)NSMutableDictionary *sharedParams;

@end

@implementation DCHTTPTaskManager

////////////////////////////////////////////////////////////////////////////////////////////////////
-(id)init
{
    if(self = [super init])
    {
        self.responseSerializer = [DCJSONResponseSerializer new];
        self.requestSerializer = [DCHTTPRequestSerializer new];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)addParameter:(id)value forKey:(NSString*)key
{
    if(!self.sharedParams)
        self.sharedParams = [NSMutableDictionary new];
    [self.sharedParams setObject:value forKey:key];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)removeParameter:(NSString*)key
{
    [self.sharedParams removeObjectForKey:key];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setResponseSerializer:(id<DCHTTPResponseSerializerDelegate>)responseSerializer forContentType:(NSString*)contentType
{
    if(!self.serializers)
        self.serializers = [NSMutableDictionary new];
    [self.serializers setObject:responseSerializer forKey:contentType];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(DCHTTPTask*)GET:(NSString*)resource
{
    return [self GET:resource parameters:nil];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(DCHTTPTask*)GET:(NSString*)resource parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [DCHTTPTask GET:[self createURL:resource] parameters:[self combineParameters:parameters]];
    [self configTask:task];
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(DCHTTPTask*)HEAD:(NSString*)resource
{
    return [self GET:resource parameters:nil];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(DCHTTPTask*)HEAD:(NSString*)resource parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [DCHTTPTask HEAD:[self createURL:resource] parameters:[self combineParameters:parameters]];
    [self configTask:task];
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(DCHTTPTask*)DELETE:(NSString*)resource parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [DCHTTPTask DELETE:[self createURL:resource] parameters:[self combineParameters:parameters]];
    [self configTask:task];
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(DCHTTPTask*)POST:(NSString*)resource parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [DCHTTPTask POST:[self createURL:resource] parameters:[self combineParameters:parameters]];
    [self configTask:task];
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(DCHTTPTask*)PUT:(NSString*)resource parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [DCHTTPTask PUT:[self createURL:resource] parameters:[self combineParameters:parameters]];
    [self configTask:task];
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString*)createURL:(NSString*)resource
{
    if(self.baseURL)
        return [self.baseURL stringByAppendingString:resource];
    return resource;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSDictionary*)combineParameters:(NSDictionary*)parameters
{
    NSInteger count = self.sharedParams.count+parameters.count;
    if(count == 0)
        return nil;
    NSMutableDictionary *collect = [NSMutableDictionary dictionaryWithCapacity:count];
    if(self.sharedParams)
        [collect addEntriesFromDictionary:self.sharedParams];
    if(parameters)
        [collect addEntriesFromDictionary:parameters];
    return collect;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)configTask:(DCHTTPTask*)task
{
    task.requestSerializer = self.requestSerializer;
    task.responseSerializer = self.responseSerializer;
    for(id key in self.serializers) {
        [task setResponseSerializer:self.serializers[key] forContentType:key];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end
