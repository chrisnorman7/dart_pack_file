import 'package:dart_pack_file/dart_pack_file.dart';
import 'package:test/test.dart';

void main() {
  group(
    'PackFileEntry',
    () {
      test(
        'Initialise',
        () {
          const entry = PackFileEntry(filename: 'test.wav', start: 0, end: 34);
          expect(entry.filename, 'test.wav');
          expect(entry.start, isZero);
          expect(entry.end, 34);
        },
      );
      test(
        'fromLength',
        () {
          var entry = PackFileEntry(filename: 'test.wav', start: 0, end: 15);
          expect(entry.end, 15);
          expect(entry.filename, 'test.wav');
          expect(entry.start, 0);
          entry = PackFileEntry.fromLength(
              filename: 'other.wav', start: 55, length: 200);
          expect(entry.end, 255);
          expect(entry.filename, 'other.wav');
          expect(entry.start, 55);
        },
      );
      test(
        '.length',
        () {
          var entry = PackFileEntry(
            filename: 'something.wav',
            start: 15,
            end: 40,
          );
          expect(entry.length, 25);
          entry = PackFileEntry.fromLength(
              filename: 'thing.wav', start: 80, length: 100);
          expect(entry.length, 100);
        },
      );
    },
  );
}
