//
//  HAViewController.m
//  HardwareApis
//
//  Created by Tim Novikoff on 2/8/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "HAViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface HAViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (strong, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet UILabel *yLabel;
@property (strong, nonatomic) IBOutlet UILabel *zLabel;


@end

@implementation HAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
//    [self.locationManager startUpdatingLocation];
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    if (self.motionManager.accelerometerAvailable) {//make sure accelerometer is available on this hardware
        
        if (self.motionManager.accelerometerActive == NO) {//activate it (if it isn't already active...this check makes more sense in the context of a bigger app where you're activating and de-activating the accelerometer. In this simple example app, of course it is not active yet.

            //this is what you do if you want to just occasionally querry the acceleration.
//            [self.motionManager startAccelerometerUpdates];
                //we'll querry it 1 second from now
//            [self performSelector:@selector(logAccelerometerData:) withObject:nil afterDelay:1];
            
            
        //this is to get more frequenet accelerometer data.
        self.motionManager.accelerometerUpdateInterval = .1;//we did not have this line of code in class but one can set the frequency like this.
            [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
             
             ^(CMAccelerometerData *accelerometerData, NSError *error) {
                 
                 NSString *x = [NSString stringWithFormat:@"%.3f", accelerometerData.acceleration.x];//the .3 means whos only 3 digits.
                 self.xLabel.text = x;
                 
                 NSString *y = [NSString stringWithFormat:@"%.3f", accelerometerData.acceleration.y];
                 self.yLabel.text = y;
                 
                 NSString *z = [NSString stringWithFormat:@"%.3f", accelerometerData.acceleration.z];
                 self.zLabel.text = z;
             
             }
             
             ];
        }
        else{
            NSLog(@"accelerometer not active");
        }
    }
    else{
        NSLog(@"accelerometer not available");
    }
}

- (void) logAccelerometerData: (NSObject *) object{
    NSLog(@"accelerometer data: %@", self.motionManager.accelerometerData);
    [self performSelector:@selector(logAccelerometerData:) withObject:nil afterDelay:1];
    
    NSString *x = [NSString stringWithFormat:@"%.3f", self.motionManager.accelerometerData.acceleration.x];
    self.xLabel.text = x;
    
    NSString *y = [NSString stringWithFormat:@"%.3f", self.motionManager.accelerometerData.acceleration.y];
    self.yLabel.text = y;
    
    NSString *z = [NSString stringWithFormat:@"%.3f", self.motionManager.accelerometerData.acceleration.z];
    self.zLabel.text = z;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locations: %@", locations);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
