import 'dart:io';

/// A class that stores files, ready for writing.
class PackFileWriter {
  /// Create an instance.
  const PackFileWriter(this.files);

  /// The list of files to write.
  final List<File> files;
}
