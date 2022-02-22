import 'dart:io';

import 'package:path/path.dart' as path;

import '../dart_pack_file.dart';

/// The separator to put between the header lines and the raw data.
const headerSeparator = 0;

/// A class that stores files, ready for writing.
class PackFileWriter {
  /// Create an instance.
  const PackFileWriter(this.files);

  /// The list of files to write.
  final List<File> files;

  /// Write all of the [files] to the given [file].
  Future<void> write(File file) async {
    final randomAccessFile = await file.open(mode: FileMode.writeOnly);
    final entries = <PackFileEntry>[];
    var bytesWritten = 0;
    for (final file in files) {
      final buffer = file.readAsBytesSync();
      final bufferSize = buffer.length;
      final entry = PackFileEntry.fromLength(
        filename: path.basename(file.path),
        start: bytesWritten,
        length: bufferSize,
      );
      entries.add(entry);
      bytesWritten += bufferSize;
      randomAccessFile.writeFromSync(buffer);
    }
    randomAccessFile.writeByteSync(headerSeparator);
    for (final entry in entries) {
      final header = '${entry.header}\n'.codeUnits;
      randomAccessFile.writeFromSync(header);
    }
    randomAccessFile.closeSync();
  }
}
