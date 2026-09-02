import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/database_provider.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

part 'auth_provider.g.dart';

bool _isFirebaseSupported() => kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

@riverpod
FirebaseAuth? firebaseAuth(Ref ref) {
  if (!_isFirebaseSupported()) return null;
  return FirebaseAuth.instance;
}

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  if (auth == null) return Stream.value(null);
  return auth.authStateChanges();
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() {
    final auth = ref.read(firebaseAuthProvider);
    if (auth == null) return null;
    return auth.currentUser;
  }

  Future<void> signInWithGoogle() async {
    final auth = ref.read(firebaseAuthProvider);
    if (auth == null) {
      debugPrint('Google Sign-In is not supported on this platform.');
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // ✅ Using the Web Client ID from google-services.json to fix DEVELOPER_ERROR
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: '1017987650151-ido2f7pki69sjfvo05ci9qlkgisoh4b2.apps.googleusercontent.com',
      );
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      return userCredential.user;
    });

    if (state.hasError) {
      debugPrint('Google Sign-In Error Detail: ${state.error}');
    }
  }

  Future<void> signOut() async {
    final auth = ref.read(firebaseAuthProvider);
    state = const AsyncLoading();
    
    // ✅ Clear local collection and skip flag on logout
    final db = ref.read(databaseProvider);
    await db.clearCollection();
    await db.saveSetting('login_skipped', 'false');
    
    if (auth != null) {
      await auth.signOut();
      await GoogleSignIn(
        serverClientId: '1017987650151-ido2f7pki69sjfvo05ci9qlkgisoh4b2.apps.googleusercontent.com',
      ).signOut();
    }
    
    state = const AsyncData(null);
  }
}
