import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// GETTER OF USER STREAM
  Stream<User?> get user => firebaseAuth.authStateChanges();

//  SIGN UP
  Future<void> signUp({required String email,
    required String password,
    required String name, required String userName}) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await user.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-exists") {
        throw ("Email exists");
      } else if (error.code == "invalid-email") {
        throw ('invalid email');
      } else {
        throw ("An error occurred");
      }
    } catch (error) {
      throw ("An error occurred");
    }
  }

// SIGN IN
  Future<void> signIn({required String email, required String password})async{
    try{
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(error){
      if(error.code == 'user-not-found'){
        throw("user-not-found");
      }else if(error.code == "wrong-password"){
        throw("Wrong password");
      }else{
        throw("An error occurred");
      }
    }catch(error){
      throw("An error occurred");
    }
  }

// SIGN OUT
  Future<void> signOut()async{
    await firebaseAuth.signOut();
  }

  // SEND EMAIL VERIFICATION METHOD
  Future<void> verifyEmail()async{
    try{
      await firebaseAuth.currentUser!.sendEmailVerification();

    }on FirebaseAuthException{
      throw("An error has occurred");
    }
    catch (error){
      throw("An error has occurred");
    }
  }
  //RESET PASSWORD METHOD
  Future<void> resetPassword(String email)async {
    try{
      await firebaseAuth.sendPasswordResetEmail(email: email);
    }catch(error){
      throw("An error has occurred");
    }
  }

  Future<void> updateInfo(String? name, String? password)async {
    try {
      if (name != "") {
        await firebaseAuth.currentUser!.updateDisplayName(name);
      }
      if (password != "") {
        await firebaseAuth.currentUser!.updatePassword(password!);
      }
    }
    catch (error) {
      throw("An error occurred. Please try again.");
    }
  }
}
final authServiceProvider = Provider((ref) => AuthService());

final authenticationState = StreamProvider<User?>((ref){
  return ref.read(authServiceProvider).user;
});
