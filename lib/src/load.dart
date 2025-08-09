import 'dart:ffi';
import 'dart:io';
import 'generated_bindings.dart';
import 'package:path/path.dart' as p;

FreetypeBinding loadFreeType() {
  final scriptDir = File.fromUri(Platform.script).parent;
  final binDir = p.join(scriptDir.path, 'bin');
  String libName;
  if (Platform.isWindows) {
    libName = 'libfreetype-6.dll';
  } else if (Platform.isMacOS) {
    libName = 'libfreetype.6.dylib';
  } else {
    libName = 'libfreetype.so.6';
  }
  final libPath = p.join(binDir, libName);
  if (!File(libPath).existsSync()) {
    throw Exception('Biblioteca freetype não encontrada em: $libPath');
  }
  final dylib = DynamicLibrary.open(libPath);
  return FreetypeBinding(dylib);
}