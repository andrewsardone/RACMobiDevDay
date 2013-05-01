#import <AFNetworking/AFNetworking.h>

@class RACSignal;

@interface APIClient : AFHTTPClient

+ (instancetype)sharedClient;

- (RACSignal *)createAccountForEmail:(NSString *)email
                           firstName:(NSString *)firstName
                            lastName:(NSString *)lastName;

@end
