//
//  NXGPSController.h
//  Feezly
//
//  Created by Paul Antonelli on 24/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NXGPSController.h"



// GPS distance Filters in meters
#define kDistanceBackgroundUpdate    100.0f
#define kDistanceForegroundUpdate    10.0f
#define GPSErrorDomain               @"GPSControllerError"



@interface NXGPSController () <CLLocationManagerDelegate>

// Location manager
//@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocationManager *slcLocationManager;

// Current user location
@property (nonatomic, strong) CLLocation *userLocation;

// Authorization status
@property (nonatomic, assign) CLAuthorizationStatus status;

// Flags
@property (nonatomic, readwrite) BOOL hasProcessedError;
@property (nonatomic, readwrite) BOOL gpsIsUpdating;

@end



@implementation NXGPSController

#pragma mark - Shared instance
+ (instancetype)sharedInstance
{
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

#pragma mark - Constructor
- (instancetype)init
{
    if (self = [super init])
    {
        DDLogWarn(@"########### GPS CONTROLLER INIT");

        // Default values
        self.status = kCLAuthorizationStatusNotDetermined;
//        self.managerDistanceFilter = kDistanceForegroundUpdate;
//        self.managerAccuracy = kCLLocationAccuracyBestForNavigation;
        
        // Build location managers
        [self buildLocationManagers];
    }
    
    return self;
}

#pragma mark - Location management
- (void)askForUserLocation:(id<NXGPSControllerDelegate>)delegate distanceFilter:(CLLocationDistance)distance
{
    DDLogDebug(@"");
    self.hasProcessedError = NO;
    
    self.delegate = delegate;
    
    if ([self checkStatusAndForwardErrorIfNeeded])
        return;
    
    // Build location maanger if necessary
    if (/*!self.locationManager ||*/ !self.slcLocationManager)
    {
        [self buildLocationManagers];
    }
    
    if (self.status == kCLAuthorizationStatusNotDetermined && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        DDLogWarn(@"######## REQUESTING USER AUTH FOR GPS USAGE...............");
        [self.slcLocationManager requestAlwaysAuthorization];
        return;
    }
    
    
    // Default configuration
//    self.locationManager.distanceFilter = distance;
    self.gpsIsUpdating = YES;
    
    // Start updating locations
//    if (APPLICATION.applicationState == UIApplicationStateActive)
//    {
//        [self.locationManager startUpdatingLocation];
//    }
    [self.slcLocationManager startMonitoringSignificantLocationChanges];
    
    // Simulator hack
#if TARGET_IPHONE_SIMULATOR

//43.57938 7.121980

    dispatch_async(dispatch_get_main_queue(), ^{
        [self locationManager:self.slcLocationManager didUpdateLocations:@[
//                                                                        [[CLLocation alloc] initWithLatitude:43.6986820 longitude:7.2683650]
                                                                        [[CLLocation alloc] initWithLatitude:43.57938 longitude:7.121980]
                                                                        ]];
    });
#endif
}

- (void)invalidateLocationManager
{
	DDLogDebug(@"");
    
    // Stop location manager
//    [self.locationManager stopUpdatingLocation];
//    self.locationManager.delegate = nil;
//    self.locationManager = nil;
    
    // Stop SLC location manager
    [self.slcLocationManager stopMonitoringSignificantLocationChanges];
    self.slcLocationManager.delegate = nil;
    self.slcLocationManager = nil;
    
    // Reset
    self.gpsIsUpdating = NO;
    self.userLocation = nil;
    self.hasProcessedError = NO;
    self.status = kCLAuthorizationStatusNotDetermined;
}

- (void)startSignificantLocationChangeUpdates:(id<NXGPSControllerDelegate>)delegate
{
    DDLogDebug(@"delegate : %@", delegate);

    // Build location maanger if necessary
    if (/*!self.locationManager ||*/ !self.slcLocationManager)
    {
        [self buildLocationManagers];
    }

    self.delegate = delegate;

    // Start monitoring signification location changes
    [self.slcLocationManager startMonitoringSignificantLocationChanges];
    self.gpsIsUpdating = YES;
}
- (void)stopSignificantLocationChangeUpdates
{
    DDLogDebug(@"stopSignificantLocationChangeUpdates");
    
    // Stop monitoring signification location changes
    [self.slcLocationManager stopMonitoringSignificantLocationChanges];
    self.gpsIsUpdating = NO;
}


- (void)restartSLC {
    DDLogDebug(@"");
    if (self.slcLocationManager)
    {
        [self.slcLocationManager stopMonitoringSignificantLocationChanges];
    }
    
    [self buildLocationManagers];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        [self.slcLocationManager requestAlwaysAuthorization];
    }
    
    if ([self.slcLocationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
    {
        [self.slcLocationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    [self.slcLocationManager startMonitoringSignificantLocationChanges];
}

- (void)refreshSLC
{
    DDLogDebug(@"");
    [self.slcLocationManager stopMonitoringSignificantLocationChanges];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        [self.slcLocationManager requestAlwaysAuthorization];
    }
    
    if ([self.slcLocationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
    {
        [self.slcLocationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    [self.slcLocationManager startMonitoringSignificantLocationChanges];
}


//- (void)startStandardLocationService:(id<NXGPSControllerDelegate>)delegate
//{
//    DDLogDebug(@"delegate : %@", delegate);
//
//    // Build location maanger if necessary
//    if (!self.locationManager || !self.slcLocationManager)
//    {
//        [self buildLocationManagers];
//    }
//
//    self.delegate = delegate;
//
//    // start SLS monitoring
//    [self.locationManager startUpdatingLocation];
//    self.gpsIsUpdating = YES;
//}
//- (void)stopStandardLocationService
//{
//    DDLogDebug(@"");
//
//    // stop SLS monitoring
//    [self.locationManager stopUpdatingLocation];
//    self.gpsIsUpdating = NO;
//}

- (BOOL)locationServiceEnabled
{
    return [CLLocationManager locationServicesEnabled];
}

//- (void)setManagerDistanceFilter:(CLLocationDistance)managerDistanceFilter
//{
//    DDLogDebug(@"######## NEW DISTANCE FILTER : %f", managerDistanceFilter);
//    _managerDistanceFilter = managerDistanceFilter;
//    self.locationManager.distanceFilter = managerDistanceFilter;
//
//    DDLogWarn(@"locationManager : %@", self.locationManager);
//}
//
//- (void)setManagerAccuracy:(CLLocationAccuracy)managerAccuracy
//{
//    _managerAccuracy = managerAccuracy;
//    self.locationManager.desiredAccuracy = managerAccuracy;
//}

- (BOOL)gpsIsEnabled
{
    if ([self status] == kCLAuthorizationStatusAuthorized && [self locationServiceEnabled])
        return YES;
    
    return NO;
}

#pragma mark - Private Methods

- (void)buildLocationManagers
{
    // Build main location manager
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = self.managerAccuracy;
//    self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
//    self.locationManager.distanceFilter = self.managerDistanceFilter;
    
    // SLC location manager
    self.slcLocationManager = [[CLLocationManager alloc]init];
    self.slcLocationManager.delegate = self;
    self.slcLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.slcLocationManager.activityType = CLActivityTypeOtherNavigation;
    
    if ([self.slcLocationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
    {
        [self.slcLocationManager setAllowsBackgroundLocationUpdates:YES];
    }
}

- (BOOL)checkStatusAndForwardErrorIfNeeded
{
    DDLogInfo(@"### GPS Status : %d", [CLLocationManager authorizationStatus]);
    
    if (self.locationServiceEnabled == NO)
    {
        self.status = kCLAuthorizationStatusNotDetermined;
        NSError *error = [NSError errorWithDomain:GPSErrorDomain
                                             code:GPSAuthorizationCodeDisabledServices
                                         userInfo:@{ NSLocalizedDescriptionKey : @"Location services are currently disabled."}];
        
        [self forwardErrorToDelegate:error];
        return YES;
    }
    
    // Update status
    self.status = [CLLocationManager authorizationStatus];
    
    // Access to GPS is denied
    if (self.status == kCLAuthorizationStatusDenied)
    {
        NSError *error = [NSError errorWithDomain:GPSErrorDomain
                                             code:GPSAuthorizationCodeDenied
                                         userInfo:@{ NSLocalizedDescriptionKey : @"GPS Authorization status denied.\nOpen \'Settings\' app and enable GPS for \'AxaDrive\'."}];
        
        [self forwardErrorToDelegate:error];
        return YES;
    }
    
    // Access to GPS is restricted
    if (self.status == kCLAuthorizationStatusRestricted)
    {
        NSError *error = [NSError errorWithDomain:GPSErrorDomain
                                             code:GPSAuthorizationCodeRestricted
                                         userInfo:@{ NSLocalizedDescriptionKey : @"GPS Authorization status restricted.\nOpen \'Settings\' app and enable GPS for \'AxaDrive\'."}];
        
        [self forwardErrorToDelegate:error];
        return YES;
    }
    
    return NO;
}

#pragma mark - CLLocationManagerDelegate methods
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    // Notify delegate
    if ([self.delegate respondsToSelector:@selector(didPauseLocationManager)])
    {
        [self.delegate didPauseLocationManager];
    }
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    // Notify delegate
    if ([self.delegate respondsToSelector:@selector(didResumeLocationManager)])
    {
        [self.delegate didResumeLocationManager];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self checkStatusAndForwardErrorIfNeeded];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        if (self.gpsIsEnabled && !self.gpsIsUpdating)
        {
            [self startSignificantLocationChangeUpdates:self.delegate];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    DDLogError(@"\n\n\n\n\n\n");
    DDLogError(@"############### locations : %@", locations);
    DDLogError(@"############### last location  : %@", [locations lastObject]);
    DDLogError(@"############### delegate : %@", self.delegate);
    DDLogError(@"############### location accuracy : v : %f | h : %f", [[locations lastObject] verticalAccuracy], [[locations lastObject] horizontalAccuracy]);
    DDLogError(@"############### manager accuracy : %f", manager.distanceFilter);
    DDLogError(@"############### app is in background : %d", [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground);
    DDLogError(@"\n\n\n\n\n\n");
    
//    DDLogDebug(@"locationManager.distanceFilter == kCLDistanceFilterNone %d --> filter : %f", self.locationManager.distanceFilter == kCLDistanceFilterNone, self.locationManager.distanceFilter);

    // Update user location
    self.userLocation = [locations lastObject];
    
    [self forwardSuccessToDelegate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self forwardErrorToDelegate:error];
}

#pragma mark - Forwarding
- (void)forwardErrorToDelegate:(NSError *)error
{
    if (!self.hasProcessedError)
    {
        // Flag
        self.hasProcessedError = YES;
        
        // Notify delegate
        if ([self.delegate respondsToSelector:@selector(didFailRetrievingUserLocation:)])
        {
            [self.delegate didFailRetrievingUserLocation:error];
        }
    }
}

- (void)forwardSuccessToDelegate
{
    // Flag
    self.hasProcessedError = NO;
    
    if (!self.delegate) {
        DDLogError(@"delegate is nil!");
    }

    // Notify delegate
    if ([self.delegate respondsToSelector:@selector(didRetrieveUserLocation:)])
    {
        [self.delegate didRetrieveUserLocation:self.userLocation];
    }
}


- (NSDictionary *)dictionaryRepresentation
{
    return  @{
//              @"sls manager" : _locationManager ?: @"nil",
//              @"sls distance filter" : @(_locationManager.distanceFilter),
              @"slc manager" : _slcLocationManager ?: @"nil",
              @"slc distance filter" : @(_slcLocationManager.distanceFilter),
              @"delegate" : [_delegate description] ?: @"nil"
              };
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" %@", [self dictionaryRepresentation]];
}

@end
