import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_applicaation/API/rest_client.dart';

final restClient = RestClient(baseUrl: "",dio);

final dio = getDio();

Dio getDio(){
  BaseOptions options = BaseOptions(
    receiveDataWhenStatusError: true,
    contentType: "application/json",
   // sendTimeout: const Duration(seconds: 30),
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30)
  );

 Dio dio = Dio(options);

 dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (request, handler) {
      debugPrint('API REQUEST BODY : ${request.data}');
      return handler.next(request);
      
    },
    onResponse: (Response response,ResponseInterceptorHandler handler) {
      debugPrint('API RESPONSE : ${response.data}');
      return handler.next(response);
      
    },
    onError: (DioException e, handler) {
      final response = e.response;
      debugPrint('API ERROR --> statuscode : ${response?.statusCode}-->${response?.statusMessage}: Error ==> ${e.toString()}');
      return handler.next(e);
      
    },
  )
 );
 return dio;
}