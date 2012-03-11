//
//  PreferencesController.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-21.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "PreferencesController.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

@synthesize defaults;

@synthesize googleAPIKey;
@synthesize jqueryVersion;
@synthesize jqueryUIVersion;


- (id)init
{
    self = [super initWithWindowNibName:@"PreferencesController"];
    if (self) {
		
    }
    return self;
}

- (void) awakeFromNib {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[self setApplicationDefaults];
	defaults = [NSUserDefaults standardUserDefaults];
}

- (void) windowWillLoad {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
}

- (void) windowDidLoad {
    [super windowDidLoad];
    NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
}

- (IBAction) dismissPreferenceWindow:(id)sender {
	[defaults setObject:[googleAPIKey stringValue] forKey:@"values.googleAPIKey"];
	[defaults setObject:[jqueryVersion stringValue] forKey:@"values.jqueryVersion"];
	[defaults setObject:[jqueryUIVersion stringValue] forKey:@"values.jqueryUIVersion"];
	[[self window] orderOut:nil];
}

#pragma mark - NSApplicationDelegate services 

- (void)	 setApplicationDefaults {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"ABQIAAAAGRbKDdWDinpZa8yW9ygJUBSQx1erA_pbq2SnEAbgryMectdTkxRq0qdLXP2ae-iTc4DRxb2yDa62kg" forKey:@"values.googleAPIKey"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:appDefaults forName:@"ca.roaringsky.RSTrixie"];
	
	defaults = [NSUserDefaultsController sharedUserDefaultsController];
	[googleAPIKey bind:@"value"
			  toObject:defaults
		   withKeyPath:@"values.googleAPIKey"
			   options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"NSContinuouslyUpdatesValue"]];
	[jqueryVersion bind:@"value"
			   toObject:defaults
			withKeyPath:@"values.jqueryVersion"
				options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"NSContinuouslyUpdatesValue"]];
	[jqueryUIVersion bind:@"value"
				 toObject:defaults
			  withKeyPath:@"values.jqueryUIVersion"
				  options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"NSContinuouslyUpdatesValue"]];
}


@end
