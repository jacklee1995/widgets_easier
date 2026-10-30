import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';

/// When a [WeRule] runs on its own. Every rule also runs on
/// [WeFormController.validate].
enum WeRuleTrigger {
  /// Each time the field's value changes.
  change,

  /// When the field loses focus.
  blur,

  /// Only on [WeFormController.validate] / [WeFormController.validateField].
  submit,
}

/// Where a [WeFormItem] puts its label, after `label-position`.
enum WeLabelPosition { left, right, top }

/// A custom check: return an error message, or `null` when the value is fine.
/// May be async, e.g. to ask a server whether a name is taken.
typedef WeValidator = FutureOr<String?> Function(Object? value);

/// One validation rule of a [WeFormItem], after async-validator rules used
/// by `el-form`.
///
/// `min` / `max` compare string length, number value or collection size,
/// depending on the value.
///
/// ```dart
/// rules: const [
///   WeRule(required: true, message: '请输入商品名称'),
///   WeRule(min: 2, max: 30, trigger: WeRuleTrigger.blur),
/// ]
/// ```
@immutable
class WeRule {
  const WeRule({
    this.required = false,
    this.min,
    this.max,
    this.pattern,
    this.validator,
    this.message,
    this.trigger = WeRuleTrigger.change,
  });

  final bool required;
  final num? min;
  final num? max;
  final RegExp? pattern;
  final WeValidator? validator;

  /// Overrides the default message of the built-in checks.
  final String? message;
  final WeRuleTrigger trigger;

  static bool isEmptyValue(Object? v) =>
      v == null ||
      (v is String && v.trim().isEmpty) ||
      (v is Iterable && v.isEmpty) ||
      (v is Map && v.isEmpty);

  /// Runs this rule; returns the error message or `null`.
  Future<String?> check(Object? value, {String? label}) async {
    final bool empty = isEmptyValue(value);
    if (required && empty) {
      return message ?? (label != null ? '请填写$label' : '此项为必填项');
    }
    // 非必填且为空时跳过其余检查，和 async-validator 一致。
    if (empty && validator == null) return null;

    if (!empty && (min != null || max != null)) {
      final (num? n, String unit) = switch (value) {
        final String s => (s.characters.length, '长度'),
        final num v => (v, '值'),
        final Iterable<Object?> it => (it.length, '数量'),
        final Map<Object?, Object?> m => (m.length, '数量'),
        _ => (null, ''),
      };
      if (n != null) {
        if (min != null && n < min!) {
          return message ?? _tooSmall(unit, min!);
        }
        if (max != null && n > max!) {
          return message ?? _tooLarge(unit, max!);
        }
      }
    }

    if (!empty && pattern != null && !pattern!.hasMatch('$value')) {
      return message ?? '格式不正确';
    }

    if (validator != null) return await validator!(value);
    return null;
  }

  static String _tooSmall(String unit, num min) => switch (unit) {
    '长度' => '长度不能少于 $min 个字符',
    '数量' => '至少选择 $min 项',
    _ => '不能小于 $min',
  };

  static String _tooLarge(String unit, num max) => switch (unit) {
    '长度' => '长度不能超过 $max 个字符',
    '数量' => '最多选择 $max 项',
    _ => '不能大于 $max',
  };
}

/// Drives a [WeForm] from outside: validate, reset, scroll to a field.
class WeFormController {
  _WeFormState? _state;

  void _attach(_WeFormState s) => _state = s;
  void _detach(_WeFormState s) {
    if (_state == s) _state = null;
  }

  /// Runs every rule of every item; `true` when all pass. With
  /// [WeForm.scrollToError] the first failing item scrolls into view.
  Future<bool> validate() => _state?._validate() ?? Future.value(true);

  /// Runs every rule of the item named [name]; `true` when it passes.
  Future<bool> validateField(String name) =>
      _state?._item(name)?.validate() ?? Future.value(true);

  /// Clears the errors and calls each item's `onReset` so its value goes
  /// back to the initial one.
  void resetFields([Iterable<String>? names]) => _state?._reset(names);

  /// Removes the error messages without touching values.
  void clearValidate([Iterable<String>? names]) => _state?._clear(names);

