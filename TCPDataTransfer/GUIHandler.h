//
//  GUIHandler.h
//  TCPDataTransfer
//
//  Created by Vitaliy Yarkun on 4/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ClientThread.h"
#import "ServerThread.h"

@interface GUIHandler : NSObject{
    ServerThread* obj_server_thread;
    ClientThread* obj_client_thread;
    @public
    __weak IBOutlet NSTextField *tx_recv_data;
    __weak IBOutlet NSTextField *tx_send_data;
    
}

@end
