import 'package:dio/dio.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';

class MyDio {
  static MyDio? _singleton;
  static int requestCounter = 0;

  factory MyDio() {
    _singleton ??= MyDio._internal();
    return _singleton!;
  }

  MyDio._internal() {
    initDioConfiguration();
    initDioLogger();
  }

  final Dio dio = Dio();

  void initDioConfiguration() {
    dio.options = BaseOptions(
      connectTimeout: 30000,
      receiveTimeout: 30000,
    );
  }

  void initDioLogger() {
    // initCustomDioLogger();
    dio.interceptors.add(
      PrettyDioLogger(
          requestHeader: true,
          queryParameters: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          showProcessingTime: true,
          canShowLog: true,
          convertFormData: true
          // canShowLog: kDebugMode,
          ),
    );

    // "id": "151",
    // "subject_id": "42",
    // "name": "R1 OBGYN",
    // "date": "2023-01-23 21:10:03",
    // "photo": "subject.png",
    // "chapter_status": null,
    // "count": "0",
    // "type": "1"
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      requestCounter++;
      print('Requ>>>>>>>>>>>>>');
      print('Request :' + options.path);
      print('Request Counter: $requestCounter');
      print('end Requ<<<<<<<<<<<<\n\n\n');
      return handler.next(options);
    }));
  }

  void initCustomDioLogger() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      print("onRequest {");

      print(options.data);
      print(options.headers);
      print("} End onRequest ");

      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onResponse: (response, handler) {
      print("onResponse");

      print(response.data);
      print(response.headers);
      print(response.requestOptions);
      print(response.statusCode);
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError e, handler) {
      var response = e.response;
      print("on error");

      if (response != null) {
        print(response.data);
        print(response.headers);
        print(response.requestOptions);
        print(response.statusCode);
      }
      print(e.error);
      print(e.message);
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    }));
  }
}
