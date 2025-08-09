import 'dart:ffi';
import 'dart:io';
import 'generated_bindings.dart';

FreetypeBinding loadFreeType() {
  String path = 'bin/';
  if (Platform.isWindows) {
    path += 'libfreetype-6.dll';
  } else if (Platform.isMacOS) {
    path += 'libfreetype.6.dylib';
  } else if (Platform.isMacOS) {
    path += 'libfreetype.so.6';
  }
  return FreetypeBinding(DynamicLibrary.open(path));
}