  /// Scrolls the item named [name] into view.
  Future<void> scrollToField(String name) =>
      _state?._item(name)?.scrollIntoView() ?? Future.value();

  /// The current error of the item named [name].
  String? errorOf(String name) => _state?._item(name)?.error;
}

/// A form layout with validation, after `el-form`.
///
/// Wrap each field in a [WeFormItem]; give the item the field's current
/// `value` and its `rules`. [WeInput] and [WeSelect] inside an item pick up
/// its error colour, disabled state and size automatically.
///
/// ```dart
/// final form = WeFormController();
///
/// WeForm(
///   controller: form,
///   labelWidth: 88,
///   children: [
///     WeFormItem(
///       name: 'title',
///       label: '商品名称',
///       value: title,
///       rules: const [WeRule(required: true), WeRule(max: 30)],
///       onReset: () => setState(() => title = ''),
///       child: WeInput(onChanged: (v) => setState(() => title = v)),
///     ),
///   ],
/// );
///
/// if (await form.validate()) save();
/// ```
class WeForm extends StatefulWidget {
  const WeForm({
    super.key,
    this.controller,
    this.children = const [],
    this.child,
    this.labelWidth = 100,
    this.labelPosition = WeLabelPosition.right,
    this.size = SizeEnum.defaultSize,
    this.disabled = false,
    this.inline = false,
    this.hideRequiredAsterisk = false,
    this.scrollToError = true,
    this.itemGap = 18,
  }) : assert(
         child == null || children.length == 0,
         'Pass either child or children.',
       );

  final WeFormController? controller;

  /// Items laid out in a column, or in a wrapping row when [inline].
  final List<Widget> children;

  /// Your own layout, used instead of [children].
  final Widget? child;

  /// Width of the label column when [labelPosition] is left or right.
  final double labelWidth;
  final WeLabelPosition labelPosition;
  final SizeEnum size;

  /// Disables every field of the form.
  final bool disabled;

  /// Put items side by side, sized to their content, like a search bar.
  final bool inline;
  final bool hideRequiredAsterisk;

  /// On a failed [WeFormController.validate], scroll to the first error.
  final bool scrollToError;

  /// Space under each item, which also holds its error message.
  final double itemGap;

  static WeFormScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WeFormScope>();

  @override
  State<WeForm> createState() => _WeFormState();
}

class _WeFormState extends State<WeForm> {
  final List<WeFormItemState> _items = [];

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(WeForm old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  void _register(WeFormItemState item) => _items.add(item);
  void _unregister(WeFormItemState item) => _items.remove(item);

  WeFormItemState? _item(String name) {
    for (final i in _items) {
      if (i.widget.name == name) return i;
    }
    return null;
  }

  Iterable<WeFormItemState> _pick(Iterable<String>? names) => names == null
      ? _items
      : _items.where((i) => names.contains(i.widget.name));

  Future<bool> _validate() async {
    final List<WeFormItemState> items = List.of(_items);
    final List<bool> results = await Future.wait(
      items.map((i) => i.validate()),
    );
    if (!mounted) return false;
    final int first = results.indexOf(false);
    if (first < 0) return true;
    if (widget.scrollToError) {
      // 取屏幕上最靠上的出错项，而不是注册顺序里的第一个。
      WeFormItemState target = items[first];
      double best = double.infinity;
      for (int i = 0; i < items.length; i++) {
        if (results[i]) continue;
        final box = items[i].context.findRenderObject() as RenderBox?;
        if (box == null || !box.attached) continue;
        final double y = box.localToGlobal(Offset.zero).dy;
        if (y < best) {
          best = y;
          target = items[i];
        }
      }
      await target.scrollIntoView();
    }
    return false;
  }

  void _reset(Iterable<String>? names) {
    for (final i in _pick(names).toList()) {
      i.reset();
    }
  }

  void _clear(Iterable<String>? names) {
    for (final i in _pick(names).toList()) {
      i.clearValidate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget body =
        widget.child ??
        (widget.inline
            ? Wrap(spacing: 24, children: widget.children)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ));
    return WeFormScope._(
      state: this,
      labelWidth: widget.labelWidth,
      labelPosition: widget.labelPosition,
      size: widget.size,
      disabled: widget.disabled,
      inline: widget.inline,
      hideRequiredAsterisk: widget.hideRequiredAsterisk,
      itemGap: widget.itemGap,
      child: body,
    );
  }
}

/// Layout settings a [WeForm] hands down to its items.
class WeFormScope extends InheritedWidget {
  const WeFormScope._({
    required _WeFormState state,
    required this.labelWidth,
    required this.labelPosition,
    required this.size,
    required this.disabled,
    required this.inline,
    required this.hideRequiredAsterisk,
    required this.itemGap,
    required super.child,
  }) : _state = state;

