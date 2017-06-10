//
//  SettingsViewController.m
//  UITableView Static Cells
//
//  Created by Slava on 10.06.17.
//  Copyright © 2017 Vyacheslav Bortnichenko. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField        *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField        *passwordTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *levelChangedControl;

@property (weak, nonatomic) IBOutlet UISwitch           *shadowsSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *detalisationChangedControl;

@property (weak, nonatomic) IBOutlet UISlider           *soundSlider;
@property (weak, nonatomic) IBOutlet UISlider           *musicSlider;

@end

// ключи
static NSString *keySettingsLogin         = @"login";
static NSString *keySettingsPassword      = @"password";
static NSString *keySettingsLevel         = @"level";
static NSString *keySettingsShadows       = @"shadows";
static NSString *keySettingsDetalisation  = @"detalisation";
static NSString *keySettingsSound         = @"sound";
static NSString *keySettingsMusic         = @"music";


@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSettings];
    
    NSNotificationCenter *notificationDefCenter = [NSNotificationCenter defaultCenter];
    [notificationDefCenter addObserver:self
                              selector:@selector(notificationKeyboardWillShow:)
                                  name:UIKeyboardWillShowNotification
                                object:nil];
    
    [notificationDefCenter addObserver:self
                              selector:@selector(notificationKeyboardWillHide: )
                                  name:UIKeyboardWillHideNotification
                                object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification
- (void)notificationKeyboardWillShow:(NSNotification *)notification {
    NSLog(@"notificationKeyboardWillShow: \%@", notification.userInfo);
}

- (void)notificationKeyboardWillHide:(NSNotification *)notification {
    NSLog(@"notificationKeyboardWillHide : \%@", notification.userInfo);
}

#pragma mark - Save and Loading
- (void)saveSettings {
    // синглтон
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    // save UITextField             (setObject)
    [userDefault setObject:self.loginTextField.text forKey:keySettingsLogin];
    [userDefault setObject:self.passwordTextField.text forKey:keySettingsPassword];
    // save UISegmentedControl      (setInteger)
    [userDefault setInteger:self.levelChangedControl.selectedSegmentIndex forKey:keySettingsLevel];
    [userDefault setInteger:self.detalisationChangedControl.selectedSegmentIndex forKey:keySettingsDetalisation];
    // save UISwitch                (setBool)
    [userDefault setBool:self.shadowsSwitch.isOn forKey:keySettingsShadows];
    // save UISlider                (setDouble / setFloat)
    [userDefault setDouble:self.soundSlider.value forKey:keySettingsSound];
    [userDefault setDouble:self.musicSlider.value forKey:keySettingsMusic];
    // для сохранения
    [userDefault synchronize];
}

- (void)loadSettings {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    // load UITextField             (objectForKey)
    self.loginTextField.text = [userDefault objectForKey:keySettingsLogin];
    self.passwordTextField.text = [userDefault objectForKey:keySettingsPassword];
    // load UISegmentedControl      (integerForKey)
    self.levelChangedControl.selectedSegmentIndex = [userDefault integerForKey:keySettingsLevel];
    self.detalisationChangedControl.selectedSegmentIndex = [userDefault integerForKey:keySettingsDetalisation];
    // load UISwitch                (boolForKey)
    self.shadowsSwitch.on = [userDefault boolForKey:keySettingsShadows];
    // load UISlider                (doubleForKey / floatForKey)
    self.soundSlider.value = [userDefault doubleForKey:keySettingsSound];
    self.musicSlider.value = [userDefault doubleForKey:keySettingsMusic];
}


#pragma mark - Action
- (IBAction)actionTextChanged:(UITextField *)sender {
    [self saveSettings];
}

- (IBAction)actionValueChanged:(id)sender {
    [self saveSettings];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}



@end
