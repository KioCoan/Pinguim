//
//  Menu.h
//  MiniChallenge
//
//  Created by Kio Coan on 23/03/14.
//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WSwebservice.h"
#import <AVFoundation/AVFoundation.h>
#import "EmJogo.h"

@interface Menu : SKScene <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property SKLabelNode* lblNome;
@property SKSpriteNode* btnPlay;
@property UITextField* txtNome;
@property SKSpriteNode* btnRanking;
@property AVAudioPlayer* musicaInicio;

//ranking stuff
@property UITableView* tableView;
@property NSMutableArray* listaRanking;
@property UIView* viewRanking;



-(void)startGame;
-(void)showRanking;

@end
