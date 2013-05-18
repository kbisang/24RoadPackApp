
// Project includes
#import "RoadPackTrackerViewController.h"
#import "RoadPackTrackerModel.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDownloadRouteButtonClicked:(id)sender {
    [RoadPackTrackerModel loadJob:[NSNumber numberWithInt:2]];
}
@end
