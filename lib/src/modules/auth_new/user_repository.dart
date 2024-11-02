import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore _firestore;

  UserRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle error
      // print(e.code);
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        throw Exception('Invalid credential provided.');
      }
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // await userCredential.user?.sendEmailVerification(); // Send verification email

      // return userCredential.user;

      User? newUser = userCredential.user;
      await _firestore.collection('users').doc(newUser?.uid).set({
        'email': newUser?.email,
        'role': 'user',
        'isProfileComplete': false,
      });
      await newUser?.sendEmailVerification(); // Send verification email

      return newUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        throw Exception('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> registerTherapist(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? newUser = userCredential.user;
      await _firestore.collection('users').doc(newUser?.uid).set({
        'email': newUser?.email,
        'role': 'therapist',
        'isProfileComplete': false,
      });
      await newUser?.sendEmailVerification(); // Send verification email

      return newUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        throw Exception('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<bool> isEmailVerified(User? user) async {
    await user?.reload();
    user = firebaseAuth.currentUser;
    // print(user);
    return user?.emailVerified ?? false;
  }

  Future<void> deleteUser(User? user) async {
    // implementation
    await _firestore.collection('users').doc(user?.uid).delete();
    await user?.delete();
  }
}
