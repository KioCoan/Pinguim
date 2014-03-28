//
//  WSwebservice.h
//  WsGame
//
//  Created by Kio Coan on 17/03/14.
//  Copyright (c) 2014 Caio Coan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface WSwebservice : NSObject
{
    NSMutableArray *resultado;
    NSString *nomes,*scores;
}
@property NSMutableArray* resultado;
@property NSString *nomes,*scores;
@property NSData* acesso;

-(NSMutableArray*)getRanking;
-(void)SalvarRanking:(NSArray*)dados;


@end