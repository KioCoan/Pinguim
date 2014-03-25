//
//  Personagem.h
//  MiniChallenge
//
//  Created by Esdras Martins on 13/03/14.
//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>



@interface Personagem : NSObject

@property BOOL jogoRodando;

@property SKTexture *texturaPersonagem;
@property SKSpriteNode *personagem;
@property int estado;
@property NSMutableArray *animacoes;
@property uint32_t categoriaPenguim;
@property SKNode *colisaoPeh;




-(void)mudaAnimacao: (int)estado;
-(void)pular:(int)forcaDoPulo;
-(void)adicionarColisao: (uint32_t) colChao : (uint32_t) colInimigo;
-(void)reposicionar;
@end

