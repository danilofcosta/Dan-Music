import 'package:flutter/foundation.dart';
const String prefixTag = "Dan Music";

void printErrorDebug(dynamic text, {String tag = prefixTag }) {
  if (kReleaseMode) return;
  debugPrint("\x1B[31m[$tag]: $text\x1B[0m");
}

void printInfoDebug(dynamic text, {String tag = prefixTag }) {
  if (kReleaseMode) return;
  debugPrint("\x1B[32m[$tag]: $text\x1B[34m");
}