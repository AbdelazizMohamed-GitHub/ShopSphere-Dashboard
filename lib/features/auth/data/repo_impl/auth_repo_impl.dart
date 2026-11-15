import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shop_sphere_dashboard/core/errors/fairebase_failure.dart';
import 'package:shop_sphere_dashboard/core/service/firestore_service.dart';
import 'package:shop_sphere_dashboard/core/service/notification_service.dart';
import 'package:shop_sphere_dashboard/features/auth/data/model/user_model.dart';
import 'package:shop_sphere_dashboard/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirestoreService firestoreService;
  AuthRepoImpl({required this.firestoreService});

  @override
  Future<Either<FirebaseFailure, String>> registerWithEmailAndPassword({
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
    required DateTime birthDate,
    required String gender,
  }) async {
    UserCredential? userCredential;
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String? token = await NotificationService.getToken();
      FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      await firestoreService.addData(
        collection: "users",
        did: userCredential.user!.uid,
        data: UserModel(
          fcmToken: token.toString(),
          isStaff: false,
          favProduct: [],
          birthDate: birthDate,
          email: email,
          gender: gender,
          name: name,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          addressIndex: 0,
          uid: userCredential.user!.uid,
          profileImage: '',
        ),
      );
      FirebaseAuth.instance.currentUser?.updateProfile(displayName: name);
      await userCredential.user?.sendEmailVerification();

      return Right(userCredential.user?.uid ?? "");
    } on FirebaseAuthException catch (e) {
      if (userCredential!.user != null) {
        await userCredential.user!.delete();
      }
      return Left(FirebaseFailure.fromCode(e.code));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, String>> logInWithEmailAndPassword(
    String email,
    String password,
    context,
  ) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final data = await firestoreService.getUserData();

      if (data.isStaff) {
        return const Right('Staff');
      }

      return Right(user.user?.uid ?? "");
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromCode(e.code));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, String>> logInWithGoogle() async {
    try {
      // 1. إعداد Google Provider للويب
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope(
        'https://www.googleapis.com/auth/contacts.readonly',
      );

      // 2. تسجيل الدخول باستخدام Google Popup
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithPopup(googleProvider);

      // 3. التحقق من المستخدم
      final User? user = userCredential.user;

      if (user == null) {
        return Left(FirebaseFailure(message: 'User not found after login.'));
      }

      final String uid = user.uid;

      // 4. جلب بيانات المستخدم من Firestore
      final DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid);

      final DocumentSnapshot<Map<String, dynamic>> userDoc = await userRef
          .get();

      // 5. إنشاء بيانات المستخدم لو أول تسجيل دخول
      if (!userDoc.exists) {
        await firestoreService.addData(
          collection: 'users',
          did: uid,
          data: UserModel(
            uid: uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            phoneNumber: user.phoneNumber ?? '',
            profileImage: user.photoURL ?? '',
            birthDate: user.metadata.creationTime ?? DateTime.now(),
            gender: '',
            fcmToken: '',
            isStaff: false,
            addressIndex: 0,
            createdAt: DateTime.now(),
            favProduct: [],
          ),
        );
      }

      // 6. جلب بيانات المستخدم بعد تسجيل الدخول
      final userData = await firestoreService.getUserData();

      // 7. تحديد نوع المستخدم
      if (userData.isStaff) {
        return const Right('Staff');
      }

      return const Right('Logged in successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request') {
        return Left(
          FirebaseFailure(
            message: 'Google sign-in was cancelled.',
            code: e.code,
          ),
        );
      }
      return Left(FirebaseFailure.fromCode(e.code));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, String>> signInWithIdTokenFromWeb(
    String idToken,
  ) async {
    try {
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        return Left(FirebaseFailure(message: 'User not found after login.'));
      }

      final uid = user.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final token = await NotificationService.getToken() ?? '';

      if (!userDoc.exists) {
        await firestoreService.addData(
          collection: "users",
          did: uid,
          data: UserModel(
            uid: uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            phoneNumber: user.phoneNumber ?? '',
            profileImage: user.photoURL ?? '',
            birthDate: user.metadata.creationTime ?? DateTime.now(),
            gender: '',
            fcmToken: token,
            isStaff: false,
            addressIndex: 0,
            createdAt: DateTime.now(),
            favProduct: [],
          ),
        );
      } else {
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'fcmToken': token,
        }, SetOptions(merge: true));
      }

      final userData = await firestoreService.getUserData();
      if (userData.isStaff) {
        return const Right('Staff');
      }

      return const Right("Logged in successfully");
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromCode(e.code));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, String>> verifiyEmaill() async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        if (user.emailVerified) {
          return const Right("Email is verified ✅");
        } else {
          await user.sendEmailVerification();
          return Left(
            FirebaseFailure(
              message: "Verification email sent. Please check your inbox.",
            ),
          );
        }
      } else {
        return Left(FirebaseFailure(message: "User not found"));
      }
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromCode(e.code));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromCode(e.code));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isSignedIn() async {
    User? user = _firebaseAuth.currentUser;
    return user == null ? false : true;
  }

  @override
  Future<Either<FirebaseFailure, String>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return right('done sucsess');
    }  on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure.fromCode(e.code));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
