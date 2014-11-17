//
//  Nuvem.m
//  Pepes Adventure
//
//  Created by Kio Coan on 16/11/14.
//  Copyright (c) 2014 Coan. All rights reserved.
//

#import "Nuvem.h"

@implementation Nuvem

-(id)init{
    self = [super init];
    self.direcao = arc4random_uniform(2);
    [self geraPosicao];
    [self geraTextura];
    SKSpriteNode* sprite = [[SKSpriteNode alloc]initWithTexture:self.textura];
    sprite.size = CGSizeMake(sprite.size.width * 0.5, sprite.size.height * 0.5);
    sprite.alpha = 0.8;
    [self addChild:sprite];
    return self;
}

-(void)geraTextura{
    int rand = arc4random_uniform(3);
    switch (rand) {
        case 0:
            self.textura = [SKTexture textureWithImageNamed:@"nuvem1"];
            break;
        case 1:
            self.textura = [SKTexture textureWithImageNamed:@"nuvem2"];
            break;
        case 2:
            self.textura = [SKTexture textureWithImageNamed:@"nuvem3"];
            break;
        default:
            break;
    }
}

-(void)movimentar{
    SKAction *mover = [[SKAction alloc]init];
    if (self.direcao == DIREITA) {
        mover = [SKAction moveTo:CGPointMake(self.position.x + 500, self.position.y) duration:300];
    }else{
        mover = [SKAction moveTo:CGPointMake(self.position.x - 500, self.position.y) duration:260];
    }
    [self runAction:mover];
}

-(void)geraPosicao{
    if (self.direcao == DIREITA) {
        self.position = CGPointMake([self posicaoHorizontal], [self altura]);
    }else{
        self.position = CGPointMake([self posicaoHorizontal], [self altura]);
    }
}

-(int)altura{
    int minAlt = 200;
    int maxAlt = 320;
    int randAlt = 0;
    do{
        randAlt = arc4random_uniform(maxAlt + 1);
    }while(randAlt < minAlt);
    return randAlt;
}

-(int)posicaoHorizontal{
    int posMin = 0;
    int posMax = 0;
    int randPos = 0;
    if (self.direcao == DIREITA) {
        posMax = 200;
        posMin = 0;
        return randPos = arc4random_uniform(posMax);
    }else{
        posMax = 500;
        posMin = 400;
        do{
            randPos = arc4random_uniform(posMax);
        }while (randPos < posMin);
        return randPos;
    }
}

@end
