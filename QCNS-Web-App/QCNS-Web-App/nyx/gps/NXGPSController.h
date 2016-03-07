//
//  NXGPSController.m
//  Feezly
//
//  Created by Paul Antonelli on 24/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//


@import CoreLocation;



@protocol NXGPSControllerDelegate;





typedef NS_ENUM(NSInteger, GPSErrorCode) {
    GPSAuthorizationCodeDisabledServices = 1,
    GPSAuthorizationCodeDenied,
    GPSAuthorizationCodeRestricted,
    GPSSignificationLocationChangeMonitoringUnavailable
};



@interface NXGPSController : NSObject

// Shared instance
+ (instancetype)sharedInstance;

// Ask for user location
- (void)askForUserLocation:(id<NXGPSControllerDelegate>)delegate distanceFilter:(CLLocationDistance)distance;

// Invalidate all location manager
- (void)invalidateLocationManager;

//// SLS management
//- (void)startStandardLocationService:(id<NXGPSControllerDelegate>)delegate;
//- (void)stopStandardLocationService;

// SLC management
- (void)startSignificantLocationChangeUpdates:(id<NXGPSControllerDelegate>)delegate;
- (void)stopSignificantLocationChangeUpdates;

// SLC in background management
- (void)restartSLC;
- (void)refreshSLC;

// Last found user location
@property (nonatomic, readonly) CLLocation *userLocation;

// Location manager configuration
//@property (nonatomic, assign) CLLocationDistance managerDistanceFilter;
//@property (nonatomic, assign) CLLocationAccuracy managerAccuracy;

// Flags
@property (nonatomic, readonly) BOOL locationServiceEnabled;
@property (nonatomic, readonly) CLAuthorizationStatus status;
@property (nonatomic, readonly) BOOL gpsIsEnabled;
@property (nonatomic, readonly) BOOL gpsIsUpdating;

// Delegate
@property (weak, nonatomic, readwrite) id<NXGPSControllerDelegate> delegate;

@end



@protocol NXGPSControllerDelegate <NSObject>

@optional

- (void)didPauseLocationManager;
- (void)didResumeLocationManager;
- (void)didRetrieveUserLocation:(CLLocation *)userLocation;
- (void)didFailRetrievingUserLocation:(NSError *)error;

@end
