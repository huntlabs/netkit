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

module netkit.net.NetSocket;
import netkit.common.Common;
import netkit.net.ServerBootstrap;

import kiss.aio.AsynchronousServerSocketChannel;
import kiss.aio.ByteBuffer;

class NetSocket {

    this(){}
    abstract public NetSocket handler(buffer_handler readHandler);
    abstract public NetSocket write(ByteBuffer data);
    abstract public NetSocket write(string data);
    abstract public NetSocket close();


protected:
    string _ip;
    int _port;

public:
    buffer_handler _readHandler;
    connet_handler _connectHandler;
    ServerBootstrap _boot;


}