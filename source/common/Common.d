


module netkit.common.Common;


import netkit.net.NetSocket;
import netkit.net.NetServer;
import kiss.aio.ByteBuffer;


alias connet_handler = void delegate(NetSocket so);
alias linsten_handler = void delegate(bool success, NetServer so);
alias buffer_handler = void delegate(ByteBuffer buffer);
alias timer_handler = void delegate(int timerId);