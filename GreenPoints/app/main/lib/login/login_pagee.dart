
import 'package:boot1_project/home_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login/flutter_login.dart';
import '../constants.dart';
import '../add_product.dart';
import '../mode.dart';
import 'package:boot1_project/profile_pagee.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            FlutterLogin(
              messages: LoginMessages(
                userHint: "E-Posta",
                signupButton: "Hesap Oluştur",
                loginButton: "Giriş Yap",
                confirmPasswordHint: "Parola Tekrar",
                passwordHint: "Parola",
                confirmPasswordError: "Parolalar eşleşmiyor",
              ),
              theme: LoginTheme(
                primaryColor: Colors.white,
                cardTheme: CardTheme(color: Colors.grey.shade100.withOpacity(0.9)),
                buttonTheme: LoginButtonTheme(
                  backgroundColor: Colors.green, // Yeşil renk burada tanımlanıyor
                ),
              ),
              onLogin: _authUser,
              onSignup: _signupUser,
              onSubmitAnimationCompleted: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ucuncuSayfa(),
                ));
              },
              hideForgotPasswordButton: true,
              onRecoverPassword: _recoverPassword,
            ),

            Positioned(
              top: deviceSize.height / 8.2,
              left: deviceSize.width / 3.5, // Değişiklik burada
              child: Column(
                children: [
                  Text(
                    "GREEN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.lightGreen
                    ),
                  ),
                  Text(
                    "P O İ N T S",
                    style: TextStyle(fontSize: 25, color: Colors.green),
                  ),
                ],
              ),
            ),

            MediaQuery.of(context).viewInsets == EdgeInsets.zero
                ? Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 200,
                  height: 200,

                ))
                : SizedBox(),
          ],
        ));
  }

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
    DatabaseReference conversionsRef = FirebaseDatabase.instance.ref().child("conversions");

    return usersRef.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map usersData = snapshot.value as Map;

        if (checkCredentials(data.name, data.password, usersData)) {
          // Kullanıcı doğrulandı, şimdi fotoğrafı dönüşüm tablosuna kaydedelim
          String userId = data.name.split('@')[0]; // Kullanıcı adından benzersiz bir ID oluştur

          // Kullanıcının giriş yaptığı tarihi al
          DateTime now = DateTime.now();
          String timestamp = now.toIso8601String();

          // Dönüşüm tablosuna fotoğrafı eklemek için bir referans oluştur
          DatabaseReference newConversionRef = conversionsRef.push();

          // Yeni bir dönüşüm nesnesi oluştur
          Map<String, dynamic> newConversion = {
            "userId": userId,
            "timestamp": timestamp,
            "photoUrl": "", // Fotoğraf henüz yüklenmedi, bu alan boş
          };

          // Dönüşüm nesnesini Firebase Realtime Database'e ekle
          newConversionRef.set(newConversion);

          // Profil sayfasına yönlendir
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ProfilePage(email: data.name),
          ));
          return null;
        } else {
          return 'Kullanıcı Bulunamadı';
        }
      }
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    await ref.push().update({
      "email": data.name,
      "password": data.password,
    });

    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  bool checkCredentials(String email, String password, Map users) {
    for (var entry in users.entries) {
      var userId = entry.key;
      var userData = entry.value;

      if (userData['email'] == email && userData['password'] == password) {
        print('Credentials matched for user with ID: $userId');
        return true;
      }
    }

    print('Invalid credentials.');
    return false;
  }
}
