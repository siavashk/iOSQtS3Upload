#import <UIKit/UIKit.h>


NSURLSessionUploadTask* createUploadTask(NSString* filename)
{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURL* url = [NSURL URLWithString:@"https://s3.ca-central-1.amazonaws.com/stage-ca"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    return [session uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:filename]
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
            {
                if (error)
                {
                    NSLog(@"error = %@", error);
                    return;
                }
                
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"result = %@", result);
            }];
}

int main(int argc, const char * argv[])
{
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];

    // Debug code
//    NSError *error;
//    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
//
//    if (error)
//        NSLog(@"Error reading file: %@", error.localizedDescription);
//
//    // maybe for debugging...
//    NSLog(@"contents: %@", fileContents);
//
//    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
//    NSLog(@"items = %d", [listArray count]);
     NSURLSessionUploadTask* task = createUploadTask(filePath);
     [task resume];
}
