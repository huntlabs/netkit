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

import std.socket;


class NetClient {

    public this(Netkit netkit, NetClientOptions options)
    {
        _options = options;
    }

    public NetClient connect(string ip, ushort port, connet_handler handler = null)
    {
        if (_options._block)
        {
            _blockSocket = new TcpSocket();
            _blockSocket.connect(new InternetAddress(ip, port));
        }
        else 
        {
            _bootStrap = new ServerBootstrap();
            _connectHandler = handler;
            _clientSocket = new NetClientSocket(_bootStrap);
            _clientSocket.setConnectHandler(_connectHandler);
            _clientSocket.connect(ip, port);
            _bootStrap.start();
        }
        return this;
    }

    public long read(byte[] buf)
    {
        if (_options._block) {
            return _blockSocket.receive(buf);
        }
        else {
            return -1;
        }
    } 

    public long write(byte[] buf)
    {
        if (_options._block) {
            return _blockSocket.send(buf);
        }
        else {
            return -1;
        }
    } 

    public void close()
    {
        if (_options._block) {
            _blockSocket.close();
        }
        else {
            _clientSocket.close();
        }
    }



private:
    connet_handler _connectHandler;
    NetClientSocket _clientSocket;
    ServerBootstrap _bootStrap;
    NetClientOptions _options;
    Socket _blockSocket;

 
    
}   