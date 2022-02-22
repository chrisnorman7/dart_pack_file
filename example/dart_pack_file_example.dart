// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_pack_file/dart_pack_file.dart';
import 'package:path/path.dart' as path;

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    return print('You must supply a directory.');
  }
  final files =
      Directory(arguments.first).listSync().whereType<File>().toList();
  final writer = PackFileWriter(files);
  print('Files:');
  for (final file in writer.files) {
    print(path.basename(file.path));
  }
  final file = File('src_tests.data');
  await writer.write(file);
}
