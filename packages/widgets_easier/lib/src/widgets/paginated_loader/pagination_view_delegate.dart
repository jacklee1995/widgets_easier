import 'package:flutter/material.dart';

import 'pagination_loading_controller.dart';

/// 提供 [PaginationView] UI组件的委托。
///
/// 实现这个抽象类以自定义分页视图的外观和行为。
abstract class PaginationViewDelegate<T> {
  /// 构建一个允许用户刷新项目列表的组件。
  ///
  /// [context] 构建上下文。
  /// [controller] 分页控制器。
  /// [child] 显示项目列表的组件。
  Widget refreshableView(
    BuildContext context,
    PaginationLoadingController<T> controller,
    Widget child,
  );

  /// 构建子组件容器组件
  ///
  /// 比如一个ListView，或者GireView，甚至时其它自定义的组织 children 的组件。
  ///
  /// [context] 构建上下文。
  /// [controller] 分页控制器。
  /// [children] 项目列表。
  /// [itemBuilder] 一个构建列表中每个项目的函数。
  Widget childrenLayoutView(
    BuildContext context,
    PaginationLoadingController<T> controller,
    List<T> children,
    IndexedWidgetBuilder itemBuilder,
  );

  /// 构建列表中单个项目的组件。
  ///
  /// [context] 构建上下文。
  /// [controller] 分页控制器。
  /// [item] 要显示的项目。
  Widget itemBuilder(
    BuildContext context,
    PaginationLoadingController<T> controller,
    T item,
  );

  /// 构建一个指示列表正在加载的组件。
  ///
  /// [context] 构建上下文。
  Widget loadingIndicator(BuildContext context);

  /// 构建一个指示列表为空的组件。
  ///
  /// [context] 构建上下文。
  Widget emptyIndicator(BuildContext context);
}
