import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:umer_ems/admin_screen.dart';
import 'package:umer_ems/manager_login.dart';

class Admin_Login extends StatefulWidget {
  const Admin_Login({super.key});

  @override
  State<Admin_Login> createState() => _Admin_LoginState();
}

class _Admin_LoginState extends State<Admin_Login> {

  // Password obscure
  bool isObscure = true;

  //Controller
  final emailController = TextEditingController();
  final passController  = TextEditingController();

  // Key
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 300,
                    width: 250,
                    child: Lottie.asset('assets/Login.json')) ,
                const SizedBox(height: 50),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Admin Login', style:TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900
                  ),),
                ),

                const SizedBox(height: 20),

                // Email
                TextFormField(
                  validator: (text){
                    if (text == null){
                      return 'Null';
                    }
                    if (text.isEmpty) {
                      return 'Required';
                    }
                    if (!text.contains('@gmail.com')){
                      return 'Use a valid email';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "User Name",
                    hoverColor: Colors.black,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),

                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.black
                      )
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    prefixIcon: const Icon(Icons.email_rounded),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Password
                TextFormField(
                    validator: (text){
                      if (text == null){
                        return 'Null';
                      }
                      if (text.isEmpty) {
                        return 'Required';
                      }
                      if (text.length<8){
                        return 'At-least 8 characters';
                      }
                      return null;
                    },
                  controller: passController,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.black
                        )
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon:const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                          onTap: (){
                             setState(() {
                               isObscure = !isObscure;
                             });
                          },
                          child: isObscure ? const Icon(Icons.visibility_off):
                                             const Icon(Icons.visibility),
                      ),
                ) ),
                const SizedBox(
                  height: 20 ,
                ),

                // Login button
                InkWell(
                  onTap: () async{
                    if (_key.currentState!.validate()) {
                      await signInWithEmailAndPass(emailController.text, passController.text);
                    }
                  },
                    child: Container(
                      height: 50,
                      width: 350,
                        decoration:  BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12.0)
                        ),
                        child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                            ),),
                            SizedBox(width: 20),
                            Icon(Icons.arrow_forward_rounded,color: Colors.white,)
                          ],
                        )))),
                const SizedBox(height: 20),

                // Forget Password
                InkWell(
                    onTap: ()async{
                    await resetLink(emailController.text);
                    },
                    child: const Text('Forget Password?')),
                const SizedBox(height: 25),
                InkWell(
                    onTap: ()async{
                      Get.to(const Manager_Login());
                    },
                    child: const Text('Login as a Manager'))
              ],
            ),
          ),
        ),
      )
    );
  }

  // Sign-In method
  Future<void> signInWithEmailAndPass(String email, String pass) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);

      Get.snackbar('Welcome', 'You logged in as an Admin',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.add_task_sharp)
      );
      Navigator.pushAndRemoveUntil(context,
          CupertinoPageRoute(builder: (context)=> const Admin_Screen()), (route) => false);

    }
    on FirebaseAuthException catch (e){

      Get.snackbar('Error signing in',e.toString());

    }
  }

  // Password reset link
Future<void> resetLink (String email) async {
    try {
      if (email.isEmpty){
        Get.snackbar('Email error', 'Provide your email first');
      }else{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Get.snackbar('Email sent', 'Check $email to reset password');
      }

    }
    on FirebaseAuthException catch (e) {

      Get.snackbar('Error requesting reset email', e.toString());
    }
}
}
