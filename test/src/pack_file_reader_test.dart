import 'dart:io';

import 'package:dart_pack_file/dart_pack_file.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../reader_writer.dart';

final outputFile = File('test_src.data');

/// Get a read and a writer.
Future<ReaderWriter> getReaderWriter(List<File> files) async {
  final writer = PackFileWriter(files);
  await writer.write(outputFile);
  final randomAccessFile = await outputFile.open();
  final reader = PackFileReader(randomAccessFile);
  return ReaderWriter(reader: reader, writer: writer);
}

void main() {
  final files = Directory('test/src').listSync().whereType<File>().toList();
  group(
    'PackFileReader',
    () {
      test(
        'Initialise',
        () async {
          final readerWriter = await getReaderWriter(files);
          final reader = readerWriter.reader;
          expect(reader.entries, isEmpty);
        },
      );
      test(
        '.loadEntries',
        () async {
          final readerWriter = await getReaderWriter(files);
          final reader = readerWriter.reader..loadEntries();
          expect(reader.entries.length, files.length);
        },
      );
      test(
        '.getData',
        () async {
          final readerWriter = await getReaderWriter(files);
          final reader = readerWriter.reader..loadEntries();
          for (final file in files) {
            final expected = file.readAsBytesSync();
            final name = path.basename(file.path);
            final actual = reader.getData(name);
            expect(
              actual,
              expected,
              reason: '$name did not match',
            );
          }
          reader.randomAccessFile.closeSync();
        },
      );
    },
  );
}
