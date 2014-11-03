//
//  PSAppDelegate.m
//  Catchup
//
//  Created by Pragmatic Solutions on 17.01.14.
//  Copyright (c) 2014 Pragmatic Solutions. All rights reserved.
//

#import "PSAppDelegate.h"

@interface PSAppDelegate () {
    NSStatusItem* statusItem;
    NSTimer* aTimer;
    NSTimer* aBreakTimer;
    int aCounter;
    int aBreakCounter;
}

@end

@implementation PSAppDelegate

@synthesize window = _window;
@synthesize menu = _menu;
@synthesize start = _start;

const int workDuration = 25;
const int shortBreakDuration = 5;
const int longBreakDuration = 15;
const int changeOrange = 5;
const int intervalTime = 60;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    statusItem.menu = self.menu;
    statusItem.highlightMode = YES;
    
    [_menu setAutoenablesItems:NO];
    [_about setEnabled:YES];
    
    aCounter = 0;
    aBreakCounter = 0;
    
    [self stop:nil];
}

- (void)playSound
{
    // Basso
    // Blow
    // Bottle
    // Frog
    // Funk
    // Glass
    // Hero
    // Morse
    // Ping
    // Pop
    // Purr
    // Sosumi
    // Submarine
    // Tink
    
    [[NSSound soundNamed:@"Hero"] play];
}

- (void)tick:(NSTimer *)theTimer
{
    // decrease the counter
    aCounter--;
    
    // variable for the font color
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];

    // update icon and text color
    if (aCounter > changeOrange)
    {
        [self changeIcon:@"tomato_green-512.png"];
    }
    else if (aCounter > 0)
    {
        [self changeIcon:@"tomato_orange-512.png"];
    }
    else
    {
        [self changeIcon:@"tomato_red-512.png"];
        titleAttributes = nil;
        titleAttributes = [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
    }
    
    // play sound if counter is zero
    if (aCounter == 0){
        [self playSound];
    }
    
    // update text
    NSString *title = [NSString stringWithFormat:@"%d", aCounter];
    NSAttributedString* colorTitle = [[NSAttributedString alloc] initWithString:title attributes:titleAttributes];
    [statusItem setAttributedTitle:colorTitle];

}

- (void)breakTick:(NSTimer *)theTimer
{
    // decrease the counter
    aBreakCounter--;
    
    // variable for the font color
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
    
    // update icon and text color
    if (aBreakCounter <= 0)
    {
        titleAttributes = nil;
        titleAttributes = [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
    }
    
    // play sound if counter is zero
    if (aBreakCounter == 0){
        [self playSound];
    }
    
    // update text
    NSString *title = [NSString stringWithFormat:@"break (%d)", aBreakCounter];
    NSAttributedString* colorTitle = [[NSAttributedString alloc] initWithString:title attributes:titleAttributes];
    [statusItem setAttributedTitle:colorTitle];
    
    // change the icon
    [self changeIcon:@"tomato_empty-512.png"];
}

// control the different user entries
// work time can be green (25, 20, 15, 10, 5 Minutes)
//                  orange (5, 4, 3, 2, 1, 0 Minutes)
//                  red (overtime)
// pause time can be empty (5, 4, 3, 2, 1, 0 Minutes)
//                   red (overtime)
// interruptions are with a red flash
//

// helper method to change the icon
- (void) changeIcon:(NSString*)iconName {
    NSImage *icon = [NSImage imageNamed:iconName];
    if (icon != nil) {
        [icon setSize:NSMakeSize(21,21)];
        statusItem.image = icon;
    }
}

// helper method to disable all menu items
- (void) disableMenuItems {
    [_start setEnabled:NO];
    [_stop setEnabled:NO];
    [_pause setEnabled:NO];
    [_interrupt setEnabled:NO];
    [_resume setEnabled:NO];
}

// start the work time
- (IBAction)start:(id)sender {
    NSLog(@"start the work time");
    
    // disable all menu items that could change the state machine
    [self disableMenuItems];
    [_stop setEnabled:YES];
    [_interrupt setEnabled:YES];
    [_pause setEnabled:YES];
    
    // stop the break time
    if (aBreakTimer != nil) {
        [aBreakTimer invalidate];
    }
    aBreakTimer = nil;

    // set counter
    aCounter = workDuration + 1;
    
    // change the state
    // as intermediate solution: start the timer
    aTimer = [NSTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [aTimer fire];
}

- (IBAction)stop:(id)sender {
    NSLog(@"stop the work time");
    
    // disable all menu items that could change the state machine
    [self disableMenuItems];
    [_start setEnabled:YES];
    
    // stop the work time
    if (aTimer != nil) {
        [aTimer invalidate];
    }
    aTimer = nil;
    // stop the break time
    if (aBreakTimer != nil) {
        [aBreakTimer invalidate];
    }
    aBreakTimer = nil;
    
    // update the title
    statusItem.title = @"stopped";
    // change the icon
    [self changeIcon:@"tomato_empty-512.png"];
}

- (IBAction)shortBreak:(id)sender {
    [self pause:shortBreakDuration];
}

- (IBAction)longBreak:(id)sender {
    [self pause:longBreakDuration];
}

- (void)pause:(int)duration {
    NSLog(@"start the break time");
    
    // disable all menu items that could change the state machine
    [self disableMenuItems];
    [_stop setEnabled:YES];
    [_start setEnabled:YES];
    
    // stop the work time and start the break
    if (aTimer != nil) {
        [aTimer invalidate];
    }
    aTimer = nil;
    
    // set counter
    aBreakCounter = duration + 1;
    aBreakTimer = [NSTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(breakTick:) userInfo:nil repeats:YES];
    [aBreakTimer fire];
}

- (IBAction)interrupt:(id)sender {
    NSLog(@"interrupt the work time");

    // disable all menu items that could change the state machine
    [self disableMenuItems];
    [_resume setEnabled:YES];
    [_stop setEnabled:YES];
    [_pause setEnabled:YES];
    
    // stop the timer and start the interruption
    [aTimer invalidate];
    aTimer = nil;
    
    // update the title
    statusItem.title = @"interrupted";

    // change the icon
    [self changeIcon:@"tomato_flash-512.png"];
}

- (IBAction)resume:(id)sender {
    NSLog(@"resume after the interruption");
    
    // disable all menu items that could change the state machine
    [self disableMenuItems];
    [_stop setEnabled:YES];
    [_interrupt setEnabled:YES];
    [_pause setEnabled:YES];
    
    // increase the counter by one due the fact that we fire immediately after the resume
    aCounter++;
    
    // resume the timer and fire once to set the icon correctly
    aTimer = [NSTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [aTimer fire];
}

- (IBAction)about:(id)sender {
    // show the about information
    [[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions:nil];
}

- (IBAction)quit:(id)sender {
    // quit the application
    [[NSApplication sharedApplication] terminate:nil];
}

@end
