#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"

%hook MMLocationMgr

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation{
   if([LLRedEnvelopesMgr shared].isOpenVirtualLocation){
        CLLocation *virutalLocation = [[LLRedEnvelopesMgr shared] getVirutalLocationWithRealLocation:newLocation];
    	%orig(manager,virutalLocation,virutalLocation);
    } else {
        %orig;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(CLLocation *)location{
    if([LLRedEnvelopesMgr shared].isOpenVirtualLocation){
        %orig(mapView,[[LLRedEnvelopesMgr shared] getVirutalLocationWithRealLocation:location]);
    } else {
        %orig;
    }
}

%end

%hook QMapView

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    if([LLRedEnvelopesMgr shared].isOpenVirtualLocation){
        CLLocation *virutalLocation = [[LLRedEnvelopesMgr shared] getVirutalLocationWithRealLocation:newLocation];
        %orig(manager,virutalLocation,virutalLocation);
    } else {
        %orig;
    }
}

- (id)correctLocation:(id)arg1{
    return [LLRedEnvelopesMgr shared].isOpenVirtualLocation ? arg1 : %orig;
}

%end