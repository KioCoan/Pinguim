//
//  WSwebservice.m
//  WsGame
//
//  Created by Kio Coan on 17/03/14.
//  Copyright (c) 2014 Caio Coan. All rights reserved.
//

#import "WSwebservice.h"

@implementation WSwebservice


@synthesize resultado,nomes,scores;

-(NSMutableArray *)getRanking{
    NSData* jsonDados = [[NSData alloc] initWithContentsOfURL:
                         [NSURL URLWithString:@"http://www.420blazeitswag.com/wsGame/functions.php?funcao=getRanking"]];
    NSError *error;
    NSMutableDictionary *jsonRanking = [NSJSONSerialization
                                        JSONObjectWithData:jsonDados
                                        options:NSJSONReadingMutableContainers
                                        error:&error];
    NSArray* rankingList = [jsonRanking objectForKey:@"ranking"];
    resultado = [[NSMutableArray alloc]init];
    for(int i=0;i < [rankingList count];i++){
        NSDictionary* ranking = [rankingList objectAtIndex:i];
        nomes = [ranking objectForKey:@"NOME"];
        scores = [ranking objectForKey:@"SCORE"];
        NSLog(@"Nome: %@ Score: %@\n",nomes,scores);
        [[self resultado] addObject:[NSArray arrayWithObjects:nomes,scores, nil]];
    }
    return [self resultado];
}

-(void)SalvarRanking:(NSArray *)dados{
    NSString* nome,*score,*token;
    nome = [dados objectAtIndex:0];
    score = [dados objectAtIndex:1];
    token = @"bee0836567f8ea97646b4c57a79473e3";
    NSString* format = [NSString stringWithFormat:@"http://www.420blazeitswag.com/wsGame/functions.php?funcao=saveRanking&nome=%@&score=%@&token=%@",nome,score,token];
    NSData *data = [format dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString* url = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    _acesso = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"Terminou salvar ranking");
    
}

@end
