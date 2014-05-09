////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPUpload.m
//
//  Created by Dalton Cherry on 5/7/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCHTTPUpload.h"

@implementation DCHTTPUpload

////////////////////////////////////////////////////////////////////////////////////////////////////
static inline NSString * DCContentTypeForPathExtension(NSString *extension) {
#ifdef __UTTYPE__
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
#else
#pragma unused (extension)
    return @"application/octet-stream";
#endif
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString*)mimeType
{
    if(!_mimeType)
    {
        if(self.fileURL)
            _mimeType = DCContentTypeForPathExtension([self.fileURL pathExtension]);
        else
            _mimeType = @"application/octet-stream";
    }
    return _mimeType;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString*)fileName
{
    if(!_fileName)
    {
        if(self.fileURL)
            _fileName = [self.fileURL lastPathComponent];
    }
    return _fileName;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSData*)getData
{
    if(self.fileURL)
        return [NSData dataWithContentsOfURL:self.fileURL];
    return self.data;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPUpload*)uploadWithFile:(NSURL*)fileURL
{
    DCHTTPUpload *upload = [DCHTTPUpload new];
    upload.fileURL = fileURL;
    return upload;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPUpload*)uploadWithData:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)type
{
    DCHTTPUpload *upload = [DCHTTPUpload new];
    upload.data = data;
    upload.fileName = fileName;
    upload.mimeType = type;
    return upload;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end
