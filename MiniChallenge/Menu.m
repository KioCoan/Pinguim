//
//  Menu.m
//  MiniChallenge
//
//  Created by Kio Coan on 23/03/14.
//  Copyright (c) 2014 Caio Coan. All rights reserved.
//

#import "Menu.h"

@implementation Menu

-(void)startGame{
    
}

-(void)showRanking{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"Ranking do jogo Bolado";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
   // NSString* nome = [[_listaRanking objectAtIndex:indexPath.row]objectAtIndex:0];
   // NSString* score = [[_listaRanking objectAtIndex:indexPath.row]objectAtIndex:1];
   // cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
   // cell.textLabel.text = [NSString stringWithFormat:@"%ldº %@ - %@",(long)indexPath.row + 1,nome,score];
    return cell;
}

@end
