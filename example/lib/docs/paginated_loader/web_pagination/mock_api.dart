/// 模拟的API类，表示从后端返回数据
class MockApi {
  /// 模拟的GET请求方法
  ///
  /// [url] 请求的URL
  /// [queryParameters] 查询参数
  /// 返回一个包含分页信息和结果列表的Map
  static Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final page = queryParameters?['page'] ?? 1;
    final pageSize = queryParameters?['pageSize'] ?? 10;

    return {
      'next': page < 10 ? 'next_page_url' : null,
      'previous': page > 1 ? 'previous_page_url' : null,
      'has_next': page < 10,
      'has_previous': page > 1,
      'total_pages': 10,
      'current_page': page,
      'results': List.generate(pageSize, (index) {
        final id = (page - 1) * pageSize + index;
        return {
          'id': id,
          'title': 'Search Result $id',
          'snippet': 'This is the snippet for search result $id...',
        };
      }),
    };
  }
}
