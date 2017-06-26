/*
 * NetKit - This library contains tcp / http / http2 / websocket servers and clients.
 *
 * Copyright (C) 2015-2017  Shanghai Putao Technology Co., Ltd
 *
 * Developer: HuntLabs
 *
 * Licensed under the Apache-2.0 License.
 *
 */

import netkit.Netkit;
import netkit.net.NetServerOptions;
import netkit.net.NetSocket;
import netkit.net.NetServer;
import netkit.common.Common;
import netkit.net.NetClientOptions;

import kiss.aio.ByteBuffer;

import std.stdio;
import core.thread;
import std.format;
import std.parallelism;

void main() 
{   
    for(int i = 0; i < totalCPUs; i++)
    {
        Netkit netkit = new Netkit();
        NetServerOptions options = new NetServerOptions();
        netkit.createNetServer(options)
            .connectHandler((NetSocket soc){
                //register read handler
                soc.handler( (ByteBuffer buffer) {
                    writeln("server recv : ", cast(string)buffer.getExsitBuffer());
                    soc.write("hello client!");
                    // soc.write("HTTP/1.0 200 OK\r\nServer: kiss\r\nContent-Type: text/plain\r\nContent-Length: 10\r\n\r\nhelloworld");
                    // soc.close();
                });

            })
            .listen("0.0.0.0", 10001, 
            (bool success, NetServer so) {
                writeln("listenHandler");
                 if (success)
                 {
                    NetClientOptions _options = new NetClientOptions();
                    netkit.createNetClient(_options).connect("0.0.0.0", 10001, (NetSocket so) {
                        //do write
                        ByteBuffer buff = ByteBuffer.allocate(1024);
                        buff.put(cast(byte[])"hello server!");
                        so.write(buff);
                        //register read handler
                        so.handler((ByteBuffer b){
                            writeln("client recv : ", cast(string)b.getCurBuffer());
                            so.write("hello server!");
                        });
                    });
                 }
            });
    }
}
