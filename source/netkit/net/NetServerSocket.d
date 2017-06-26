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

module netkit.net.NetServerSocket;

import netkit.net.NetSocket;
import netkit.net.ServerBootstrap;
import netkit.net.NetClientSocket;
import netkit.common.Common;

import kiss.aio.AsynchronousServerSocketChannel;
import kiss.aio.AsynchronousSocketChannel;
import kiss.aio.CompletionHandle;
import kiss.aio.ByteBuffer;

class AcceptHandler : AcceptCompletionHandle {

    this(NetServerSocket master)
    {   
        _master = master;
    }
    override void completed(void* attachment, AsynchronousSocketChannel result)
    {
        NetClientSocket client = new NetClientSocket(_master._boot, result);
        _master._connectHandler(client);
    }
    override void failed(void* attachment)
    {
        _master._connectHandler(null);
    }
private:
    NetServerSocket _master;
}


class NetServerSocket : NetSocket {

    this(ServerBootstrap boot)
    {
        _boot = boot;
        _serverChannel = AsynchronousServerSocketChannel.open(boot.getGroup());
        _acceptHandler = new AcceptHandler(this);
        
    }
    public NetServerSocket setConnectHandler(connet_handler handler)
    {
        _connectHandler = handler;
        return this;
    }
    public NetServerSocket bind(string ip, int port)
    {
        _ip = ip;
        _port = port;
        _serverChannel.bind(ip, cast(ushort)port);
        _serverChannel.accept(null, _acceptHandler);   
        return this;
    }

    override public NetSocket handler(buffer_handler readHandler) { return this; }
    override public NetSocket write(ByteBuffer data) { return this; }
    override public NetSocket write(string data) { return this; }
    override public NetSocket close() { return this; }


private:
    AsynchronousServerSocketChannel _serverChannel;
    AcceptHandler _acceptHandler;
    

}