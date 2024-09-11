import 'dart:async';
import 'package:flutter/material.dart';

import 'paginated_response.dart';

/// 管理分页加载的控制器。
///
/// 该控制器负责处理分页数据的加载、状态管理和通知监听器。
class PaginationLoadingController<T> extends ChangeNotifier {
  final List<T> _items = [];

  /// 是否在初始化时加载数据。
  final bool initialLoad;

  /// 获取当前加载的项目列表。
  List<T> get items => _items;

  bool _isLoading = false;

  /// 获取当前是否正在加载数据。
  bool get isLoading => _isLoading;

  bool _hasNext = true;

  /// 获取是否还有下一页数据。
  bool get hasNext => _hasNext;

  bool _hasPrevious = false;

  /// 获取是否还有上一页数据。
  bool get hasPrevious => _hasPrevious;

  int _totalPages = -1;

  /// 获取总页数。
  int get totalPages => _totalPages;

  int _currentPage = 1;

  /// 获取当前页码。
  int get currentPage => _currentPage;

  /// 每页加载的项目数量。
  final int pageSize;

  /// 加载数据的回调函数。
  final Future<PaginatedResponse<T>> Function(int page, int pageSize) onLoad;

  /// 创建一个 [PaginationLoadingController] 实例。
  ///
  /// [pageSize] 和 [onLoad] 参数不能为空。
  /// 如果 [initialLoad] 为 true，则在初始化时加载第一页数据。
  PaginationLoadingController({
    required this.pageSize,
    required this.onLoad,
    this.initialLoad = true,
  }) {
    if (initialLoad) {
      loadNextPage();
    }
  }

  /// 加载下一页数据。
  ///
  /// 如果当前正在加载数据或没有下一页数据，则不执行任何操作。
  Future<void> loadNextPage() async {
    if (_isLoading || !_hasNext) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await onLoad(_currentPage, pageSize);
      _items.addAll(response.results);
      _hasNext = response.hasNext;
      _totalPages = response.totalPages;
      _currentPage = response.currentPage + 1;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 加载指定页码的数据。
  ///
  /// [page] 要加载的页码。
  Future<void> loadPage(int page) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await onLoad(page, pageSize);
      _items
        ..clear()
        ..addAll(response.results);
      _hasNext = response.hasNext;
      _hasPrevious = response.hasPrevious;
      _totalPages = response.totalPages;
      _currentPage = response.currentPage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 重置并重新加载数据。
  Future<void> onRefresh() async {
    _items.clear();
    _currentPage = 1;
    _hasNext = true;
    _hasPrevious = false;
    _totalPages = -1;
    await loadNextPage();
  }

  /// 从给定的 [BuildContext] 中获取 [PaginationLoadingController] 实例。
  ///
  /// [context] 用于查找 [PaginationLoadingController] 的构建上下文。
  static PaginationLoadingController<T> of<T>(BuildContext context) {
    final PaginationLoadingController<T>? result = context
        .dependOnInheritedWidgetOfExactType<
            _InheritedPaginationLoadingController<T>>()
        ?._controller;

    assert(result != null, 'No PaginationLoadingController found in context');

    return result!;
  }
}

/// 一个用于在小部件树中传递 [PaginationLoadingController] 的 [InheritedWidget]。
class _InheritedPaginationLoadingController<T> extends InheritedWidget {
  final PaginationLoadingController<T> _controller;

  const _InheritedPaginationLoadingController({
    super.key,
    required super.child,
    required PaginationLoadingController<T> controller,
  }) : _controller = controller;

  @override
  bool updateShouldNotify(_InheritedPaginationLoadingController<T> oldWidget) =>
      _controller != oldWidget._controller;
}
