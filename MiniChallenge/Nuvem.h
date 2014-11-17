//
//  Nuvem.h
//  Pepes Adventure
//
//  Created by Kio Coan on 16/11/14.
//  Copyright (c) 2014 Coan. All rights reserved.
//

#define DIREITA 0
#define ESQUERDA 1

#import <SpriteKit/SpriteKit.h>


@interface Nuvem : SKNode;

@property SKTexture * textura;
@property SKSpriteNode* nuvem;
@property int direcao;

-(void)geraTextura;
-(void)movimentar;
-(void)geraPosicao;

@end