  final _WeFormState _state;
  final double labelWidth;
  final WeLabelPosition labelPosition;
  final SizeEnum size;
  final bool disabled;
  final bool inline;
  final bool hideRequiredAsterisk;
  final double itemGap;

  @override
  bool updateShouldNotify(WeFormScope old) =>
      labelWidth != old.labelWidth ||
      labelPosition != old.labelPosition ||
      size != old.size ||
      disabled != old.disabled ||
      inline != old.inline ||
      hideRequiredAsterisk != old.hideRequiredAsterisk ||
      itemGap != old.itemGap;
}

/// One labelled, validated field of a [WeForm], after `el-form-item`.
///
/// Give it the field's current [value] (or a [valueGetter] when the field
/// keeps its own state, e.g. a `TextEditingController`). Rules with
/// [WeRuleTrigger.change] run when the value changes, [WeRuleTrigger.blur]
/// ones when a [WeInput] / [WeSelect] inside loses focus.
class WeFormItem extends StatefulWidget {
  const WeFormItem({
    super.key,
    required this.child,
    this.name,
    this.label,
    this.labelWidget,
    this.value,
    this.valueGetter,
    this.rules = const [],
    this.required,
    this.labelWidth,
    this.labelPosition,
    this.size,
    this.disabled,
    this.error,
    this.showMessage = true,
    this.onReset,
  });

  final Widget child;

  /// Key for [WeFormController.validateField] and friends.
  final String? name;
  final String? label;

  /// A custom label, used instead of [label].
  final Widget? labelWidget;

  /// The field's current value, checked by [rules].
  final Object? value;

  /// Reads the current value when the item can't be rebuilt on every change.
  final Object? Function()? valueGetter;
  final List<WeRule> rules;

  /// Shows the red asterisk; defaults to "any rule is required".
  final bool? required;

  final double? labelWidth;
  final WeLabelPosition? labelPosition;
  final SizeEnum? size;
  final bool? disabled;

  /// An error set from outside, e.g. returned by the server.
  final String? error;
  final bool showMessage;

  /// Restores the field's initial value on [WeFormController.resetFields].
  final VoidCallback? onReset;

  /// The item around [context], for fields that colour themselves on error.
  static WeFormItemState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_WeFormItemScope>()?.state;

  @override
  State<WeFormItem> createState() => WeFormItemState();
}

/// The state of a [WeFormItem]; fields reach it through
/// [WeFormItem.maybeOf].
class WeFormItemState extends State<WeFormItem> {
  String? _error;
  int _seq = 0;
  bool _skipChange = false;
  WeFormScope? _form;

  /// The message shown under the field, if any.
  String? get error => widget.error ?? _error;

  /// The colour fields should use: danger on error.
  SemanticEnum? get status => error != null ? SemanticEnum.danger : null;

  bool get disabled => widget.disabled ?? _form?.disabled ?? false;

  /// The control size for fields that did not pick one.
  SizeEnum get size => widget.size ?? _form?.size ?? SizeEnum.defaultSize;

  Object? get _value =>
      widget.valueGetter != null ? widget.valueGetter!() : widget.value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final WeFormScope? form = WeForm.maybeOf(context);
    if (form != _form) {
      _form?._state._unregister(this);
      _form = form;
      _form?._state._register(this);
    }
  }

