//
//  CityDetailedViewController.m
//  Weather
//
//  Created by Xander on 29.08.17.
//  Copyright © 2017 Xander. All rights reserved.
//

#import "CityDetailedViewController.h"

@interface CityDetailedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityindicator;

@end

@implementation CityDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(self.city !=nil, @"Не найдена модель");
    self.title = self.city.name;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadWeatherForCity];
}

-(void)loadWeatherForCity {
    [self.activityindicator startAnimating];
    
    NSURLSession *session  = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *cityAddress = [NSString stringWithFormat:@"http://samples.openweathermap.org/data/2.5/weather?q=%@,uk&appid=b1b15e88fa797225412429c1c50c122a1",self.city.name];
    NSURL *url = [NSURL URLWithString:cityAddress];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *weatherinfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
        
        NSLog(@"response: %@",weatherinfo);
        [self parseData:weatherinfo];
        
    }] resume];
}

- (void)parseData:(NSDictionary *)weather {
    
    // Из словаря выбирается подпунки main
    NSDictionary *main = weather[@"main"];
     // NSLog(@"main = : %@",main);

     // Из полученного словаря main выбирается число temp
      NSNumber *temperature = main[@"temp"];

    
      integer_t calculatedTemperature = [temperature integerValue] - 273.0;
      temperature = @(calculatedTemperature);
    
    
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"dd MMM yyyy"];
       NSDate *currentDate = [NSDate date];
       NSString *stringFromDate = [formatter stringFromDate:currentDate];
    

       dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.activityindicator stopAnimating];
        self.activityindicator.hidesWhenStopped = YES;
        
     self.date.text =  stringFromDate;
     self.temperature.text = [temperature stringValue] ;
    });
   

    
}



@end
