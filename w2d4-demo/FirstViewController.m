//
//  ViewController.m
//  NSNotificationCenter-Example
//
//  Created by Roland Tecson on 2017-10-10.
//  Copyright © 2017 Roland Tecson. All rights reserved.
//

#import "FirstViewController.h"

NSString * const kNotificationButtonDidPress = @"kNotificationButtonDidPress";

@interface FirstViewController ()

@property (strong, nonatomic) id keyboardWillShowObserver;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
//    [self watchKeyboardNotifications:notificationCenter];
//    [self watchTextFieldChanges];
//    [self watchButtonPressedNotifications:notificationCenter];
    [self setupTapGestureRecognizer];
//    [self watchAllNotifications:notificationCenter];
}

- (void)dealloc {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
//    [notificationCenter removeObserver:self.keyboardWillShowObserver];
    [notificationCenter removeObserver:self];
}


#pragma mark - Keyboard Notifications (NSNotificationCenter)

- (void)watchKeyboardNotifications:(NSNotificationCenter *)notificationCenter {
    // Notification using a separate notification observer
//    typeof(self) __weak weakSelf = self;
//    self.keyboardWillShowObserver = [notificationCenter addObserverForName:UIKeyboardWillShowNotification
//                                                        object:nil
//                                                         queue:nil
//                                                    usingBlock:^(NSNotification * _Nonnull notification) {
//                                                        NSLog(@"In watchKeyboardNotifications: %@", notification.name);
//                                                        weakSelf.infoLabel.text = notification.name;
//                                                    }];
//
    // Notification using self as the observer
    [notificationCenter addObserver:self
                           selector:@selector(keyboardDidShowNotificationReceived:)
                               name:UIKeyboardDidShowNotification
                             object:nil];
}

// Notification callback
- (void)keyboardDidShowNotificationReceived:(NSNotification *)notification {
    NSLog(@"In keyboardDidShowNotificationReceived: %@", notification.name);
    self.infoLabel.text = notification.name;
}

// Notification callback
- (void)buttonPressedNotificationReceived:(NSNotification *)notification {
    NSLog(@"In buttonPressedNotificationReceived: %@", notification.name);
    self.infoLabel.text = notification.name;
}


#pragma mark - TextField notifications (KVO & NSNotifications)

- (void)watchTextFieldChanges {
    // Add KVO for self.text
    [self addObserver:self
           forKeyPath:@"text"
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:nil];

    // Add notification for control event - Target-Action pattern
    [self.textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)sender {
    NSLog(@"In textFieldDidChange: text = %@", sender.text);
    self.text = sender.text;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    NSLog(@"%@: Old: %@, New: %@", keyPath, [change objectForKey:NSKeyValueChangeOldKey], [change objectForKey:NSKeyValueChangeNewKey]);
}


#pragma mark - ButtonPressed Notifications (Sending NSNotifications)

- (void)watchButtonPressedNotifications:(NSNotificationCenter *)notificationCenter {
    [notificationCenter addObserver:self
                           selector:@selector(buttonPressedNotificationReceived:)
                               name:kNotificationButtonDidPress
                             object:self];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    // Generate a notification event
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:kNotificationButtonDidPress
                                      object:self];
}


#pragma mark - UITapGestureRecognizer

- (void)setupTapGestureRecognizer {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:2];
    [self.imageView addGestureRecognizer:self.tapGestureRecognizer];

    // Add notification for a tap gesture event
    [self.tapGestureRecognizer addTarget:self
                                  action:@selector(imageTapped:)];
}

- (void)imageTapped:(UITapGestureRecognizer *)recog {
    NSLog(@"Image Tapped! %@", NSStringFromCGPoint([recog locationInView:self.imageView]));
}


#pragma mark - All Notifications

- (void)watchAllNotifications:(NSNotificationCenter *)notificationCenter {
    [notificationCenter addObserverForName:nil
                                    object:nil
                                     queue:nil
                                usingBlock:^(NSNotification * _Nonnull note) {
                                    NSLog(@"In watchAllNotifications: %@", note.name);
                                }];
}

@end
