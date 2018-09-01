//
//  CitiesTableViewController.m
//  Weather
//
//  Created by Xander on 29.08.17.
//  Copyright © 2017 Xander. All rights reserved.
//

#import "CitiesTableViewController.h"
#import "CityDetailedViewController.h"
#import "City.h"

@interface CitiesTableViewController ()

@property (nonatomic,strong) NSArray *cities;

@end

@implementation CitiesTableViewController
- (IBAction)addCity:(UIBarButtonItem *)sender {
    
    // Создает всплывающий на экран контролер
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"add city" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Добавляем в него поля для ввода города
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"My city";
    }];
    
    //Добавляем обработчик
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"++++" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = [controller.textFields firstObject];
        
        [self addCityWithName:textField.text];
        
    }];
    
    // Добавим на контролер кнопку действия
    [controller addAction:action];
    
    // Выведем контралер на экран
    [self presentViewController:controller animated:YES completion:nil ];
    
}

-(void)addCityWithName:(NSString *)name {
    // 1 создадим город с некоторым названием
    City *aCiti = [City new];
    aCiti.name = name;
    
    // 2 Добавим его в массив
    self.cities = [self.cities arrayByAddingObject:aCiti];
    
    // 3 обновляем tableView
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cities = [NSArray new];
    
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCellID"];
    City *aCity = self.cities[indexPath.row];
    
    cell.textLabel.text = aCity.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *selectedCity = self.cities[indexPath.row];
    
    // Начать переход на другой контроллер и посдать туда город
    [self performSegueWithIdentifier:@"ShowCity" sender:selectedCity];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowCity"]) {
        City *cityToPresent = sender;
        CityDetailedViewController *controller = segue.destinationViewController;
        controller.city = cityToPresent;
    }
    
}

@end
