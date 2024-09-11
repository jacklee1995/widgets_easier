import 'package:widgets_easier/widgets_easier.dart';

import 'mock_api.dart';

/// 数据API类
class DataApi {
  /// 加载分页数据的方法
  ///
  /// [page] 当前页码
  /// [pageSize] 每页的数据量
  /// 返回一个包含分页信息和结果列表的 [PaginatedResponse]
  static Future<PaginatedResponse<Map<String, dynamic>>> onLoad(
      int page, int pageSize) async {
    final response = await MockApi.get(
      'https://example.com/api/search',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    return PaginatedResponse<Map<String, dynamic>>.fromMap(
      response,
      (item) => item,
    );
  }
}
