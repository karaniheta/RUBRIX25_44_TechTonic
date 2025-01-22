import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

   Future<void> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String dob,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phone', // Ensure the phone number is in the correct format (+91 for India)
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential); // Auto-complete the verification if possible
        },
        verificationFailed: (FirebaseAuthException error) {
          onError(error); // Handle errors like invalid phone number
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId); // Pass verificationId to UI to be used for verification
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          onCodeSent(verificationId); // Timeout handler
        },
      );
    } catch (e) {
      onError(FirebaseAuthException(message: e.toString(), code: 'unknown-error'));
    }
  }

  

  signinwithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception("Google sign-in failed: $e");
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,})
    async {
       {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    }

  Future<void> signout() async {
    await _auth.signOut();
  }
}