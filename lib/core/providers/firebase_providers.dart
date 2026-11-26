import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

part 'firebase_providers.g.dart';

/// Firebase (Auth, Firestore, Google Sign-In) is only configured for these
/// platforms; Linux and Windows run in local-only mode.
bool isFirebaseSupported() => kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

@riverpod
FirebaseFirestore? firestore(Ref ref) {
  if (!isFirebaseSupported()) return null;
  return FirebaseFirestore.instance;
}
