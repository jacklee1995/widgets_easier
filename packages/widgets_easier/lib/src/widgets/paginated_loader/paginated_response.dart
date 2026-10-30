/// 表示一个带分页信息的API响应
class PaginatedResponse<T> {
  /// 下一页的URL
  final String? next;

  /// 上一页的URL
  final String? previous;

  /// 是否有下一页
  final bool hasNext;

  /// 是否有上一页
  final bool hasPrevious;

  /// 总页数
  final int totalPages;

  /// 当前页码
  final int currentPage;

  /// 结果列表
  final List<T> results;

  /// 创建一个PaginatedResponse实例
  PaginatedResponse({
    this.next,
    this.previous,
    required this.hasNext,
    required this.hasPrevious,
    required this.totalPages,
    required this.currentPage,
    required this.results,
  });

  /// 从Map创建PaginatedResponse实例
  factory PaginatedResponse.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    return PaginatedResponse<T>(
      next: map['next'],
      previous: map['previous'],
      hasNext: map['has_next'],
      hasPrevious: map['has_previous'],
      totalPages: map['total_pages'],
      currentPage: map['current_page'],
      results: List<T>.from(map['results'].map(fromMap)),
    );
  }
}
