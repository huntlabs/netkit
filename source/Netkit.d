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

module netkit.Netkit;

import netkit.net.NetServer;
import netkit.net.NetServerOptions;
import netkit.net.NetClient;
import netkit.net.NetClientOptions;
import netkit.common.Common;

import kiss.aio.AsynchronousChannelThreadGroup;

class Netkit {

public:
    this() { _eventLoopGroup = AsynchronousChannelThreadGroup.open(); }
    NetServer createNetServer(NetServerOptions options) { return new NetServer(this, options); }
    NetClient createNetClient(NetClientOptions options) { return new NetClient(this, options); }
    long setTimer(long delay, timer_handler handler){ return 0; }



private:
    AsynchronousChannelThreadGroup _eventLoopGroup;
   
    
}