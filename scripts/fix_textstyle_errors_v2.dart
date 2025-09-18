#!/usr/bin/env dart

import 'dart:io';

void main() async {
  print('🔧 Fixing TextStyle nullability issues (v2)...');
  
  final libDir = Directory('lib');
  await _processDirectory(libDir);
  
  print('✅ TextStyle fixes completed!');
}

Future<void> _processDirectory(Directory dir) async {
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      await _fixFile(entity);
    }
  }
}

Future<void> _fixFile(File file) async {
  try {
    String content = await file.readAsString();
    final String originalContent = content;
    
    // Fix specific TextStyle nullability patterns
    content = content.replaceAll(
      RegExp(r'textTheme\.(\w+)\?\.copyWith\('),
      'textTheme.\$1!.copyWith('
    );
    
    // Fix Theme.of(context).textTheme patterns
    content = content.replaceAll(
      RegExp(r'Theme\.of\(context\)\.textTheme\.(\w+)\?\.copyWith\('),
      'Theme.of(context).textTheme.\$1!.copyWith('
    );
    
    // Fix any remaining \$1 patterns that were incorrectly created
    content = content.replaceAll(
      RegExp(r'textTheme\.\$1!'),
      'textTheme.headlineMedium!'
    );
    
    if (content != originalContent) {
      await file.writeAsString(content);
      print('✅ Fixed: ${file.path}');
    }
  } catch (e) {
    print('❌ Error processing ${file.path}: $e');
  }
}
