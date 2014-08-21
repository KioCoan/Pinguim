//
//  SKInfinityLevelNode.m
//  ProceduralLevel - InfinityRunner
//
//  Created by RODRIGO PEREIRA ASSUNCAO on 13/03/14.
//  Copyright (c) 2014 RODRIGO PEREIRA ASSUNCAO. All rights reserved.
//

#import "SKInfinityLevelNode.h"


@implementation SKInfinityLevelNode

-(id)init
{
    return [self initWithTexture:nil andPosition:CGPointMake(0, 0) andSize:CGSizeMake(0, 0)];
    
    
    
    
    
   // NSLog(@"Inicializando com textura NULA e sem nenhum parametro");
}

-(id)initWithTexture:(SKTexture*) texture andPosition:(CGPoint)pos andSize:(CGSize)size
{
    self = [super init];
    if (self) {
        
        //Define a textura do chão, ultimo chão criado e posição inicial
        [self setLastFloor:nil];
        [self setImgFloor:texture];
        [self setInitialPos:pos];
        [self setFloorSize:size];
        
        
        self.categoriaChao = 1 << 1;
//        self.name = @"chao";
//        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100, 100)];
//        
//        NSLog(@"%f %f ", self.imgFloor.size.width, self.imgFloor.size.height);
//        self.physicsBody.categoryBitMask = self.categoriaChao;
//        self.physicsBody.dynamic = NO;
        
        
        
       // SKNode* dummy = [SKNode node];
        //        dummy.position = CGPointMake(0, 10);
        //        dummy.name = @"dummy";
        //        dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 10 * 2)];
        //        dummy.physicsBody.dynamic = NO;
        //        dummy.physicsBody.categoryBitMask = bitDummy;

        


        
        //Cria os primeiros pedaços do chão
        [self createBasicFloors];
    }
    
    return self;
}

-(void)createBasicFloors
{
    //Adiciona 5 pedaços do chão
    for (int i=0; i<5; i++) {
        [self addFloor];
    }
    
    [self setMovingDisable];
}

-(void)addFloor
{
    //Cria um novo SKSpriteNode com a textura do chão
    SKSpriteNode *new = [[SKSpriteNode alloc] initWithTexture:[self imgFloor]];
    SKSpriteNode *colisao = [[SKSpriteNode alloc] initWithImageNamed:@"parede"];
    
    new.size = CGSizeMake(new.size.width, 2500);
    
    //Se não for o primeiro pedaço, define a posição de acordo com a posição do anterior.
    if ([self lastFloor]) {
        
        //Define as posições x e y
        int xPosition = [self lastFloor].position.x+[self lastFloor].size.width + arc4random()%170;
        int yPosition = [self lastFloor].position.y +(arc4random()%MaxHeightDifference) - (arc4random()%MinHeightDifference);
        
        if (arc4random()%10 > 7) {
            xPosition += HorizontalDifference;
        }
        
        if (xPosition > 900) {
            return;
        }
        if (yPosition > [self initialPos].y + 80) {
            yPosition = [self initialPos].y + 80;
        }
        
        if (yPosition < [self initialPos].y - 40) {
            yPosition = [self initialPos].y - 40;
        }
        
        CGPoint position = CGPointMake(xPosition, yPosition);
        
        [new setPosition:position];
    }
    //Caso contrário, cria, na posição inicial definida no init
    else
    {
        [new setPosition:[self initialPos]];
    }
    
    //Define o tamanho dos pedaços
    [new setScale:0.09];
    //[colisao setSize:CGSizeMake(new.size.width-20, new.size.height*0.2)];
    [colisao setPosition:CGPointMake(0, new.size.height * 2.9) ];
    
    
    
    //Define a física do novo chão
    
    
   // new.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(new.size.width, new.size.height /2)];

   // new.physicsBody.categoryBitMask = 1 << 3;
    new.name = @"P";
    
    

    colisao.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: CGSizeMake(50 ,1) ];
    colisao.physicsBody.categoryBitMask = self.categoriaChao;
    colisao.name = @"chao";
    colisao.physicsBody.dynamic = NO;
    colisao.physicsBody.affectedByGravity = NO;
    colisao.physicsBody.allowsRotation = NO;
    colisao.physicsBody.density = 5;

    
    self.physicsBody.categoryBitMask = self.categoriaChao;

    new.physicsBody.dynamic = NO;
    new.physicsBody.affectedByGravity = NO;
    new.physicsBody.allowsRotation = NO;
    new.physicsBody.density = 1.0f;
    self.physicsBody.restitution = 0;
    
    
    
    
    //Adiciona a ação dos canos
    SKAction *mover = [SKAction moveTo:CGPointMake(new.position.x - 1000, new.position.y) duration:10];
    
    [new runAction:mover];
    
    [new addChild:colisao];
    [self addChild:new];
    [self setLastFloor:new];
}

-(void)setMovingDisable
{
    for (SKNode *n in self.children) {
        [n removeAllActions];
    }
}

-(void)setMovingEnable
{
    for (SKNode *n in self.children) {
        SKAction *mover = [SKAction moveTo:CGPointMake(n.position.x - 1000, n.position.y) duration:10];
        
        [n runAction:mover];

    }
}

@end
