import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsible_student/modules/auth/auth_service/models/user_entity.dart';

abstract class AuthService {
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  UserEntity getCurrentUser();

  Future<void> signOut();
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithFacebook();
}
