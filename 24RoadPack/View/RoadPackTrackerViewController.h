
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RoadPackTrackerViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *downloadRouteButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)onDownloadRouteButtonClicked:(id)sender;
- (IBAction)onStartTrackingButtonClicked:(id)sender;
@end
