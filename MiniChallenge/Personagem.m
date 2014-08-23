//
//  Personagem.m
//  MiniChallenge
//
//  Created by Esdras Martins on 13/03/14.
//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//

#import "Personagem.h"
#define CORRENDO 0
#define PULANDO 1
#define MORTO 2

@implementation Personagem



-(id)init{

    self = [super init];
    
    if(self){
    
    
        self.texturaPersonagem = [SKTexture textureWithImageNamed:@"p1"];
        self.texturaPersonagem.filteringMode = SKTextureFilteringNearest;
        
        self.personagem = [SKSpriteNode spriteNodeWithTexture:self.texturaPersonagem];
       
        
        
        self.personagem.position = CGPointMake(100, 400);
        self.personagem.size = CGSizeMake(self.personagem.size.width *0.75, self.personagem.size.height *0.75);
        //self.personagem.xScale = -self.personagem.xScale;
        self.personagem.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.personagem.size];
        self.personagem.physicsBody.dynamic = NO;
        self.personagem.name = @"personagem";
        self.personagem.zPosition = 100;
        
        
        
        self.colisaoPeh = [[SKNode alloc] init];
        //self.colisaoPeh.position =
        //self.colisaoPeh.physicsBody =
        //self.categoriaPenguim = 1 << 0;
        self.personagem.physicsBody.categoryBitMask = self.categoriaPenguim;
       
        self.estado = CORRENDO;
        self.personagem.physicsBody.allowsRotation = NO;
        self.animacoes = [[NSMutableArray alloc] init];
        [self montaAnimacoes];
        [self mudaAnimacao:self.estado];
    }

    return self;
}


-(void)mudaAnimacao: (int)estado{
    
    [self.personagem removeAllActions];
    self.estado = estado;
    [self.personagem runAction:[self.animacoes objectAtIndex:estado]];


}
                                                                                         
                                                                                         
-(void)montaAnimacoes{
    
    
    //Carregando Imagens
    
        //Correndo
    SKTexture *correndo1 = [SKTexture textureWithImageNamed:@"c1Vu"];
    correndo1.filteringMode = SKTextureFilteringNearest;
    
    SKTexture *correndo2 = [SKTexture textureWithImageNamed:@"c2Vu"];
    correndo2.filteringMode = SKTextureFilteringNearest;
    
    SKTexture *correndo3 = [SKTexture textureWithImageNamed:@"c3Vu"];
    correndo3.filteringMode = SKTextureFilteringNearest;
    
    
        //Pulando
    SKTexture *pulando1 = [SKTexture textureWithImageNamed:@"p1Vu"];
    
    
    
    //Criando animacoes.
    SKAction *correr = [SKAction repeatActionForever:[SKAction animateWithTextures:@[correndo1, correndo2, correndo3] timePerFrame:0.04]];
    
    SKAction *pular = [SKAction repeatAction:[SKAction animateWithTextures:@[pulando1] timePerFrame:0.8] count:1];
    
    
    //Adicionando animacoes para o vetor animacoes.
    [self.animacoes addObject:correr];
    [self.animacoes addObject:pular];
}
 

-(void)pular:(int)forcaDoPulo{

    if(self.estado != PULANDO){

        self.estado = PULANDO;
        [self mudaAnimacao:PULANDO];
        
        [self.personagem.physicsBody setVelocity:CGVectorMake(0, 0)];
        [self.personagem.physicsBody applyImpulse:CGVectorMake(25, forcaDoPulo+1)];
        if (self.jogoRodando) {
            [self.personagem runAction:[SKAction playSoundFileNamed:@"Jump.mp3" waitForCompletion:NO]];
        }else{
            self.jogoRodando = YES;
        }
        
    }



}

-(void)reposicionar{


    [self.personagem setPosition:CGPointMake(self.personagem.frame.origin.x, self.personagem.frame.origin.y +50)];

}

-(void)adicionarColisao: (uint32_t) colChao : (uint32_t) colInimigo{


    self.personagem.physicsBody.collisionBitMask = colChao | colInimigo | 1 << 3 ;
    self.personagem.physicsBody.contactTestBitMask = colChao | colInimigo | 1 << 3 ;


}
                                                                                         
                                                                                         
@end
