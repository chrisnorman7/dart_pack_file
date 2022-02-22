// ignore_for_file: avoid_print
/// This test provides a simple benchmark.
///
/// The idea is to randomly load files, and see which is faster.
///
/// For best results, choose a directory with many large files. Just don't
/// forget that they will all be consolidated into your pack file.
import 'dart:io';
import 'dart:math';

import 'package:dart_pack_file/dart_pack_file.dart';
import 'package:filesize/filesize.dart';

const passes = 10000;
const printEvery = 1000;

/// Print a [duration].
///
/// Code copied from
/// https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss
String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    return print('Usage: benchmark <directory>');
  }
  final buffer = <int>[];
  final random = Random();
  final files =
      Directory(arguments.single).listSync().whereType<File>().toList();
  print('Files: ${files.length}.');
  final totalSize = [for (final file in files) file.statSync().size].reduce(
    (value, element) => value + element,
  );
  print('Total file size: ${filesize(totalSize)}.');
  final writer = PackFileWriter(files);
  final file = File('packed.data');
  await writer.write(file);
  print('Packed file size: ${filesize(file.statSync().size)}.');
  final randomAccessFile = await file.open();
  final reader = PackFileReader(randomAccessFile)..loadEntries();
  print('Number of entries: ${reader.entries.length}.');
  print('Testing with raw files...');
  var started = DateTime.now();
  for (var i = 0; i < passes; i++) {
    if (i % printEvery == 0) {
      print('$i passes.');
    }
    final bytes = files[random.nextInt(files.length)].readAsBytesSync();
    // Do something useless with the data.
    buffer
      ..clear()
      ..addAll(bytes);
  }
  var duration = DateTime.now().difference(started);
  print('$passes passes in ${printDuration(duration)}.');
  print('Testing with the pack file.');
  started = DateTime.now();
  for (var i = 0; i < passes; i++) {
    if (i % printEvery == 0) {
      print('$i passes.');
    }
    final bytes = reader.getData(
      reader.entries[random.nextInt(reader.entries.length)].filename,
    );
    // Do something useless with the data.
    buffer
      ..clear()
      ..addAll(bytes);
  }
  duration = DateTime.now().difference(started);
  print('$passes passes in ${printDuration(duration)}.');
}
