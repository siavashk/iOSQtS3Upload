#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

void printFileContents(NSString* filePath)
{
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    NSLog(@"contents: %@", fileContents);
    
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"items = %luld", (unsigned long)[listArray count]);
}

@protocol UploadProtocol
- (void)uploadFile:(NSURLSession*)session filePath:(NSString*)filePat completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
@end

@interface S3 : NSObject<UploadProtocol>
{}
@end

@implementation S3

- (void)uploadFile:(NSURLSession*)session filePath:(NSString*)filePath completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURL* url = [NSURL URLWithString:@"https://s3.ca-central-1.amazonaws.com/stage-ca"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:filePath] completionHandler:completionHandler];
    [task resume];
}

@end

int main(int argc, const char * argv[])
{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    
    dispatch_group_t group = dispatch_group_create();
    void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error)
        {
            NSLog(@"error = %@", error);
            return;
        }
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result = %@", result);
        dispatch_group_leave(group);
    };
    
    S3* s3 = [[S3 alloc] init];
    
    dispatch_group_enter(group);
    [s3 uploadFile:session filePath:filePath completionHandler:completionHandler];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}
