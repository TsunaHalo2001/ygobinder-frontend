import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

part 'firebase_providers.g.dart';

bool _isFirebaseSupported() => kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

@riverpod
FirebaseFirestore? firestore(Ref ref) {
  if (!_isFirebaseSupported()) return null;
  return FirebaseFirestore.instance;
}
