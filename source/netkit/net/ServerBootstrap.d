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

module netkit.net.ServerBootstrap;

import kiss.aio.AsynchronousChannelThreadGroup;
import kiss.aio.AsynchronousChannelSelector;

import std.parallelism;

class ServerBootstrap {

    public this(int timeout = 10, int threadNum = totalCPUs)
    {
        _threadNum = threadNum;
        _group = AsynchronousChannelThreadGroup.open(timeout, threadNum);
    }



    public void start()
    {
        _group.start();
        // _group.wait();
    }

    public AsynchronousChannelThreadGroup getGroup()
    {
        return _group;
    }


    public AsynchronousChannelSelector getWorkSelector()
    {
        return _group.getWorkSelector();
    }




private:
    int _threadNum;
    AsynchronousChannelThreadGroup _group;


}