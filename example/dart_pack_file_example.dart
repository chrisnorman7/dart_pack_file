// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_pack_file/dart_pack_file.dart';
import 'package:path/path.dart' as path;

Future<void> main(List<String> arguments) async {
  if (arguments.length != 2) {
    return print('script <input-directory> <output-file>');
  }

  /// Get a list of all files in the directory.
  final files =
      Directory(arguments.first).listSync().whereType<File>().toList();
  // Create a writer.
  final writer = PackFileWriter(files);
  print('Keys in the writer:');
  for (final file in writer.files) {
    print(path.basename(file.path));
  }
  final file = File(arguments.last);
  // Write the pack file.
  writer.write(file);
  final randomAccessFile = await file.open();
  final reader = PackFileReader(randomAccessFile)..loadEntries();
  for (final f in files) {
    // Get the filename, which is also the name of the entry in the pack file.
    final name = path.basename(f.path);
    // Get the contents of the original file.
    final expected = f.readAsBytesSync();
    // Get the data from the pack file.
    final actual = reader.getData(name);
    if (expected.length != actual.length) {
      // The data are different lengths.
      throw StateError('$name has not loaded properly.');
    }
    for (var i = 0; i < actual.length; i++) {
      if (actual[i] != expected[i]) {
        // The bytes at this position are different.
        throw StateError('$name differs at offset $i.');
      }
    }
    // All is well.
    print('$name loaded successfully.');
  }
  // Close the file.
  randomAccessFile.closeSync();
}
