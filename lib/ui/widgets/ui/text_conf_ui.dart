import 'package:flutter/material.dart';

class TextUi extends Text {
  const TextUi(
    super.data, {
    super.key,
    super.style,

    super.maxLines = 1,
    super.overflow = TextOverflow.ellipsis,
  });
}