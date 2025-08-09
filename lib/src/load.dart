import 'dart:ffi';
import 'dart:io';
import 'generated_bindings.dart';
import 'package:path/path.dart' as p;

FreetypeBinding loadFreeType() {
  final execDir = File(Platform.resolvedExecutable).parent;

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
  final libPath = p.join(execDir.path, 'bin', libName);
  if (!File(libPath).existsSync()) {
    throw Exception('Library not found in path: $libPath');
  }
  return FreetypeBinding(DynamicLibrary.open(libPath));
}