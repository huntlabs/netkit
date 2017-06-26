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

module netkit.net.NetServer;

import netkit.Netkit;

import netkit.net.NetServerOptions;
import netkit.net.NetSocket;
import netkit.net.NetServerSocket;
import netkit.net.ServerBootstrap;
import netkit.common.Common;
import netkit.utils.NetkitException;

import std.stdio;

class NetServer {

    public this(Netkit netkit, NetServerOptions options)
    {

    }
    public NetServer connectHandler(connet_handler handler)
    {
        if (_listening)
            throw new NetkitException("Cannot set connectHandler when server is listening");
        _connectHandler = handler;
        return this;
    }
    public NetServer listen(string ip, int port, linsten_handler listenHandler)
    {
        return listen(_connectHandler, ip, port, listenHandler, false);
    }
    public NetServer listen(string ip, int port)
    {
        return listen(_connectHandler, ip, port, null, true);
    }
    


    private NetServer listen(connet_handler connectHandler, string ip, int port, linsten_handler listenHandler, bool blockMode)
    {
        if (connectHandler is null)
            throw new NetkitException("Set connect handler first");
        if (_listening)
            throw new NetkitException("Listen already called");
        _listening = true;
        _blockMode = blockMode;
        _connectHandler = connectHandler;
        _bootStrap = new ServerBootstrap();
        _serverSocket = new NetServerSocket(_bootStrap);
        _serverSocket.setConnectHandler(_connectHandler);
        _serverSocket.bind(ip, port);
        _bootStrap.start();
        
        if (listenHandler)
        {
            listenHandler(true, this);
        }
        return this;
    }


protected:
    connet_handler _connectHandler;
    ServerBootstrap _bootStrap;

private:
    bool _listening;
    //block mode
    bool _blockMode;
    NetServerSocket _serverSocket;
    





}