#import <AFNetworking/AFNetworking.h>

@class RACSignal;

@interface APIClient : NSObject

+ (instancetype)sharedClient;

- (RACSignal *)createAccountForEmail:(NSString *)email
                           firstName:(NSString *)firstName
                            lastName:(NSString *)lastName;

@end
