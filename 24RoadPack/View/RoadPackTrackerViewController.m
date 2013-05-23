
// Project includes
#import "RoadPackTrackerViewController.h"
#import "RoadPackTrackerModel.h"
#import "DataProvider.h"
#import "WebserviceJob.h"
#import "Location.h"

@interface RoadPackTrackerViewController ()

@end

@implementation RoadPackTrackerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define METERS_PER_MILE 1609.344

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 1
    self.mapView.zoomEnabled=YES;
    self.mapView.delegate = self;
}

- (NSString *)getFormattedTime:(NSString*)time {
    return [[time substringFromIndex:11] substringToIndex:5];
}

- (NSString *)getFormattedDate:(NSString*)dateStr {
    dateStr = [dateStr substringToIndex:10];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    return [dateFormat stringFromDate:date];
}

- (NSString *)getPickupJobDateTime {
     WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;

    return [NSString stringWithFormat:@"%@: %@-%@", @"Abholzeit", [self getFormattedDate:webserviceJob.pickupDate], [self getFormattedTime:webserviceJob.deliveryTime]];
}

- (NSString *)getHomeAddress {
    WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;
    return [NSString stringWithFormat:@"%@ %@ %@ %@", webserviceJob.homeStreet, webserviceJob.homeHouseNumber, webserviceJob.homeZip, webserviceJob.homeLocation];
}

- (NSString *)getDeliveryJobDateTime {
    WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;

    return [NSString stringWithFormat:@"%@: %@-%@", @"Lieferzeit", [self getFormattedDate:webserviceJob.deliveryDate], [self getFormattedTime:webserviceJob.pickupTime]];
}

- (NSString *)getDestinationAddress {
    WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;
    return [NSString stringWithFormat:@"%@ %@ %@ %@", webserviceJob.destinationStreet, webserviceJob.destinationHouseNumber, webserviceJob.destinationZip, webserviceJob.destinationLocation];
}

- (void)showHomeCoordinateOnMap:(CLLocationCoordinate2D)homeCoordinate andDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate{
    Location *homeAnnotation = [[Location alloc] initWithJobDateTime:[self getPickupJobDateTime] address:[self getHomeAddress] coordinate:homeCoordinate];
    Location *destinationAnnotation = [[Location alloc] initWithJobDateTime:[self getDeliveryJobDateTime] address:[self getDestinationAddress] coordinate:destinationCoordinate];
    [self.mapView addAnnotation:homeAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(homeCoordinate, 90.0*METERS_PER_MILE, 90.0*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *locationIdentifier = @"LocationIdentifier";
    if ([annotation isKindOfClass:[Location class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:locationIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:locationIdentifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.pinColor = MKPinAnnotationColorGreen;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if([overlay class] == MKPolyline.class)
    {
        MKOverlayView* overlayView = nil;
        MKPolyline* polyline = (MKPolyline *)overlay;
        MKPolylineView  * routeLineView = [[MKPolylineView alloc] initWithPolyline:polyline];
        
        routeLineView.fillColor = [UIColor blueColor];
        routeLineView.strokeColor = [UIColor blueColor];
        
        routeLineView.lineWidth = 3;
        routeLineView.lineCap = kCGLineCapSquare;
        overlayView = routeLineView;
        return overlayView;
    } else {
        return nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CLLocationCoordinate2D)assignHomeCoordinateToDataProvider {
    WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;
    Address* address = [[Address alloc]init];
    address.Street = webserviceJob.homeStreet;
    address.HouseNumber = webserviceJob.homeHouseNumber;
    address.Location = webserviceJob.homeLocation;
    address.Zip = webserviceJob.homeZip;
    return [RoadPackTrackerModel getCoordinatesForAddressSynchronously:address];
}

- (CLLocationCoordinate2D)assignDestinationCoordinateToDataProvider {
    WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;
    Address* address = [[Address alloc]init];
    address.Street = webserviceJob.destinationStreet;
    address.HouseNumber = webserviceJob.destinationHouseNumber;
    address.Location = webserviceJob.destinationLocation;
    address.Zip = webserviceJob.destinationZip;
    return [RoadPackTrackerModel getCoordinatesForAddressSynchronously:address];
}

- (IBAction)onDownloadRouteButtonClicked:(id)sender {
    [RoadPackTrackerModel loadJob:[NSNumber numberWithInt:1]];
}

- (IBAction)onStartTrackingButtonClicked:(id)sender {
    WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;
    if (webserviceJob == nil) {
        return;
    }
    CLLocationCoordinate2D homeCoordinate = [self assignHomeCoordinateToDataProvider];
    CLLocationCoordinate2D destinationCoordinate = [self assignDestinationCoordinateToDataProvider];
    
    [self showHomeCoordinateOnMap:homeCoordinate andDestinationCoordinate:destinationCoordinate];
}
@end
