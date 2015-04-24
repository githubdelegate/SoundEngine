//
//  RootViewController.m
//  AudioSample
//
//  Created by Alex Restrepo on 9/14/09.
//  Copyright Brainchild 2009. All rights reserved.
//
//  This code is released under the creative commons attribution-share alike licence, meaning:
//
//	Attribution - You must attribute the work in the manner specified by the author or licensor 
//	(but not in any way that suggests that they endorse you or your use of the work).
//	In this case, simple credit somewhere in your app or documentation will suffice.
//
//	Share Alike - If you alter, transform, or build upon this work, you may distribute the resulting
//	work only under the same, similar or a compatible license.
//	Simply put, if you improve upon it, share!
//
//	http://creativecommons.org/licenses/by-sa/3.0/us/

#import "RootViewController.h"
#import "CMOpenALSoundManager.h"
#import "DebugOutput.h"

enum mySoundIds {
	AUDIOEFFECT
};

@interface RootViewController()
@property (nonatomic, retain) CMOpenALSoundManager *soundMgr;
@end

@implementation RootViewController
@synthesize soundMgr;

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Audio Sample";
	
	//start the audio manager...
	self.soundMgr = [[[CMOpenALSoundManager alloc] init] autorelease];
	soundMgr.soundFileNames = [NSArray arrayWithObject:@"engine.caf"];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// 开始播放背景音乐
	[soundMgr playBackgroundMusic:@"bgMusic.mp3"]; // you could use forcePlay: YES if you wanted to stop any other audio source (iPod)
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
		return @"背景音量";
	else if(section == 1)
		return @"音量";
	else return nil;	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		// create a slider for the first 2 sections only
		if(indexPath.section < 2)
		{			
			UISlider *slider;		
			slider = [[UISlider alloc] initWithFrame:CGRectMake(5.0, 0.0, cell.bounds.size.width - cell.indentationWidth * 2.0, cell.bounds.size.height)];
			slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			slider.minimumValueImage = [UIImage imageNamed:@"volumedown.png"];
			slider.maximumValueImage = [UIImage imageNamed:@"volumeup.png"];
			
			slider.maximumValue = 1.0; 
			slider.minimumValue = 0.0;			
			slider.value = 1.0; // in a real app you should read this value from the user defaults
			
			if(indexPath.section == 0)
			{
				[slider addTarget:self action:@selector(musicVolume:) forControlEvents:UIControlEventValueChanged];		
				slider.enabled = !soundMgr.isiPodAudioPlaying; // disable the slider if the ipod is playing...
			}
			else
				[slider addTarget:self action:@selector(effectsVolume:) forControlEvents:UIControlEventValueChanged];		
			
			
			[cell.contentView addSubview:slider];
			[slider release];
		}
    }
    
	// Configure the cell.
	if(indexPath.section == 2)
	{
		cell.textLabel.text = @"播放音乐";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	}	
	else if(indexPath.section == 3)
	{
		cell.textLabel.text = @"播放/暂停背景音乐";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	}else if (indexPath.section == 4)
    {
        cell.textLabel.text = @"开始播放两个MP3文件";
    }
    return cell;
}

- (void) musicVolume:(id)sender
{
	soundMgr.backgroundMusicVolume = ((UISlider *)sender).value;
}

- (void) effectsVolume:(id)sender
{
	soundMgr.soundEffectsVolume = ((UISlider *)sender).value;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section < 2) return;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 2) {
		// play our sound effect
		[soundMgr playSoundWithID:AUDIOEFFECT];
		return;
	}
	
	if ([soundMgr isBackGroundMusicPlaying]) 
	{
		[soundMgr pauseBackgroundMusic];
	}
	else 
	{
		[soundMgr resumeBackgroundMusic];
	}

    if(indexPath.section == 4)
    {
        [self playMutialMP3File];
    }
}

- (void)playMutialMP3File
{
   

}

- (void)dealloc {
	[soundMgr release];
    [super dealloc];
}
@end

