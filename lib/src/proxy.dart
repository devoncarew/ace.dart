part of ace;

abstract class _HasProxy {
  var _proxy;
  
  _HasProxy(js.Proxy proxy) : _proxy = js.retain(proxy);  
  
  void dispose() {
    assert(_proxy != null);
    _onDispose();
    js.release(_proxy);
    _proxy = null;
  }
  
  void _onDispose() {}
}