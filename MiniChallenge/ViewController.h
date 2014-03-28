//
//  ViewController.h
//  MiniChallenge
//

//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WSwebservice.h"


@interface ViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property SKView* skView;
- (IBAction)iniciaGame:(id)sender;
- (IBAction)abreRanking:(id)sender;

@property BOOL rankingAberto;

@property (weak, nonatomic) IBOutlet UILabel *lblNome;
@property (weak, nonatomic) IBOutlet UIImageView *imgFundo;
@property (weak, nonatomic) IBOutlet UITextField *txtNome;
@property (weak, nonatomic) IBOutlet UIButton *btnRanking;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property AVAudioPlayer* musicaInicio;

//ranking stuff
@property UITableView* tableView;
@property NSMutableArray* listaRanking;
@property UIView* viewRanking;

-(void)deletaView;

+ (ViewController *)sharedViewController;
+ (id)allocWithZone:(struct _NSZone *)zone;

- (void)voltar;
- (void)habilitarObjetos;
-(void)desabilitaObjetos;


@end