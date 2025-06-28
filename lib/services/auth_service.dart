import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // Etapa 1: Login com Firebase usando o provedor Google diretamente
      final googleProvider = GoogleAuthProvider();

      final userCredential = await _auth.signInWithProvider(googleProvider);
      final user = userCredential.user;

      // Etapa 2: Salvar no Firestore se ainda não existir
      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'uid': user.uid,
            'displayName': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'role': 'user',
          });
        }
      }

      return user;
    } catch (e) {
      print('Erro no login com Google: $e');
      return null;
    }
  }
}
