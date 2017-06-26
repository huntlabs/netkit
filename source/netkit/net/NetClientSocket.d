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

module netkit.net.NetClientSocket;

import netkit.net.NetSocket;
import netkit.net.ServerBootstrap;
import netkit.common.Common;
import netkit.net.NetClientOptions;

import kiss.aio.AsynchronousSocketChannel;
import kiss.aio.CompletionHandle;
import kiss.aio.task;
import kiss.aio.ByteBuffer;

import std.stdio;

class ConnectHandler : ConnectCompletionHandle {
    this(NetClientSocket master)
    {   
        _master = master;
    }
    override void completed( void* attachment) {
        _master._connectHandler(_master);
    }
    override void failed(void* attachment)
    {
        _master._connectHandler(null);
    }
private:
    NetClientSocket _master;
}

class ReadHandler : ReadCompletionHandle {
    this(NetClientSocket master)
    {   
        _master = master;
    }
    override void completed(void* attachment, size_t count , ByteBuffer buffer) {
        _master._readHandler(buffer);
        _master._readBuffer.clear();
    }
    override void failed(void* attachment) {
        _master._readHandler(null);
        _master._readBuffer.clear();
    }
private:
    NetClientSocket _master;
}

class WriteHandler : WriteCompletionHandle {
    this(NetClientSocket master)
    {   
        _master = master;
    }
    override void completed(void* attachment, size_t count , ByteBuffer buffer) {
    }
    override void failed(void* attachment) {
    }
private:
    NetClientSocket _master;
}





class NetClientSocket : NetSocket{

    //读缓存大小
    public int READ_BUFFER_LEN = 1024*20;

    this(ServerBootstrap boot)
    {
        AsynchronousSocketChannel channel = AsynchronousSocketChannel.open(boot.getGroup(), boot.getGroup().getWorkSelector());
        this(boot, channel);

    }
    
    this(ServerBootstrap boot, AsynchronousSocketChannel channel)
    {
  
        _clientChannel = channel;
        _boot = boot;
        _readBuffer = ByteBuffer.allocate(READ_BUFFER_LEN);
        _readCompletionHandle = new ReadHandler(this);
        _writeCompletionHandle = new WriteHandler(this);
    }

    public NetClientSocket setConnectHandler(connet_handler handler)
    {
        _connectHandler = handler;
        return this;
    }

    public NetClientSocket connect(string ip, int port)
    {
        _ip = ip;
        _port = port;
        _connectCompletionHandle = new ConnectHandler(this);
        _clientChannel.connect(ip, cast(ushort)port, _connectCompletionHandle, null);
        return this;
    }

    override public NetSocket write(ByteBuffer data)
    {   

        _clientChannel.write(data, _writeCompletionHandle, null);	

        return this;
    }

    override public NetSocket write(string data)
    {   
        _clientChannel.write(data, _writeCompletionHandle, null);	
        return this;
    }



    

    //注册处理接收数据
    override public NetSocket handler(buffer_handler readHandler)
    {
        _readHandler = readHandler;
        doRead();
        return this;
    }

    public void doRead()
    {
        _readBuffer.clear();
        _clientChannel.read(_readBuffer, _readCompletionHandle, null);
    }


    override public NetSocket close() 
    {
        _clientChannel.close();
        return this;
    }


public:
    ByteBuffer _readBuffer;
    
private:
    ByteBuffer[] _writeBufferList;
    
    AsynchronousSocketChannel _clientChannel;
    ConnectHandler _connectCompletionHandle;
    ReadHandler _readCompletionHandle;
    WriteHandler _writeCompletionHandle;

}
