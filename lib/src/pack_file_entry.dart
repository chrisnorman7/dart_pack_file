const _separator = ':';

/// A class which stores the offset of a file with the given [filename].
class PackFileEntry {
  /// Create an instance.
  const PackFileEntry({
    required this.filename,
    required this.start,
    required this.end,
  });

  /// Create an instance from the given [length].
  const PackFileEntry.fromLength({
    required this.filename,
    required this.start,
    required int length,
  }) : end = start + length;

  /// Return an instance loaded from the given [string].
  factory PackFileEntry.fromString(String string) {
    final items = string.split(_separator);
    if (items.length != 3) {
      throw StateError('Invalid header: $items loaded from $string.');
    }
    final filename = items.first;
    final start = int.parse(items[1]);
    final end = int.parse(items.last);
    return PackFileEntry(filename: filename, start: start, end: end);
  }

  /// The name of the entry.
  final String filename;

  /// The position of the first byte of the data.
  final int start;

  /// The position after the last byte of the data.
  ///
  /// This value would also be the [start] of the next entry, unless this is
  /// the last entry.
  final int end;

  /// Returns the length of the data.
  int get length => end - start;

  /// Return the header string for this entry.
  String get header => '$filename$_separator$start$_separator$end';
}
