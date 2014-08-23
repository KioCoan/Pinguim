//
//  MyScene.m
//  MiniChallenge
//
//  Created by Esdras Martins on 13/03/14.
//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//

#import "EmJogo.h"
#import "SKInfinityLevelNode.h"


#define CORRENDO 0
#define PULANDO 1
#define MORTO 2





@implementation EmJogo



-(id)initWithSize:(CGSize)size : (NSString*)nome{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.nomeJogador = nome;
        
        NSURL* urlMusica = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bebold" ofType:@"mp3"]];
        self.musica = [[AVAudioPlayer alloc]initWithContentsOfURL:urlMusica error:nil];
        
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"mutado"]){
            [self.musica setVolume:0];
        }else{
            [self.musica setVolume:0.8];
        }

        [[self musica]prepareToPlay];
        [self.musica setNumberOfLoops:-1];
        
        
        //Resto
        
        
        [self start];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    if (!self.jogoAtivo) {
        [[self musica]play];
    }
    
    UITouch *t = [touches anyObject];
    
    CGPoint location = [t locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"botaoVolume"]) {
        SKSpriteNode* nodeSprite = (SKSpriteNode*)node;
        [self mudaVolume:nodeSprite];
        return;
    }
    
    int forca = [t locationInView:self.view].y;
    
    [self.player pular:abs( ((forca/40) -8)*15 )];
    
    [self.physicsWorld removeAllJoints];
    self.jogoAtivo = TRUE;
    self.player.personagem.physicsBody.dynamic = YES;
    [[self floor] setMovingEnable];
    
    
}



-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKNode *corpo1 = contact.bodyA.node;
    SKNode *corpo2 = contact.bodyB.node;
    
    if(([corpo1.name isEqualToString: @"personagem"] && [corpo2.name isEqualToString:@"chao"]) ||([corpo1.name isEqualToString: @"chao"] && [corpo2.name isEqualToString:@"personagem"]) ){
        
        //NSLog(@"Colidiu com o chao");
        
        self.score += self.scoreCount;
        self.scoreCount = 0;
        [self.player mudaAnimacao:CORRENDO];
        [self.physicsWorld addJoint:[SKPhysicsJointPin jointWithBodyA:corpo1.physicsBody bodyB:corpo2.physicsBody anchor:corpo1.position]];
        
        
    }
    
    
//    NSLog(@"%.2f", self.score/100);

    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    // Lógica de quando o jogador estiver jogando
    
    // Lógica para criar o chao
    
    
    
    
    [self verificaMorte];
    if (self.jogoAtivo)
    {
        
        if(self.player.estado == PULANDO && (!self.querdaInicial)){
            self.scoreCount += 0.028;
        }
        if(self.player.estado == CORRENDO && (!self.querdaInicial)){
            self.score += self.scoreCount;
            self.scoreCount = 0;
        }
        
        if(self.player.estado == CORRENDO){
            self.querdaInicial = NO;
        }
        
        self.timer -= timeSinceLast * 60;
        
        if(self.timer <= 90 && !self.scoreCount)
        {
            //self.score += 100;
            //self.scoreCount = true;
            if (self.score > 0)
            {
                //[self runAction:[SKAction playSoundFileNamed:@"beep.wav" waitForCompletion:NO]];
            }
            
        }
        
        if(self.timer <= 0)
        {
            //contouPonto = false;
            self.timer = 20;
            [[self floor] addFloor];
        }
        self.lblScore.text = [NSString stringWithFormat:@"Score: %.f", self.score];
    }
}

// Chamado antes de cada quadro ser renderizado
- (void)update:(CFTimeInterval)currentTime
{
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1)
    { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}


