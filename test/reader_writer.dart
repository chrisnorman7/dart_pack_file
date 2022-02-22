import 'package:dart_pack_file/dart_pack_file.dart';

/// A class to hold both a [reader] and a [writer].
class ReaderWriter {
  /// Create an instance.
  const ReaderWriter({required this.reader, required this.writer});

  /// The reader to use.
  final PackFileReader reader;

  /// The write to use.
  final PackFileWriter writer;
}
