//
//  BBDevice.m
//  Axalfred
//
//  Created by Paul Antonelli on 22/05/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "NXDevice.h"

#import "FXKeychain.h"

#import <CommonCrypto/CommonDigest.h>

// plateformString
#include <sys/types.h>
#include <sys/sysctl.h>

// encrypted
#import <dlfcn.h>
#import <mach-o/dyld.h>

static NSString *const kKeychainServiceName = @"NX_SERVICE_NAME";
static NSString *const kKeychainAccountName = @"NX_ACCOUNT_NAME";

// CRACK
int main (int argc, char *argv[]);


@interface NXDevice ()

@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *osVersion;
@property (nonatomic, readwrite) NSString *modelName;
@property (nonatomic, readwrite) NSString *modelType;
@property (nonatomic, readwrite) NSString *bundleVersion;
@property (nonatomic, readwrite) NSString *uniqueID;
@property (nonatomic, readwrite) NSString *vendorID;

@property (nonatomic, readwrite) NSString *currentLocaleISO;

@property (nonatomic, readwrite) CGSize screenSize;

@property (nonatomic, readwrite) BOOL has3dot5InchScreen;   // iPhone3G, 4
@property (nonatomic, readwrite) BOOL has4InchScreen;       // iPhone5 iPhone5S
@property (nonatomic, readwrite) BOOL has4dot7InchScreen;   // iPhone6
@property (nonatomic, readwrite) BOOL has5dot5InchScreen;   // iPhone6+
@property (nonatomic, readwrite) BOOL isRetina;
@property (nonatomic, readwrite) BOOL isIPhone;
@property (nonatomic, readwrite) BOOL isIPad;
@property (nonatomic, readwrite) BOOL isIPod;

@property (nonatomic, readwrite) NSString *documentsDirectory;

@property (nonatomic, readwrite) BOOL isJailbroken;
@property (nonatomic, readwrite) BOOL isPirated;


@end

@implementation NXDevice

+ (instancetype)sharedInstance
{
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });

}

+ (NSString *)name {     return [[[self class] sharedInstance] name];};

+ (NSString *)osVersion {     return [[[self class] sharedInstance] osVersion];};

+ (NSString *)modelName {     return [[[self class] sharedInstance] modelName];};

+ (NSString *)modelType
{
    NXDevice *device = [[self class] sharedInstance];
    if (!device.modelType) {
        device.modelType = [[device platformString] copy];
    }
    return [device.modelType copy];
}

+ (NSString *)bundleVersion
{
    NXDevice *device = [[self class] sharedInstance];
    if (!device.bundleVersion) {
        device.bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }

    return [device.bundleVersion copy];
}

+ (NSString *)uniqueID
{
    NXDevice *device = [[self class] sharedInstance];

    if (!device.uniqueID) {
        [device processUniqueID];
    }

    return [device.uniqueID copy];
}

+ (NSString *)vendorID
{
    NXDevice *device = [[self class] sharedInstance];

    if (!device.vendorID) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
            device.vendorID = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] copy];
        }
    }

    return [self.vendorID copy];
}

+ (NSString *)currentLocaleISO {    return [[[self class] sharedInstance] currentLocaleISO];}

+ (CGSize)screenSize {     return [[[self class] sharedInstance] screenSize];}

+ (BOOL)has3dot5InchScreen {     return [[[self class] sharedInstance] has3dot5InchScreen];}
+ (BOOL)has4InchScreen {     return [[[self class] sharedInstance] has4InchScreen];}
+ (BOOL)has4dot7InchScreen {    return [[[self class] sharedInstance] has4dot7InchScreen];}
+ (BOOL)has5dot5InchScreen {    return [[[self class] sharedInstance] has5dot5InchScreen];}

+ (BOOL)isRetina {  return [[[self class] sharedInstance] isRetina];}
+ (BOOL)isIPhone {  return [[[self class] sharedInstance] isIPhone];}
+ (BOOL)isIPad {    return [[[self class] sharedInstance] isIPad];}
+ (BOOL)isIPod {    return [[[self class] sharedInstance] isIPod];}

+ (BOOL)isJailbroken {  return [[[self class] sharedInstance] isJailbroken];}
+ (BOOL)appIsPirated {   return [[[self class] sharedInstance] isPirated];}

+ (NSString *)documentsDirectory {    return [[[self class] sharedInstance] documentsDirectory]; }


+ (void)printAllFontsAvailable
{
#if (APP_DEV)
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
#endif
}
+ (void)printAllPNGsInBundle
{
#if (APP_DEV)
    NSArray *allPngImageNames = [[NSBundle mainBundle] pathsForResourcesOfType:@"png"
                                                                   inDirectory:nil];
    
    NSLog(@"### ALL PNGs IN BUNDLE : %@", allPngImageNames);
#endif
}

