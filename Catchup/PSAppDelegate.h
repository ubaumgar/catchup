//
//  PSAppDelegate.h
//  Catchup
//
//  Created by Pragmatic Solutions on 17.01.14.
//  Copyright (c) 2014 Pragmatic Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *start;
@property (weak) IBOutlet NSMenuItem *stop;
@property (weak) IBOutlet NSMenuItem *pause;
@property (weak) IBOutlet NSMenuItem *interrupt;
@property (weak) IBOutlet NSMenuItem *resume;
@property (weak) IBOutlet NSMenuItem *about;
@property (weak) IBOutlet NSMenuItem *quit;
@property (weak) IBOutlet NSMenuItem *shortBreak;
@property (weak) IBOutlet NSMenuItem *longBreak;

@end
