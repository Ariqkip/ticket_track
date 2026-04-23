enum HttpMethod {get, post, put, patch, delete}
class NetworkRequest {
final Uri uri;
final HttpMethod method;
final Map<String, String> headers;
final Object? data;
final int retryCount;

NetworkRequest({required this.uri,
  required this.method,
  this.headers=const {},
  this.data,
  this.retryCount=1}
    );
}