import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'generated_bindings.dart';

FreetypeBinding loadFreeType() {
  if (Platform.isAndroid) {
    return FreetypeBinding(DynamicLibrary.open('libfreetype.so'));
  }

  final packageConfigUri = Uri.parse(Platform.packageConfig!);
  final packageConfigFile = File.fromUri(packageConfigUri);

  if (!packageConfigFile.existsSync()) {
    throw Exception('package_config.json não encontrado em ${packageConfigFile.path}');
  }

  final content = packageConfigFile.readAsStringSync();
  final Map<String, dynamic> config = jsonDecode(content);

  final packages = config['packages'] as List<dynamic>;
  final freetypePackage = packages.firstWhere(
    (pkg) => pkg['name'] == 'freetype_dart',
    orElse: () => null,
  );

  if (freetypePackage == null) {
    throw Exception('Pacote freetype_dart não encontrado no package_config.json');
  }

  final rootUriString = freetypePackage['rootUri'] as String;
  final rootUri = Uri.parse(rootUriString);

  Uri baseUri = packageConfigUri.resolve('.');
  final packageRootUri = rootUri.isAbsolute ? rootUri : baseUri.resolveUri(rootUri);

  final packageRootPath = packageRootUri.toFilePath();

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

  final libPath = p.join(packageRootPath, 'bin', libName);

  if (!File(libPath).existsSync()) {
    throw Exception('Library not found at path: $libPath');
  }

  return FreetypeBinding(DynamicLibrary.open(libPath));
}