#pragma mark - Private Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            
            switch ((int)self.screenSize.height) {
                    
                    // iPhone 4X
                case 480:
                    self.has3dot5InchScreen = YES;
                    break;
                    
                    
                    // iPhone 5X
                case 568:
                    self.has4InchScreen = YES;
                    break;
                    
                    // iPhone 6
                case 667:
                    self.has4dot7InchScreen = YES;
                    break;
                    
                    // iPhone 6+
                case 736:
                    self.has5dot5InchScreen = YES;
                    break;
                    
                default:
                    break;
            }
        }

        self.isRetina = [[UIScreen mainScreen] scale] == 2.0f;

#if TARGET_IPHONE_SIMULATOR
        self.modelName = @"iPhone";
#else
        self.modelName = [[UIDevice currentDevice] model];

#endif
        self.name = [[UIDevice currentDevice] name];
        

        self.isIPhone = [self.modelName rangeOfString:@"iPhone"].location != NSNotFound;
        self.isIPad = [self.modelName rangeOfString:@"iPad"].location != NSNotFound;
        self.isIPod = [self.modelName rangeOfString:@"iPod"].location != NSNotFound;

        self.isPirated = ![self isEncrypted];
        self.isJailbroken = ![self isSandboxed];

        self.osVersion = [[UIDevice currentDevice] systemVersion];

        // default
        self.keychainServiceName = kKeychainServiceName;
        self.keychainAccountName = kKeychainAccountName;

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        NSLocale *locale = [NSLocale currentLocale];
        NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
        
        NSString *language = [[NSLocale preferredLanguages] firstObject];
        self.currentLocaleISO = [NSString stringWithFormat:@"%@_%@",language,countryCode];

    }
    return self;
}

- (void)processUniqueID
{

    NSString *serviceName = [self.keychainServiceName copy];
    NSString *accountName = [self.keychainAccountName copy];

#if CLEAN_KEYCHAIN
    NSError *err = nil;
    BOOL res = [SSKeychain deletePasswordForService:serviceName account:accountName error:&err];
    if (res) {
        DDLogNotice(@"### DELETED OLD PASS");
    } else {
        DDLogNotice(@"### NO OLD PASS FOUND, CONTINUING... : %@", err);
    }
#endif

    NSString *pass = [[FXKeychain defaultKeychain] objectForKey:serviceName];
    if ([pass length] == 0) {

        CFTimeInterval ts = CACurrentMediaTime();
        pass = [[self class] sha1:[NSString stringWithFormat:@"%f#%@~%@!%@", ts, serviceName, @(arc4random_uniform(INT32_MAX)), accountName]];


        BOOL res = [[FXKeychain defaultKeychain] setObject:pass forKey:serviceName];
        if (!res) {

            DDLogError(@"#### Error creating unique ID : |%@|, %@, quitting... ", pass, serviceName);
            exit(0);
        }
    }

    self.uniqueID = [pass copy];
    DDLogWarn(@"####### DEVICE UNIQUE ID : |%@|", self.uniqueID);
}

- (NSString *)platformString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (BOOL)isEncrypted
{
    //    DDLogInfo(@"");

    const struct mach_header *header;
    Dl_info dlinfo;

    /* Fetch the dlinfo for main() */
    if (dladdr(main, &dlinfo) == 0 || dlinfo.dli_fbase == NULL) {
        NSLog(@"Could not find main() symbol (very odd)");
        return NO;
    }
    header = dlinfo.dli_fbase;

    /* Compute the image size and search for a UUID */
    struct load_command *cmd = (struct load_command *) (header+1);

    for (uint32_t i = 0; cmd != NULL && i < header->ncmds; i++) {
        /* Encryption info segment */
        if (cmd->cmd == LC_ENCRYPTION_INFO) {
            struct encryption_info_command *crypt_cmd = (struct encryption_info_command *) cmd;
            /* Check if binary encryption is enabled */
            if (crypt_cmd->cryptid < 1) {
                /* Disabled, probably pirated */
                return NO;
            }

            /* Probably not pirated? */
            return YES;
        }

        cmd = (struct load_command *) ((uint8_t *) cmd + cmd->cmdsize);
    }

    /* Encryption info not found */
    return NO;
}

- (BOOL)isSandboxed
{
    NSString *filePath = [NSString stringWithFormat:@"/%@/%@",@"bin", @"bash"];
    return ![[NSFileManager defaultManager] fileExistsAtPath:filePath];
}
#pragma mark - Hash Methods

+ (NSString *)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (unsigned int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    int i;
    for(i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

+ (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    int i;
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return  output;
}

@end
