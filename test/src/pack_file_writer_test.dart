import 'dart:io';

import 'package:dart_pack_file/dart_pack_file.dart';
import 'package:test/test.dart';

void main() {
  group(
    'PackFileWriter',
    () {
      test(
        'Initialise',
        () {
          final writer = PackFileWriter(
            Directory('test').listSync().whereType<File>().toList(),
          );
          expect(writer.files, isNotEmpty);
        },
      );
    },
  );
}
