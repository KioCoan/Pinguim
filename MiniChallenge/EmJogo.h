//
//  MyScene.h
//  MiniChallenge
//

//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKInfinityLevelNode.h"
#import "Personagem.h"
#import <AVFoundation/AVFoundation.h>
#import "Ranking.h"
#import "ViewController.h"
#import "Nuvem.h"

@interface EmJogo : SKScene <SKPhysicsContactDelegate>

@property AVAudioPlayer* musica;
@property Personagem *player;
@property SKInfinityLevelNode *floor;

@property BOOL jogoAtivo;
@property float scoreCount;

@property BOOL querdaInicial;
@property float score;
@property SKLabelNode *lblScore;

@property double timer;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property NSString* nomeJogador;

@property int qNuvens;

-(id)initWithSize:(CGSize)size : (NSString*)nome;

@end
