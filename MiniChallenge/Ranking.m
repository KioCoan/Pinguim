//
//  Ranking.m
//  MiniChallenge
//
//  Created by Kio Coan on 20/03/14.
//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//

#import "Ranking.h"

@implementation Ranking


-(void)initWithScore:(float)score :(NSString *)nomeJogador{
    //Atualiza o record atual
    [self atualizaRankingLocal:score];
    //Botão menu
    SKSpriteNode *botaoMenu = [SKSpriteNode spriteNodeWithImageNamed:@"menuBotao"];
    botaoMenu.position = CGPointMake(self.frame.size.width/2,self.frame.size.height / 3);
    botaoMenu.name = @"botaoMenuNode";//how the node is identified later
    botaoMenu.zPosition = 1.0;
    [self addChild:botaoMenu];
    //Botão play again
    SKSpriteNode* botaoReplay = [SKSpriteNode spriteNodeWithImageNamed:@"replaybutton2"];
    botaoReplay.size = CGSizeMake(botaoMenu.size.height, botaoMenu.size.height);
    botaoReplay.position = CGPointMake(self.size.width - botaoReplay.size.width, self.frame.size.height - (botaoReplay.size.height));
    botaoReplay.name = @"botaoReplay";
    botaoReplay.zPosition = 2.0;
    [self addChild:botaoReplay];
    //Resto
    self.ws = [[WSwebservice alloc]init];
    if ([nomeJogador isEqual: @""]) {
        nomeJogador = @"Anonymous Penguin";
    }
    self.score = score;
    self.nome = nomeJogador;
    self.lblRanking = [[SKLabelNode alloc]init];
    self.lblRanking.fontSize = 12;
    self.lblRanking.position = CGPointMake(self.size.width / 2, (self.size.height / 2) - 20);
    self.lblRanking.fontName = @"Helvetica Neue";
    SKSpriteNode* bg = [[SKSpriteNode alloc]initWithImageNamed:@"bgmenor"];
    bg.size = self.size;
    bg.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addChild:bg];
    //Mensagem Game Over
    SKLabelNode* gameOver = [[SKLabelNode alloc]init];
    gameOver.text = @"Game Over";
    gameOver.fontName = @"Helvetica Neue";
    gameOver.position = CGPointMake(self.size.width / 2, self.frame.size.height - 70);
    [self addChild:gameOver];
    SKLabelNode* lblScore = [[SKLabelNode alloc]init];
    lblScore.text = [NSString stringWithFormat:@"%@: %.f",self.nome,self.score];
    lblScore.position = CGPointMake(self.size.width/2, self.frame.size.height - 130);
    lblScore.fontName = @"Helvetica Neue";
    [self addChild:lblScore];
    // NSLog(@"There IS internet connection");
    self.myThread = [[NSThread alloc]initWithTarget:self selector:@selector(startThread) object:nil];
    [self.myThread start];
    
}

-(instancetype)initWithSize:(CGSize)size : (NSString*)nome : (float)score{
    if (self = [super initWithSize:size]) {
        [self initWithScore:score :nome ];
        
    }
    return self;
}

-(void)voltaJogo{
    // Configure the view.
    dispatch_async(dispatch_get_main_queue(), ^{
        SKView * skView = [ViewController sharedViewController].skView;
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        // Create and configure the scene.
        SKScene * scene = [[EmJogo alloc]initWithSize:self.view.bounds.size :self.nome ];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [skView presentScene:scene transition:[SKTransition pushWithDirection:SKTransitionDirectionUp duration:0.5]];
    });
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode*)[self nodeAtPoint:location];
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"botaoMenuNode"]) {
        node.texture = [SKTexture textureWithImageNamed:@"menuHighlight"];
    }
    //[self voltaJogo];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode*)[self nodeAtPoint:location];
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"botaoMenuNode"]) {
        [[ViewController sharedViewController]voltar];
    }
    if ([node.name isEqualToString:@"botaoReplay"]){
        [self voltaJogo];
    }
}

-(void)startThread{
    //NSLog(@"Startou Thread");
    NSArray *arrayDados = [[NSArray alloc]initWithObjects:[self nome],[NSString stringWithFormat:@"%.f",self.score], nil];
    //NSLog(@"%@     %@",[arrayDados objectAtIndex:0],[arrayDados objectAtIndex:1]);
    [self.ws postRanking:arrayDados];
    [self.myThread cancel];
}

-(void)atualizaRankingLocal:(float)novaPontuacao{
    float recordLocal = [[NSUserDefaults standardUserDefaults]floatForKey:@"recordLocal"];
    if (recordLocal < novaPontuacao) {
        [[NSUserDefaults standardUserDefaults]setFloat:novaPontuacao forKey:@"recordLocal"];
    }
}

@end
