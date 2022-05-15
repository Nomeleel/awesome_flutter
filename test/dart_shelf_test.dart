import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  // Cascades
  final Function cascadeHandler = (request, key) {
    if (request.url.path.startsWith(key)) {
      return shelf.Response.ok('cascadeHandler: $key');
    }
    return shelf.Response.notFound('Not found');
  };

  final handlerCascade = shelf.Cascade()
      .add((request) => cascadeHandler(request, 'A'))
      .add((request) => cascadeHandler(request, 'B'))
      .add((request) => cascadeHandler(request, 'C'))
      .add((request) {
    if (request.headers['My-Custom-Header'] != null) {
      return shelf.Response.ok(request.headers['My-Custom-Header']);
    }
    return shelf.Response.notFound('not found');
  }).handler;

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(
        (innerHandler) => (request) async {
          final updatedRequest = request.change(
            headers: {'My-Custom-Header': 'custom header value'},
          );
          return await innerHandler(updatedRequest);
        },
      )
      .addHandler(handlerCascade);

  var server = await io.serve(handler, 'localhost', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

// shelf.Response _echoRequest(shelf.Request request) {
//   print(request);
//   return shelf.Response.ok('Request for "${request.url}"');
// }
