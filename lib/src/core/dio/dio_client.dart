import 'package:dio/dio.dart';
import 'package:share_records/src/core/dio/dio_interceptor.dart';

final dio = Dio(
  BaseOptions(
    // baseUrl: 'https://fakestoreapi.com',
    headers: <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
      // "Authorization": 'Bearer $token'
    },
    receiveDataWhenStatusError: true,
    // connectTimeout: 100 * 1000, // 60 seconds
    // receiveTimeout: 100 * 1000),
  ),
)..interceptors.add(DioInterceptor());