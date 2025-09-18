#!/usr/bin/env dart

import 'dart:io';

void main() async {
  print('🔧 Fixing TextStyle nullability issues...');
  
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
    
    // Fix TextStyle nullability issues
    content = content.replaceAll(
      RegExp(r'Theme\.of\(context\)\.textTheme\.(\w+)\?\.copyWith\('),
      'Theme.of(context).textTheme.\$1!.copyWith('
    );
    
    // Fix remaining null assertion issues
    content = content.replaceAll(
      RegExp(r'(\w+)\?\s*\.copyWith\('),
      '\$1!.copyWith('
    );
    
    if (content != originalContent) {
      await file.writeAsString(content);
      print('✅ Fixed: ${file.path}');
    }
  } catch (e) {
    print('❌ Error processing ${file.path}: $e');
  }
}
