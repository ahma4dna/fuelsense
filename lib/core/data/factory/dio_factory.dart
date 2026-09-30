// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import '../../application/constant.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// class DioFactory {
//   final String baseUrl;
//   final String anonKey; // publishable key
//   final String accessToken; // user token
//   final String language;
//   final String userId; //user id

//   DioFactory(
//     this.baseUrl,
//     this.anonKey,
//     this.accessToken,
//     this.language,
//     this.userId,
//   );

//   Dio getDio() {
//     Dio dio = Dio();
//     Map<String, String> header = {
//       contentType: applicationJson,
//       accept: applicationJson,
//       defaultLanguage: language,
//       apiKey: anonKey,
//     };
//     if (accessToken.isNotEmpty) {
//       header[authorization] = 'Bearer $accessToken';
//     }
//     if (userId.isNotEmpty) {
//       header[clientId] = userId;
//     }
//     dio.options = BaseOptions(
//       headers: header,
//       receiveTimeout: Duration(seconds: 60),
//       sendTimeout: Duration(seconds: 60),
//     );

//     if (!kReleaseMode) {
//       dio.interceptors.add(
//         PrettyDioLogger(
//           requestBody: true,
//           responseHeader: true,
//           requestHeader: true,
//         ),
//       );
//     }
//     return dio;
//   }
// }
