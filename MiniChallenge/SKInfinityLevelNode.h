//
//  SKInfinityLevelNode.h
//  ProceduralLevel - InfinityRunner
//
//  Created by RODRIGO PEREIRA ASSUNCAO on 13/03/14.
//  Copyright (c) 2014 RODRIGO PEREIRA ASSUNCAO. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>



static const int MaxHeightDifference = 50;
static const int MinHeightDifference = 50;
static const int HorizontalDifference = 50;

@interface SKInfinityLevelNode : SKNode

@property CGPoint initialPos;
@property CGSize floorSize;

@property SKSpriteNode *lastFloor;
@property SKTexture *imgFloor;

@property uint32_t categoriaChao;

-(id)initWithTexture:(SKTexture*) texture andPosition:(CGPoint)pos andSize:(CGSize)size;
-(void)addFloor;
-(void)setMovingDisable;
-(void)setMovingEnable;

@end
