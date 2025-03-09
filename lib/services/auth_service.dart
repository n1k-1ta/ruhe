import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Метод для регистрации нового пользователя
  Future<String?> signUp(String name, String birthDate, String email, String password) async {
    try {
      // Проверка пароля
      if (password.length < 10 || !password.contains(RegExp(r'[A-Za-z]')) || !password.contains(RegExp(r'[0-9]'))) {
        return "Пароль должен содержать не менее 10 символов, латинские буквы и цифры.";
      }

      // Проверка, зарегистрирован ли email
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

      // Создание нового пользователя
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Установка цвета по умолчанию (#D5D0E6)
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "name": name,
        "birthDate": birthDate,
        "email": email,
        "selectedColor": {
          'r': 213, // Красный компонент цвета #D5D0E6
          'g': 208, // Зеленый компонент
          'b': 230, // Синий компонент
          'a': 255, // Альфа-канал (непрозрачность)
        },
      });

      // Отправка письма с подтверждением email
      await userCredential.user!.sendEmailVerification();

      return null; // Успешная регистрация
    } on FirebaseAuthException catch (e) {
      return "Ошибка аутентификации: ${e.message}";
    } on FirebaseException catch (e) {
      return "Ошибка Firestore: ${e.message}";
    } catch (e) {
      return "Неизвестная ошибка: ${e.toString()}";
    }
  }

  // Метод для входа пользователя
  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Проверка, подтвержден ли email
      if (!userCredential.user!.emailVerified) {
        return "Подтвердите свою почту!";
      }

      return null; // Успешный вход
    } on FirebaseAuthException catch (e) {
      return "Ошибка аутентификации: ${e.message}";
    } catch (e) {
      return "Неизвестная ошибка: ${e.toString()}";
    }
  }

  // Метод для выхода пользователя
  Future<void> signOut() async {
    await _auth.signOut();
  }
}