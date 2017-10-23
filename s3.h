#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol UploadProtocol
- (void)uploadFile:(NSString*)filePath completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
- (void)printFile:(NSString*)filePath;
@end

@interface S3 : NSObject<UploadProtocol>
{}
@end
