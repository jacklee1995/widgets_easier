// One-off migration helper: point every component at the lib/src/core/
// barrel instead of the short-lived `widgets_easier_core` package.
//
// Usage: dart run tool/rewire_core_imports.dart [--dry-run]
import 'dart:io';

const _pkgLib = 'packages/widgets_easier/lib';
const _barrel = '$_pkgLib/src/core/core.dart';
const _coreDir = '$_pkgLib/src/core/';

const _oldImport =
    "import 'package:widgets_easier_core/widgets_easier_core.dart';";

void main(List<String> args) {
  final dryRun = args.contains('--dry-run');
  final root = Directory(_pkgLib);
  if (!root.existsSync()) {
    stderr.writeln('Run this from the repository root.');
    exit(2);
  }

  var changed = 0;
  for (final file
      in root
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))) {
    final posix = file.path.replaceAll(r'\', '/');
    // The barrel re-exports these files; they must keep their own imports.
    if (posix.startsWith(_coreDir)) continue;

    final original = file.readAsStringSync();
    if (!original.contains(_oldImport)) continue;

    final relative = _relativeImport(from: posix, to: _barrel);
    final text = original.replaceAll(_oldImport, "import '$relative';");

    stdout.writeln(
      '  ${dryRun ? 'would rewire' : 'rewired'} $posix -> $relative',
    );
    if (!dryRun) file.writeAsStringSync(text);
    changed++;
  }
  stdout.writeln('${dryRun ? 'would rewire' : 'rewired'} $changed files');
}

/// POSIX-style relative path from the directory of [from] to [to].
String _relativeImport({required String from, required String to}) {
  List<String> split(String p) =>
      p.replaceAll(r'\', '/').split('/').where((s) => s.isNotEmpty).toList();

  final fromParts = split(from)..removeLast();
  final toParts = split(to);

  var common = 0;
  while (common < fromParts.length &&
      common < toParts.length - 1 &&
      fromParts[common] == toParts[common]) {
    common++;
  }

  return [
    ...List.filled(fromParts.length - common, '..'),
    ...toParts.skip(common),
  ].join('/');
}
