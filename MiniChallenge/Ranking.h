//
//  Ranking.h
//  MiniChallenge
//
//  Created by Kio Coan on 20/03/14.
//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EmJogo.h"
#import "WSwebservice.h"


@interface Ranking : SKScene

@property NSThread* myThread;

@property SKLabelNode *lblRanking;

@property WSwebservice* ws;

@property float score;
@property NSString* nome;

-(instancetype)initWithSize:(CGSize)size : (NSString*)nome : (float)score;
-(void)initWithScore:(float)score : (NSString*)nomeJogador;

-(void)voltaJogo;


@end
