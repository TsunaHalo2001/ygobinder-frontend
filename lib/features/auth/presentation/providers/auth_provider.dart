import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/database_provider.dart';

part 'auth_provider.g.dart';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() {
    return ref.read(firebaseAuthProvider).currentUser;
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // ✅ Now using the stable v6.x API
      final GoogleSignIn googleSignIn = GoogleSignIn();
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await ref.read(firebaseAuthProvider).signInWithCredential(credential);
      return userCredential.user;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    // ✅ Clear local collection and skip flag on logout
    final db = ref.read(databaseProvider);
    await db.clearCollection();
    await db.saveSetting('login_skipped', 'false');
    
    await ref.read(firebaseAuthProvider).signOut();
    await GoogleSignIn().signOut();
    state = const AsyncData(null);
  }
}
