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

module netkit.net.NetClient;

import netkit.common.Common;
import netkit.net.NetClientOptions;
import netkit.net.NetClientSocket;
import netkit.net.ServerBootstrap;
import netkit.Netkit;

class NetClient {

    public this(Netkit netkit, NetClientOptions options)
    {

    }

    public NetClient connect(string ip, int port, connet_handler handler)
    {
        
        _bootStrap = new ServerBootstrap();
        _connectHandler = handler;
        _clientSocket = new NetClientSocket(_bootStrap);
        _clientSocket.setConnectHandler(_connectHandler);
        _clientSocket.connect(ip, port);
        _bootStrap.start();
        return this;
    }


private:
    connet_handler _connectHandler;
    NetClientSocket _clientSocket;
    ServerBootstrap _bootStrap;
    

 
    
}   