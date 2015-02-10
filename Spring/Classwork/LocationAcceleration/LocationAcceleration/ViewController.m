//
//  ViewController.m
//  LocationAcceleration
//
//  Created by Yukti on 2/9/15.
//  Copyright (c) 2015 Yukti. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (strong, nonatomic) IBOutlet UILabel *xlabel;
@property (strong, nonatomic) IBOutlet UILabel *ylabel;
@property (strong, nonatomic) IBOutlet UILabel *zlabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;//implement the interface to remove warning <cllocationmanagerdelegate>
    [self.locationManager startUpdatingLocation];
    
    self.motionManager = [[CMMotionManager alloc]init];
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        NSLog(@"acclerometer! %@", accelerometerData );
        
        double x = accelerometerData.acceleration.x;
        double y = accelerometerData.acceleration.y;
        double z = accelerometerData.acceleration.z;
        
        self.xlabel.text = [NSString stringWithFormat:@"x = %.05f", x];
        self.ylabel.text = [NSString stringWithFormat:@"y = %.05f", y];
        self.zlabel.text = [NSString stringWithFormat:@"z = %.05f", z];
    }];
    
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"i got le locaoion: %@", locations);
    CLLocation *location = [locations lastObject];
    NSLog(@"location: %@",location);
    NSLog(@"coordinate: %f,%f", location.coordinate.latitude, location.coordinate.longitude);
    
    if (location.horizontalAccuracy + location.verticalAccuracy < 1000) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
