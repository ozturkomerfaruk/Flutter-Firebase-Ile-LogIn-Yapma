import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<User> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  ///Firebase ile konuşacak budur. on_board da bunla konuşacak.
  Stream<User> authStatus() {
    return _firebaseAuth.authStateChanges();
  }

  Future<User> createUserWithEmailAndPassword(
      String _email, String _password) async {
    UserCredential _userCredentials;
    try {
      _userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      return _userCredentials.user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
      rethrow;
    }
  }

  Future<User> signInWithEmailAndPassword(
      String _email, String _password) async {
    final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: _email, password: _password);
    return userCredentials.user;
  }

  Future<void> sendPasswordResetEmail(String _email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: _email);
  }

  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    }
  }
}
