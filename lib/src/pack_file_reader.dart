import 'dart:convert';
import 'dart:io';

import '../dart_pack_file.dart';

const _lineSplitter = LineSplitter();

/// A class for reading a pack file.
class PackFileReader {
  /// Create an instance.
  PackFileReader(this.randomAccessFile) : entries = [];

  /// The file to read from.
  final RandomAccessFile randomAccessFile;

  /// The entries that have been loaded by [loadEntries].
  final List<PackFileEntry> entries;

  /// Load the [entries].
  ///
  /// If no null character is found, that means there are no entries, and
  /// [StateError] is thrown.
  void loadEntries() {
    entries.clear();
    final charCodes = <int>[];
    int i = 0;
    for (i = randomAccessFile.lengthSync() - 1; i >= 0; i--) {
      randomAccessFile.setPositionSync(i);
      final charCode = randomAccessFile.readByteSync();
      if (charCode == headerSeparator) {
        break;
      } else {
        charCodes.add(charCode);
      }
    }
    if (i == 0) {
      throw StateError('No headers were found.');
    }
    for (final line
        in _lineSplitter.convert(String.fromCharCodes(charCodes.reversed))) {
      final entry = PackFileEntry.fromString(line);
      entries.add(entry);
    }
  }

  /// Get the contents of the entry with the given [name].
  List<int> getData(String name) {
    final entry = entries.firstWhere(
      (element) => element.filename == name,
    );
    randomAccessFile.setPositionSync(entry.start);
    return randomAccessFile.readSync(entry.length);
  }
}
