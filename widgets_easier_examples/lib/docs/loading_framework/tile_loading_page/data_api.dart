import 'package:widgets_easier/widgets_easier.dart';

import 'mock_api.dart';

class DataApi {
  static Future<PaginatedResponse<Map<String, dynamic>>> onLoad(
      int page, int pageSize) async {
    // 调用模拟的API请求
    final response = await MockApi.post(
      'https://example.com/api/data',
      data: {'page': page, 'pageSize': pageSize},
    );

    // 使用fromMap工厂方法创建PaginatedResponse实例
    return PaginatedResponse<Map<String, dynamic>>.fromMap(
      response,
      (item) => item,
    );
  }
}
