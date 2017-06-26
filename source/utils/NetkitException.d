


module netkit.utils.NetkitException;

import std.exception;

class NetkitException : Exception{
    this(string msg) { super(msg, __FILE__, __LINE__, null);  }
}