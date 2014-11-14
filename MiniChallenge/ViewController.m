//
//  ViewController.m
//  MiniChallenge
//
//  Created by Esdras Martins on 13/03/14.
//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//

#import "ViewController.h"
#import "EmJogo.h"


@implementation ViewController


+(ViewController*)sharedViewController{
    static ViewController *sharedViewController;
    if (!sharedViewController)
    {
        sharedViewController = [[super allocWithZone:nil]init];
    }
    return sharedViewController;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedViewController];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
 
   
    // Configure the view
    
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self recordLocal];
}

-(void)viewDidLoad{
  
    _adLiberado = NO;
    //adstuff
    _ad = [[GADInterstitial alloc]init];
    _ad.adUnitID = @"ca-app-pub-1972944779905269/7379245630";
    GADRequest* request = [[GADRequest alloc]init];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [_ad loadRequest:request];
    _ad.delegate = self;
    
    
    //gamestuff
    [[self txtNome]setDelegate:self];
    
    NSURL* urlMusica = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tgif" ofType:@"mp3"]];
    _musicaInicio = [[AVAudioPlayer alloc]initWithContentsOfURL:urlMusica error:nil];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"mutado"]){
        [_musicaInicio setVolume:0];
    }else{
        [_musicaInicio setVolume:0.8];
    }
    
    [_musicaInicio setNumberOfLoops:-1];
    [_musicaInicio prepareToPlay];
    [_musicaInicio play];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];

    _rankingAberto = NO;
    _partidasJogadas = 0;
}


- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.x = -35.0f;  //set the -35.0f to your required value
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.x = 0.0f;
        self.view.frame = f;
    }];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)iniciaGame:(UIButton *)sender {
    
    [self desabilitaObjetos];
    
    self.skView = (SKView *)self.view;
    _skView.showsFPS = NO;
    _skView.showsNodeCount = NO;
    // Create and configure the scene.
    
    SKScene * scene = [[EmJogo alloc]initWithSize:self.skView.bounds.size :self.txtNome.text ];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [_skView presentScene:scene];

}
- (void)voltar
{
    [self.skView presentScene:nil];
    [self habilitarObjetos];
    [self.musicaInicio prepareToPlay];
    [self.musicaInicio play];
    [self recordLocal];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"mutado"]){
        [_musicaInicio setVolume:0];
    }else{
        [_musicaInicio setVolume:0.8];
    }
}

-(void)desabilitaObjetos
{
    [self.txtNome resignFirstResponder];
    [self.musicaInicio stop];
    self.musicaInicio.currentTime = 0;
    self.imgFundo.alpha = 0;
    self.txtNome.alpha = 0;
    self.lblNome.alpha = 0;
    self.btnRanking.alpha = 0;
    self.btnPlay.alpha = 0;
    self.lblRecord.alpha = 0;
    self.imgPinguim.alpha = 0;
}

-(void)habilitarObjetos
{
    self.imgFundo.alpha = 1;
    self.txtNome.alpha = 1;
    self.lblNome.alpha = 1;
    self.btnRanking.alpha = 1;
    self.btnPlay.alpha = 1;
    self.lblRecord.alpha = 1;
    self.imgPinguim.alpha = 0.09;
}

- (IBAction)abreRanking:(id)sender {
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@":("
                                                        message:@"Sem internet, sem olhar o ranking dos brothers\n #sad"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        
        if(!_rankingAberto){
        _listaRanking = [[WSwebservice alloc]getRanking];
        _viewRanking = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * 0.25, -self.view.frame.size.height * 0.95, self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.95)];
            
        _viewRanking.backgroundColor = [UIColor blackColor];
        [[self view]addSubview:_viewRanking];
        UIButton* fecharView = [[UIButton alloc] initWithFrame:CGRectMake(_viewRanking.frame.size.width / 2 - 25, 280, 60, 20)];
        [fecharView setTitle:@"Fechar" forState:UIControlStateNormal];
        [fecharView addTarget:self action:@selector(deletaView) forControlEvents:UIControlEventTouchUpInside];
        [_viewRanking addSubview:fecharView];
        //Monta ranking na tableview
        CGRect frameDaTable = CGRectMake(12, 5, _viewRanking.bounds.size.width * 0.9, _viewRanking.bounds.size.height * 0.9);
        _tableView = [[UITableView alloc]initWithFrame:frameDaTable style:UITableViewStylePlain];
        _tableView.rowHeight = 25;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.userInteractionEnabled = YES;
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView reloadData];
        [_viewRanking addSubview:_tableView];
        
        [UIView animateWithDuration:0.3 animations:^{
            _viewRanking.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
        }];
            _rankingAberto = YES;
       }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.txtNome resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



-(void)deletaView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.viewRanking.frame;
        f.origin.y = -f.size.height;
        self.viewRanking.frame = f;
    }];
    
    [self performSelector:@selector(confirmaDeletar) withObject:nil afterDelay:1];
   
}

-(void)confirmaDeletar{
    [self.viewRanking removeFromSuperview];
    _rankingAberto = NO;
}

//Coisas da TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [_listaRanking count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"Ranking";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSString* nome = [[_listaRanking objectAtIndex:indexPath.row]objectAtIndex:0];
    NSString* score = [[_listaRanking objectAtIndex:indexPath.row]objectAtIndex:1];
    cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
    cell.textLabel.text = [NSString stringWithFormat:@"%ldº %@ - %@",(long)indexPath.row + 1,nome,score];
    return cell;
}

-(void)recordLocal{
    NSString* recordLocal = [NSString stringWithFormat:@"Record: %.f",[[NSUserDefaults standardUserDefaults]floatForKey:@"recordLocal"]];
    self.lblRecord.text = recordLocal;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial{
    _adLiberado = YES;
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
   // NSLog(@"deu pau no ad");
    _adLiberado = NO;
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    _ad = [[GADInterstitial alloc]init];
    _ad.adUnitID = @"ca-app-pub-1972944779905269/7379245630";
    GADRequest* request = [[GADRequest alloc]init];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [_ad loadRequest:request];
    _ad.delegate = self;
}

-(void)showAd{
    if(_adLiberado){
        if(_partidasJogadas == 3){
            _partidasJogadas = 0;
            [_ad presentFromRootViewController:self];
        }else{
            _partidasJogadas++;
        }
    }
}
@end