-(void)start {
    
    [self removeAllChildren];
    self.score = 0.0;
    self.player.estado = PULANDO;
    self.querdaInicial = YES;
    
    //Posiciona lblScore
    
    self.lblScore = [[SKLabelNode alloc]init];
    self.lblScore.position = CGPointMake(self.size.width - 50, self.size.height - 50);
    self.lblScore.text = [NSString stringWithFormat:@"Score: %.f",self.score /100 ];
    self.lblScore.zPosition = 150;
    self.lblScore.fontSize = 15;
    //self.lblScore.fontName = @"Helvetica Neue";
    [self addChild:self.lblScore];
    
    //Botão de mutar
    [self geraBotaoVolume];
    
    //Background
    SKTexture *bg = [SKTexture textureWithImageNamed:@"bgMenor"];
    SKSpriteNode *nodeBg = [[SKSpriteNode alloc]initWithTexture:bg];
    nodeBg.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    nodeBg.position = CGPointMake(self.size.width / 2,self.size.height / 2);
    
    [self.scene addChild:nodeBg];
    
    //Música
    
    
    self.player = [[Personagem alloc] init];
    
    self.physicsWorld.gravity = CGVectorMake( 0.0, -9 );
    self.physicsWorld.contactDelegate = self;
    [self setBackgroundColor:[SKColor blueColor]];
    
    
    
    [self addChild: self.player.personagem];
    
    
    
    SKTexture *textureFloor = [SKTexture textureWithImageNamed:@"rect"];
    CGPoint initialPos = CGPointMake(190, 10);
    CGSize size = CGSizeMake(100, 100);
    
    [self setFloor:[[SKInfinityLevelNode alloc] initWithTexture:textureFloor andPosition:initialPos andSize:size]];
    [self addChild:[self floor]];
    
    
    
    uint32_t bitInimigo = 1 << 2;
    
    
    //        uint32_t bitDummy = 1 << 1;
    
    
    SKSpriteNode* dummy = [[SKSpriteNode alloc] init];
    dummy.size = CGSizeMake(10, self.size.height*3);
    dummy.position = CGPointMake(self.size.width, self.size.height/2);
    dummy.name = @"dummy";
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:dummy.size];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    
    
    //dummy.physicsBody.categoryBitMask = bitDummy;
    
    [self.player adicionarColisao:[self.floor categoriaChao] :bitInimigo];
    
    
    
    
    
}

-(void)verificaMorte{
    
    
    if(self.player.personagem.position.y < -5){
        
        self.jogoAtivo = NO;
        [self.physicsWorld removeAllJoints];
        
     
        [self mudaScene];
        
        //[self start];
    }
    
    if(self.player.personagem.position.x < -5){
        self.jogoAtivo = NO;
        [self.physicsWorld removeAllJoints];
        //[self start];
        
        [self mudaScene];
    }
    
}

-(void)mudaScene{
    // Configure the view.
    //SKView * skView = (SKView *)self.view;
    //skView.showsFPS = NO;
    //skView.showsNodeCount = NO;
    [ViewController sharedViewController].skView.showsFPS = NO;
    [ViewController sharedViewController].skView.showsNodeCount = NO;
    
    float scoreValue = [[NSString stringWithFormat:@"%.f",self.score]floatValue];
    
    // Create and configure the scene.
    SKScene * scene = [[Ranking alloc]initWithSize:self.view.bounds.size : self.nomeJogador : scoreValue];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [[ViewController sharedViewController].skView presentScene:scene];
}

-(void)geraBotaoVolume{
    BOOL mutado = [[NSUserDefaults standardUserDefaults]boolForKey:@"mutado"];
    
    NSString* stringBotao = [[NSString alloc]init];
    
    if(mutado){
       stringBotao = @"volumeMute.png";
    }else{
       stringBotao = @"volume.png";
    }
    
    SKTexture* iconeVolume = [SKTexture textureWithImageNamed:stringBotao];
    SKSpriteNode* botaoVolume = [SKSpriteNode spriteNodeWithTexture:iconeVolume];
    botaoVolume.size = CGSizeMake(40, 40);
    botaoVolume.zPosition = 15;
    botaoVolume.name = @"botaoVolume";
    
    botaoVolume.position = CGPointMake(botaoVolume.size.width, self.size.height - botaoVolume.size.height);
    [self addChild:botaoVolume];
}

-(void)mudaVolume:(SKSpriteNode*)botao{
     BOOL mutado = [[NSUserDefaults standardUserDefaults]boolForKey:@"mutado"];
    if (mutado) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"mutado"];
        botao.texture = [SKTexture textureWithImageNamed:@"volume"];
        self.musica.volume = 0.8;
    }else{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"mutado"];
        botao.texture = [SKTexture textureWithImageNamed:@"volumeMute"];
        self.musica.volume = 0;

    }
}

@end
