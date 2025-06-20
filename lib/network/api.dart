import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'get_post_response_model.dart';

final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )
  ..interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
      ),
    ),
  );

class Api {
  Api._({required this.client});

  final Dio client;

  factory Api() => Api._(client: dio);

  Future<GetPostResponseModel?> getPost(int id) async {
    final response = await client.get('/posts/$id');

    if (response.statusCode != 200) {
      return null;
    }

    return GetPostResponseModel.fromJson(response.data);
  }
}
