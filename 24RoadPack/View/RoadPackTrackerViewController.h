
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RoadPackTrackerViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *downloadRouteButton;
@property (strong, nonatomic) IBOutlet UITextField *textFieldJobId;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)onDownloadRouteButtonClicked:(id)sender;
- (IBAction)onStartTrackingButtonClicked:(id)sender;
@end
