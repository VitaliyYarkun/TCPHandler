//
//  GUIHandler.m
//  TCPDataTransfer
//
//  Created by Vitaliy Yarkun on 4/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "GUIHandler.h"

@implementation GUIHandler


- (IBAction)startServerAction:(id *)sender
{
    obj_server_thread = [[ServerThread alloc]  init];
    [obj_server_thread initializeServer:tx_recv_data];
    [obj_server_thread start];
}

- (IBAction)stopServerAction:(id)sender
{
    [obj_server_thread stopServer];
    [obj_server_thread cancel];
}
- (IBAction)connectToServerAction:(id)sender
{
    obj_client_thread = [[ClientThread alloc] init];
    [obj_client_thread initializeClient];
    [obj_client_thread start];
}

- (IBAction)disconnectFromServerAction:(id)sender
{
    [obj_client_thread disconnectFromServer];
    [obj_client_thread cancel];
    
}
- (IBAction)sendDataToServerAction:(id)sender
{
    [obj_client_thread sendTCPDataPacket:[[tx_send_data stringValue] UTF8String]];
}



@end
