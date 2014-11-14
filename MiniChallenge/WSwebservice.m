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
                         [NSURL URLWithString:@"http://www.caiocoan.com/wsPepes/listarPlayers.php"]];
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
       // NSLog(@"Nome: %@ Score: %@\n",nomes,scores);
        [[self resultado] addObject:[NSArray arrayWithObjects:nomes,scores, nil]];
    }
    return [self resultado];
}

-(void)postRanking:(NSArray *)dados{
    NSString *nome,*score,*token,*post;
    nome = [dados objectAtIndex:0];
    score = [dados objectAtIndex:1];
    token = [NSString stringWithFormat:@"%d",[self geraToken:score.intValue nome:nome]];
    //www.caiocoan.com/wsPepes/ranking.php
    post = [NSString stringWithFormat:@"nome=%@&score=%@&token=%@",nome,score,token];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString* postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    request.URL = [NSURL URLWithString:@"http://www.caiocoan.com/wsPepes/ranking.php"];
    request.HTTPMethod = @"POST";
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    //NSURLConnection* conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    //conn ? NSLog(@"Postou") : NSLog(@"Nop");
}

-(void)SalvarRanking:(NSArray *)dados{
    NSString* nome,*score,*token;
    nome = [dados objectAtIndex:0];
    score = [dados objectAtIndex:1];
    token = [NSString stringWithFormat:@"%d",[self geraToken:score.intValue nome:nome]];
    NSString* format = [NSString stringWithFormat:@"http://www.420blazeitswag.com/wsGame/functions.php?funcao=saveRanking&nome=%@&score=%@&token=%@",nome,score,token];
    NSData *data = [format dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString* url = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    _acesso = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
    //NSLog(@"Terminou salvar ranking");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Erro na conexão: %ld", (long)error.code);
}

-(int)geraToken:(int)score nome:(NSString *)nome{
    int chars = (int)[nome length];
    chars *= 3;
    int token = chars + (score * 2);
    return token;
}

@end
