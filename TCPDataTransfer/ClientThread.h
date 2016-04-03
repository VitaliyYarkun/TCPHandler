//
//  ClientThread.h
//  TCPDataTransfer
//
//  Created by Vitaliy Yarkun on 4/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface ClientThread : NSThread{
    CFSocketRef obj_client;
    @public
    NSTextField* tx_recv;
}

-(void) initializeClient;
-(void) initializeNative:(CFSocketNativeHandle) native_socket showRecievedData:(NSTextField *) target_text_field;
-(void) main;
-(void) disconnectFromServer;
-(void) sendTCPDataPacket:(const char*) data;
-(char*) readData;

@end
