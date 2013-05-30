
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"

@interface RoadPackTrackerViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *downloadRouteButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UITextField *textFieldJobId;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView *routeLineView;
@property (strong, nonatomic) Location *homeAnnotation;
@property (strong, nonatomic) Location *destinationAnnotation;
typedef void (^CompletionBlock)();	
@property (nonatomic, copy) CompletionBlock completionBlock;
- (void) setCompletionBlock:(CompletionBlock)completionBlock;
- (IBAction)onDownloadRouteButtonClicked:(id)sender;
- (IBAction)onStartTrackingButtonClicked:(id)sender;
- (IBAction)onStopTrackingButtonClicked:(id)sender;


@end
