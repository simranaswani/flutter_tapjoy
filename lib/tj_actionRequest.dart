abstract class TJActionRequest {
  String getRequestId();
  String getToken();
  void completed();
  void cancelled();
  TJActionRequest({getRequestId(), getToken(), completed(), cancelled()});
}
