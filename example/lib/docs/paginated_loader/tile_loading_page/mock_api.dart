/// 这个是一个虚拟的API，来表示后端返回数据
class MockApi {
  static Future<Map<String, dynamic>> post(String url,
      {Map<String, dynamic>? data}) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));

    // 模拟的API响应数据
    final page = data?['page'] ?? 1;
    final pageSize = data?['pageSize'] ?? 20;

    return {
      'next': page < 5 ? 'next_page_url' : null,
      'previous': page > 1 ? 'previous_page_url' : null,
      'has_next': page < 5,
      'has_previous': page > 1,
      'total_pages': 5,
      'current_page': page,
      'results': List.generate(pageSize, (index) {
        final id = (page - 1) * pageSize + index;
        return {
          'id': id,
          'title': 'Item $id',
          'subtitle': 'Subtitle $id',
        };
      }),
    };
  }
}
