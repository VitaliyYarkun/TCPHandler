//
//  ClientThread.m
//  TCPDataTransfer
//
//  Created by Vitaliy Yarkun on 4/3/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "ClientThread.h"

@implementation ClientThread

-(void) initializeClient
{
    CFSocketContext sctx = {0,(__bridge void *)(self),NULL, NULL,  NULL};
    obj_client = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack, TCPClientCallBackHandler, &sctx);
    struct sockaddr_in sock_addr;
    memset(&sock_addr, 0, sizeof(sock_addr));
    sock_addr.sin_len = sizeof(sock_addr);
    sock_addr.sin_family = AF_INET;
    sock_addr.sin_port = htons(6658);
    sock_addr.sin_addr.s_addr = INADDR_ANY;
    
    inet_pton(AF_INET, "127.0.0.1", &sock_addr.sin_addr);
    CFDataRef dref = CFDataCreate(kCFAllocatorDefault, (UInt8*)&sock_addr, sizeof(sock_addr));
    CFSocketConnectToAddress(obj_client, dref, -1);
    CFRelease(dref);

}
-(void) main
{
    CFRunLoopSourceRef loopref = CFSocketCreateRunLoopSource(kCFAllocatorDefault, obj_client, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), loopref, kCFRunLoopDefaultMode);
    CFRelease(loopref);
    CFRunLoopRun();
    
}
-(void) sendTCPDataPacket:(const char*) data
{
    int initialize[1] = {2};
    int separator[1] = {4};
    int data_length = (int)strlen(data);
    int target_length = snprintf(NULL, 0, "%d",data_length);
    char* data_length_char = malloc(target_length+1);
    snprintf(data_length_char, target_length+1, "%d",data_length);
    
    int ele_count = (int)strlen(data_length_char);
    int *size_buff = (int*)malloc(ele_count*sizeof(int));
    
    for (int counter = 0; counter < ele_count; counter++) {
        size_buff[counter] = (int)data_length_char[counter];
    }
    
    int packet_length = 1+1+ele_count+(int)strlen(data);
    UInt8* packet = (UInt8*)malloc(packet_length * sizeof(UInt8));
    
    memcpy(&packet[0], initialize, 1);
    for (int counter = 0; counter < ele_count; counter++) {
        memcpy(&packet[counter+1], &size_buff[counter], 1);
    }
    
    memcpy(&packet[0+1+ele_count], separator, 1);
    memcpy(&packet[0+1+ele_count+1], data, strlen(data));
    CFDataRef dref = CFDataCreate(kCFAllocatorDefault, packet, packet_length);
    CFSocketSendData(obj_client, NULL, dref, -1);
    free(packet);
    free(size_buff);
    free(data_length_char);
    CFRelease(dref);
    
}

-(void) initializeNative:(CFSocketNativeHandle) native_socket showRecievedData:(NSTextField *) target_text_field
{
    tx_recv = target_text_field;
    CFSocketContext sctx = {0,(__bridge void *)(self),NULL, NULL,  NULL};
    obj_client = CFSocketCreateWithNative(kCFAllocatorDefault, native_socket, kCFSocketReadCallBack, TCPClientCallBackHandler, &sctx);
}

-(char*) readData
{
    char* data_buff;
    NSMutableString* buff_length = [[NSMutableString alloc] init];
    char buff[1];
    read(CFSocketGetNative(obj_client), &buff, 1);
    while ((int)*buff != 4) {
        [buff_length appendFormat:@"%c",(char)(int)*buff];
        read(CFSocketGetNative(obj_client), &buff, 1);
    }
    int data_length = [[buff_length stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] intValue];
    data_buff = (char*)malloc(data_length*sizeof(char));
    ssize_t byte_read = 0;
    ssize_t byte_offset = 0;
    while (byte_offset < data_length) {
        byte_read = read(CFSocketGetNative(obj_client), data_buff+byte_offset, 50);
        byte_offset += byte_read;
    }
    return data_buff;
}

void TCPClientCallBackHandler(CFSocketRef s, CFSocketCallBackType callbacktype, CFDataRef address, const void *data, void *info)
{
    switch (callbacktype) {
        case kCFSocketConnectCallBack:
            if(data){
                CFSocketInvalidate(s);
                CFRelease(s);
                CFRunLoopStop(CFRunLoopGetCurrent());
            }
            else{
                NSLog(@"Client connected to server");
            }
            break;
        case kCFSocketReadCallBack:
        {
            char* buff[1];
            read(CFSocketGetNative(s), &buff, 1);
            if((int)*buff == 2){
                ClientThread* obj_client_ptr = (__bridge ClientThread*)info;
                char* recv_data = [obj_client_ptr readData];
                [obj_client_ptr->tx_recv setStringValue:[NSString stringWithUTF8String:recv_data]];
                free(recv_data);
            }
        }
            break;
        default:
            break;
    }
    
}

-(void) disconnectFromServer
{
    CFSocketInvalidate(obj_client);
    CFRelease(obj_client);
    CFRunLoopStop(CFRunLoopGetCurrent());
}









@end
