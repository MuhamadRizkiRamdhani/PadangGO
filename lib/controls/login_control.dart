import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> login({
  required BuildContext context,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required Function(String?) setError,
  required Function(bool) setLoading,
}) async {
  setLoading(true);
  setError(null);
  try {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
    final uid = credential.user?.uid;
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final role = userDoc.data()?['role'] ?? 'user';
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/dashboard_admin');
      } else {
        Navigator.pushReplacementNamed(context, '/katalog');
      }
    } else {
      setError('User tidak ditemukan');
    }
  } on FirebaseAuthException catch (e) {
    setError(e.message ?? 'Login failed');
  } finally {
    setLoading(false);
  }
}

Future<void> register({
  required BuildContext context,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required Function(String?) setError,
  required Function(bool) setLoading,
}) async {
  setLoading(true);
  setError(null);
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
    final uid = userCredential.user?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': emailController.text.trim(),
      'role': 'user',
    });
    Navigator.pushReplacementNamed(context, '/katalog');
  } on FirebaseAuthException catch (e) {
    setError(e.message ?? 'Register failed');
  } finally {
    setLoading(false);
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
}
