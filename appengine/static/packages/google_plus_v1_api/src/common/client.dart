part of plus_v1_api_client;

/**
 * Base class for all API clients, offering generic methods for HTTP Requests to the API
 */
abstract class Client {
  String basePath;
  String rootUrl;
  bool makeAuthRequests;
  Map params;

  static const _boundary = "-------314159265358979323846";
  static const _delimiter = "\r\n--$_boundary\r\n";
  static const _closeDelim = "\r\n--$_boundary--";

  Client() {
    params = new Map();
    makeAuthRequests = false;
  }

  /**
   * Sends a HTTPRequest using [method] (usually GET or POST) to [requestUrl] using the specified [urlParams] and [queryParams]. Optionally include a [body] in the request.
   */
  Future request(String requestUrl, String method, {String body, String contentType:"application/json", Map urlParams, Map queryParams});

  /**
   * Joins [content] (encoded as Base64-String) with specified [contentType] and additional request [body] into one multipart-body and send a HTTPRequest with [method] (usually POST) to [requestUrl]
   */
  Future upload(String requestUrl, String method, String body, String content, String contentType, {Map urlParams, Map queryParams}) {
    var multiPartBody = new StringBuffer();
    if (contentType == null || contentType.isEmpty) {
      contentType = "application/octet-stream";
    }
    multiPartBody
    ..add(_delimiter)
    ..add("Content-Type: application/json\r\n\r\n")
    ..add(body)
    ..add(_delimiter)
    ..add("Content-Type: ")
    ..add(contentType)
    ..add("\r\n")
    ..add("Content-Transfer-Encoding: base64\r\n")
    ..add("\r\n")
    ..add(content)
    ..add(_closeDelim);

    return request(requestUrl, method, body: multiPartBody.toString(), contentType: "multipart/mixed; boundary=\"$_boundary\"", urlParams: urlParams, queryParams: queryParams);
  }
}

/// Base-class for all API Resources
abstract class Resource {
  /// The [Client] to be used for all requests
  Client _client;

  /// Create a new Resource, using the specified [Client] for requests
  Resource(Client this._client);
}

/// Exception thrown when the HTTP Request to the API failed
class APIRequestException implements Exception {
  final String msg;
  const APIRequestException([this.msg]);
  String toString() => (msg == null) ? "APIRequestException" : "APIRequestException: $msg";
}

