//
//  ServerThread.h
//  TCPDataTransfer
//
//  Created by Vitaliy Yarkun on 4/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include <sys/socket.h>
#include <netinet/in.h>

@interface ServerThread : NSThread{
    
    CFSocketRef obj_server;
    @public
    NSTextField* tx_recv;
}

-(void) main;
-(void) initializeServer:(NSTextField *) target_text_field;
-(void) stopServer;

@end