  @override
  void didUpdateWidget(WeFormItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.valueGetter == null && oldWidget.value != widget.value) {
      if (_skipChange) {
        _skipChange = false;
      } else {
        _run(WeRuleTrigger.change);
      }
    }
  }

  @override
  void dispose() {
    _form?._state._unregister(this);
    super.dispose();
  }

  /// Called by fields after the user changed the value.
  void onChange() {
    if (widget.valueGetter == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _run(WeRuleTrigger.change);
    });
  }

  /// Called by fields when they lose focus.
  void onBlur() => _run(WeRuleTrigger.blur);

  /// Runs every rule, whatever its trigger.
  Future<bool> validate() => _run(null);

  void clearValidate() {
    _seq++;
    if (_error != null) setState(() => _error = null);
  }

  void reset() {
    clearValidate();
    if (widget.onReset != null) {
      _skipChange = true;
      widget.onReset!();
      // 值本来就等于初始值时不会触发 didUpdateWidget，下一帧后放开。
      WidgetsBinding.instance.addPostFrameCallback((_) => _skipChange = false);
    }
  }

  Future<void> scrollIntoView() => Scrollable.ensureVisible(
    context,
    alignment: 0.1,
    duration: const Duration(milliseconds: 240),
    curve: Curves.easeOutCubic,
  );

  Future<bool> _run(WeRuleTrigger? trigger) async {
    final List<WeRule> rules = [
      for (final r in widget.rules)
        if (trigger == null || r.trigger == trigger) r,
    ];
    if (rules.isEmpty) return error == null || trigger != null;

    final int seq = ++_seq;
    final Object? value = _value;
    String? message;
    for (final rule in rules) {
      message = await rule.check(value, label: widget.label);
      if (message != null) break;
    }
    if (!mounted || seq != _seq) return message == null;
    if (message != _error) setState(() => _error = message);
    return message == null && widget.error == null;
  }

  bool get _required => widget.required ?? widget.rules.any((r) => r.required);

  @override
  Widget build(BuildContext context) {
    final WeTheme we = WeTheme.of(context);
    final WeColorScheme colors = we.colors;
    final WeFormScope? form = _form;
    final WeLabelPosition position =
        widget.labelPosition ?? form?.labelPosition ?? WeLabelPosition.right;
    final bool inline = form?.inline ?? false;
    final double gap = form?.itemGap ?? 18;
    final double controlHeight = we.sizes.control(size).height;
    final bool asterisk = _required && !(form?.hideRequiredAsterisk ?? false);
    final String? message = widget.showMessage ? error : null;

    Widget? label;
    if (widget.label != null || widget.labelWidget != null) {
      label = DefaultTextStyle.merge(
        style: TextStyle(fontSize: 14, color: colors.regularText, height: 1.2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (asterisk)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text('*', style: TextStyle(color: colors.danger)),
              ),
            Flexible(child: widget.labelWidget ?? Text(widget.label!)),
          ],
        ),
      );
    }

    final Widget field = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.child,
        SizedBox(
          height: gap,
          child: message == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      color: colors.danger,
                    ),
                  ),
                ),
        ),
      ],
    );

    Widget body;
    if (label == null) {
      body = position == WeLabelPosition.top || inline
          ? field
          : Padding(
              padding: EdgeInsets.only(
                left: widget.labelWidth ?? form?.labelWidth ?? 0,
              ),
              child: field,
            );
    } else if (position == WeLabelPosition.top) {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 8), child: label),
          field,
        ],
      );
    } else {
      final Widget labelBox = Container(
        height: controlHeight,
        width: inline ? null : widget.labelWidth ?? form?.labelWidth ?? 100,
        padding: const EdgeInsets.only(right: 12),
        alignment: position == WeLabelPosition.right
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: label,
      );
      body = Row(
        mainAxisSize: inline ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelBox,
          if (inline) IntrinsicWidth(child: field) else Expanded(child: field),
        ],
      );
    }

    return _WeFormItemScope(
      state: this,
      error: error,
      disabled: disabled,
      size: size,
      child: body,
    );
  }
}

class _WeFormItemScope extends InheritedWidget {
  const _WeFormItemScope({
    required this.state,
    required this.error,
    required this.disabled,
    required this.size,
    required super.child,
  });

  final WeFormItemState state;
  final String? error;
  final bool disabled;
  final SizeEnum size;

  @override
  bool updateShouldNotify(_WeFormItemScope oldWidget) =>
      error != oldWidget.error ||
      disabled != oldWidget.disabled ||
      size != oldWidget.size;
}
