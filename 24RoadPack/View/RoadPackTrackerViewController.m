
// Project includes
#import "RoadPackTrackerViewController.h"
#import "RoadPackTrackerModel.h"
#import "DataProvider.h"
#import "WebserviceJob.h"
#import <CoreLocation/CoreLocation.h>

@interface RoadPackTrackerViewController ()
@property NSInteger AnnotationCounter;
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
    self.textFieldJobId.delegate = self;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (NSString *)getFormattedTime:(NSString*)time {
    return [[time substringFromIndex:11] substringToIndex:5];
}

- (NSString *)getFormattedDate:(NSString*)dateStr {
    dateStr = [dateStr substringToIndex:10];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:NSLocalizedString(@"map.address.format", @"map")];
    return [dateFormat stringFromDate:date];
}

- (NSString *)getPickupJobDateTime {
     WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;

    return [NSString stringWithFormat:@"%@: %@-%@", NSLocalizedString(@"map.homeAddress.latestPickuptDate", @"map"), [self getFormattedDate:webserviceJob.pickupDate], [self getFormattedTime:webserviceJob.deliveryTime]];
}

- (NSString *)getHomeAddress {
    WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;
    return [NSString stringWithFormat:@"%@ %@ %@ %@", webserviceJob.homeStreet, webserviceJob.homeHouseNumber, webserviceJob.homeZip, webserviceJob.homeLocation];
}

- (NSString *)getDeliveryJobDateTime {
    WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;

    return [NSString stringWithFormat:@"%@: %@-%@", NSLocalizedString(@"map.homeAddress.latestDeliveryDate", @"map"), [self getFormattedDate:webserviceJob.deliveryDate], [self getFormattedTime:webserviceJob.pickupTime]];
}

- (NSString *)getDestinationAddress {
    WebserviceJob* webserviceJob = [DataProvider sharedDataProvider].webserviceJob;
    return [NSString stringWithFormat:@"%@ %@ %@ %@", webserviceJob.destinationStreet, webserviceJob.destinationHouseNumber, webserviceJob.destinationZip, webserviceJob.destinationLocation];
}

- (void)drawPolygonBetweenHomeCoordinate:(CLLocationCoordinate2D)homeCoordinate andDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate {
    //initialize your map view and add it to your view hierarchy - **set its delegate to self***
    CLLocationCoordinate2D coordinateArray[20];
    
    coordinateArray[0] = CLLocationCoordinate2DMake(47.47793830, 7.60120180);
    coordinateArray[1] = CLLocationCoordinate2DMake(47.540846, 7.625885);
    coordinateArray[2] = CLLocationCoordinate2DMake(47.529720, 7.734375);
    coordinateArray[3] = CLLocationCoordinate2DMake(47.460594, 7.804413);
    coordinateArray[4] = CLLocationCoordinate2DMake(47.346267, 7.836685);
    coordinateArray[5] = CLLocationCoordinate2DMake(47.314621, 7.807159);
    coordinateArray[6] = CLLocationCoordinate2DMake(47.303447, 7.921143);
    coordinateArray[7] = CLLocationCoordinate2DMake(47.210706, 7.978821);
    coordinateArray[8] = CLLocationCoordinate2DMake(47.190646, 8.075638);
    coordinateArray[9] = CLLocationCoordinate2DMake(47.179912, 8.089371);
    coordinateArray[10] = CLLocationCoordinate2DMake(47.180379, 8.112717);
    coordinateArray[11] = CLLocationCoordinate2DMake(47.104251, 8.243866);
    coordinateArray[12] = CLLocationCoordinate2DMake(47.083215, 8.264465);
    coordinateArray[13] = CLLocationCoordinate2DMake(47.079942, 8.289871);
    coordinateArray[14] = CLLocationCoordinate2DMake(47.069303, 8.296051);
    coordinateArray[15] = CLLocationCoordinate2DMake(47.064509, 8.286095);
    coordinateArray[16] = CLLocationCoordinate2DMake(47.053634, 8.297081);
    coordinateArray[17] = CLLocationCoordinate2DMake(47.019238, 8.295708);
    coordinateArray[18] = CLLocationCoordinate2DMake(47.018258, 8.303154);
    coordinateArray[19] = CLLocationCoordinate2DMake(47.01343360, 8.30503320);
    
    //coordinateArray[0] = homeCoordinate;
    //coordinateArray[1] = destinationCoordinate;
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:20];
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect] animated:YES];    
    [self.mapView addOverlay:self.routeLine];
}

- (void)showHomeCoordinateOnMap:(CLLocationCoordinate2D)homeCoordinate andDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate{
    
    self.homeAnnotation = [[Location alloc] initWithJobDateTime:[self getPickupJobDateTime] address:[self getHomeAddress] coordinate:homeCoordinate];
    self.destinationAnnotation = [[Location alloc] initWithJobDateTime:[self getDeliveryJobDateTime] address:[self getDestinationAddress] coordinate:destinationCoordinate];
    self.AnnotationCounter = 2;

    [self drawPolygonBetweenHomeCoordinate:homeCoordinate andDestinationCoordinate:destinationCoordinate];
    
    [self.mapView addAnnotation:self.homeAnnotation];
    [self.mapView addAnnotation:self.destinationAnnotation];
    
    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(homeCoordinate, 90.0*METERS_PER_MILE, 90.0*METERS_PER_MILE);
    
    //[self.mapView setRegion:viewRegion animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *locationIdentifier = @"LocationIdentifier";
    if ([annotation isKindOfClass:[Location class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:locationIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:locationIdentifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.pinColor = (self.AnnotationCounter==2) ? MKPinAnnotationColorGreen : MKPinAnnotationColorRed;
            self.AnnotationCounter--;
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

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine)
    {
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 2;
        }
        
        return self.routeLineView;
    }
    
    return nil;
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
    
    homeCoordinate = CLLocationCoordinate2DMake(47.47793830, 7.60120180);
    destinationCoordinate = CLLocationCoordinate2DMake(47.01343360, 8.30503320);
    
    [self showHomeCoordinateOnMap:homeCoordinate andDestinationCoordinate:destinationCoordinate];
}
@end
