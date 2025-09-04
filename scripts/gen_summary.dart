import 'dart:convert';
import 'dart:io';

/// Safe JSON reader (returns {} if file missing/bad)
Map<String, dynamic> _readJson(String path) {
  final f = File(path);
  if (!f.existsSync()) return {};
  try {
    final txt = f.readAsStringSync();
    final v = json.decode(txt);
    if (v is Map<String, dynamic>) return v;
    return {};
  } catch (_) {
    return {};
  }
}

/// Return directories under [reportsDir] named YYYY-MM-DD (sorted)
List<String> _listRunFolders(Directory reportsDir) {
  final dateRe = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  final dirs = <String>[];
  for (final e in reportsDir.listSync()) {
    if (e is Directory) {
      final name = e.uri.pathSegments.isNotEmpty
          ? e.uri.pathSegments.last.replaceAll('/', '')
          : e.path.split(Platform.pathSeparator).last;
      if (dateRe.hasMatch(name)) dirs.add(name);
    }
  }
  dirs.sort(); // ascending
  return dirs;
}

void main(List<String> args) {
  if (args.length < 2) {
    stderr
        .writeln('Usage: dart scripts/gen_summary.dart <reports_dir> <stamp>');
    exit(1);
  }

  final reportsDir = Directory(args[0]);
  final stamp = args[1];

  if (!reportsDir.existsSync()) {
    stderr.writeln('Reports dir not found: ${reportsDir.path}');
    exit(1);
  }

  final runDir = Directory('${reportsDir.path}/$stamp');
  if (!runDir.existsSync()) {
    stderr.writeln('Run dir not found for $stamp, creating skeleton.');
    runDir.createSync(recursive: true);
  }

  // Try to read metrics from normalized files (if present)
  final mig = _readJson('${runDir.path}/01_responsive_migration_map.json');
  final arb = _readJson('${runDir.path}/03_arb_migration_map.json');
  final analysis = _readJson('${runDir.path}/00_analysis_summary.json');

  final replaced = (mig['replaced_patterns'] as List?)?.length ?? 0;
  final oldUtils = (mig['old_utils'] as List?)?.length ?? 0;
  final migratedKeys = (arb['migration_map'] as Map?)?.length ?? 0;

  final analyzerErrors = (analysis['analyzer_errors'] as int?) ?? 0;
  final analyzerWarnings = (analysis['analyzer_warnings'] as int?) ?? 0;
  final tests = (analysis['tests'] as Map?) ?? const {};
  final testsPassed = (tests['passed'] as int?) ?? 0;
  final testsFailed = (tests['failed'] as int?) ?? 0;

  final buf = StringBuffer();
  buf.writeln('# All Runs Summary');
  buf.writeln('- Generated: ${DateTime.now().toIso8601String()}');
  buf.writeln('- Latest run: $stamp');
  buf.writeln('');

  buf.writeln('## Latest Run ($stamp)');
  buf.writeln(
      '- Analyzer: **$analyzerErrors** errors, **$analyzerWarnings** warnings');
  buf.writeln('- Tests: **$testsPassed** passed, **$testsFailed** failed');
  buf.writeln('- Responsive replacements: **$replaced**');
  buf.writeln('- Deprecated utils removed: **$oldUtils**');
  buf.writeln('- ARB keys migrated: **$migratedKeys**');
  buf.writeln('');

  buf.writeln('### Files in latest run');
  final files = runDir
      .listSync()
      .whereType<File>()
      .map((f) => '- ${f.uri.pathSegments.last}')
      .toList()
    ..sort();
  if (files.isEmpty) {
    buf.writeln('- (none)');
  } else {
    buf.writeln(files.join('\n'));
  }
  buf.writeln('');

  buf.writeln('## Historical Runs');
  final runs = _listRunFolders(reportsDir);
  if (runs.isEmpty) {
    buf.writeln('- (none)');
  } else {
    for (final r in runs) {
      buf.writeln('- $r/');
    }
  }

  final out = File('${reportsDir.path}/ALL_SUMMARY.md');
  out.writeAsStringSync(buf.toString());
  stdout.writeln('✅ Wrote ${out.path}');
}
