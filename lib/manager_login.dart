import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lottie/lottie.dart';

import 'admin_login.dart';
import 'manager_screen.dart';

class Manager_Login extends StatefulWidget {
  const Manager_Login({super.key});
  @override
  State<Manager_Login> createState() => _Manager_LoginState();
}

class _Manager_LoginState extends State<Manager_Login> {

  bool isObscure = true;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();

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
                  const SizedBox(height: 30),

                  Container(
                      height: 300,
                      width: 250,
                      child: Lottie.asset('assets/Signup.json')) ,

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Manager Login', style:TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900
                    ),),
                  ),

                  const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: emailController,
                    validator: (text){
                      if (text == null){
                        return 'Null';
                      }

                      if (text.isEmpty) {
                        return 'Email is required';
                      }
                      if (!text.contains('@manager.com')){
                        return 'Email should be valid';
                      }
                      return null;
                    },
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
                    controller: passController,
                    validator: (text){
                      if (text == null){
                        return 'Null';
                      }
                      if (text.isEmpty){
                        return 'Password is required';
                      }
                      if (text.length < 8){
                        return 'At-least 8 character required';
                      }
                      return null;
                    },
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

                  // Login Button
                  InkWell(
                      onTap: () async{
                        if (_key.currentState!.validate()) {
                       //   Get.to(const Manager_Screen());
                           await  signInWithEmailAndPass(emailController.text, passController.text);
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
                  // Forget Button
                  InkWell(
                      onTap: (){
                        Get.snackbar('Forget Password', 'Ask your admin to create a new account for you');
                      },
                      child: const Text('Forget Password?')),

                  const SizedBox(height: 25,),
                  // Navigate to admin
                  InkWell(
                      onTap: ()async{
                        Get.to(const Admin_Login());
                      },
                      child: const Text('Login as an Admin'))

                ],
              ),
            ),
          ),
        )
    );
  }

  Future<void> signInWithEmailAndPass(String email, String pass) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);

      Get.snackbar('Welcome', 'You logged in as a manager',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.add_task_sharp)
      );

      Navigator.pushAndRemoveUntil(context,
          CupertinoPageRoute(builder: (context)=> const Manager_Screen()), (route) => false);
    }
    on FirebaseAuthException catch (e){

      Get.snackbar('Error signing in',e.toString());

    }


  }
}
