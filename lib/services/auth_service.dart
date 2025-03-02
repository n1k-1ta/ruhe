import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp(String name, String birthDate, String email, String password) async {
    try {
      if (password.length < 10 || !password.contains(RegExp(r'[A-Za-z]')) || !password.contains(RegExp(r'[0-9]'))) {
        return "Пароль должен содержать не менее 10 символов, латинские буквы и цифры.";
      }

      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        User? existingUser = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;

        if (existingUser != null && !existingUser.emailVerified) {
          await existingUser.sendEmailVerification();
          return "Email уже зарегистрирован, но не подтвержден. Новое письмо с подтверждением отправлено.";
        } else {
          return "Email уже зарегистрирован и подтвержден.";
        }
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "name": name,
        "birthDate": birthDate,
        "email": email,
      });
      await userCredential.user!.sendEmailVerification();
      return null; 
    } on FirebaseAuthException catch (e) {
      return "Ошибка: ${e.message}";
    } on FirebaseException catch (e) {
      return "Ошибка Firestore: ${e.message}";
    } catch (e) {
      return "Ошибка: ${e.toString()}";
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!userCredential.user!.emailVerified) {
        return "Подтвердите свою почту!";
      }

      return null; 
    } on FirebaseAuthException catch (e) {
      return "Ошибка: ${e.message}";
    } catch (e) {
      return "Ошибка: ${e.toString()}";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}