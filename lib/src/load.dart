import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'generated_bindings.dart';

FreetypeBinding loadFreeType() {
  final currentFile = File.fromUri(Platform.script);
  final currentDir = currentFile.parent;
  final packageRoot = p.normalize(p.join(currentDir.path, '../../'));
  String libName;
  if (Platform.isWindows) {
    libName = 'libfreetype-6.dll';
  } else if (Platform.isMacOS) {
    libName = 'libfreetype.6.dylib';
  } else if (Platform.isLinux) {
    libName = 'libfreetype.so.6';
  } else {
    throw UnsupportedError('Unsupported platform');
  }
  final libPath = p.join(packageRoot, 'bin', libName);
  if (!File(libPath).existsSync()) {
    throw Exception('Library not found at path: $libPath');
  }
  return FreetypeBinding(DynamicLibrary.open(libPath));
}