import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:umer_ems/admin_screen.dart';
import 'package:umer_ems/manager_modal.dart';

class Add_Manager extends StatefulWidget {
  const Add_Manager({super.key});

  @override
  State<Add_Manager> createState() => _Add_ManagerState();
}

class _Add_ManagerState extends State<Add_Manager> {

  bool isObscure = true;
  final key = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text('Create Manager Account',style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Form(
        key: key,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Name
                TextFormField(
                  controller: nameController,
                  validator: (text){
                    if (text == null){
                      return 'Null';
                    }
                    if(text.isEmpty){
                      return 'Required';
                    }
                    // if(!text.contains('@manager.com')){
                    //   return 'Not a proper email';
                    // }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Manager Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    prefixIcon: const Icon(Icons.drive_file_rename_outline)
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: emailController,
                  validator: (text){
                    if (text == null){
                      return 'Null';
                    }
                    if(text.isEmpty){
                      return 'Required';
                    }
                    if(!text.contains('@manager.com')){
                      return 'Not a proper email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Manager Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon: const Icon(Icons.alternate_email)
                  ),
                ),
                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: passController,
                  obscureText: isObscure,
                  validator: (text){
                    if (text == null){
                      return 'Null';
                    }
                    if(text.isEmpty){
                      return 'Required';
                    }
                    if(text.length<8){
                      return 'Password is short';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Manager Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon: const Icon(Icons.alternate_email),
                    suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      child: isObscure ? const Icon(Icons.visibility_off):
                      const Icon(Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Create Button
                InkWell(
                    onTap: () async{
                      if (key.currentState!.validate()) {
                          createManager(emailController.text, passController.text);
                          addManager(nameController.text, emailController.text, passController.text);
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
                            child: Center(
                              child: Text('CREATE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),),
                            )))),
                const SizedBox(height: 22),

                // Cancel Button
                InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                        child: Text('Cancel', style: TextStyle(
                            color: Colors.white,
                            fontSize: 19
                        ),),
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  // Create Manager
 Future<void> createManager (String email,pass) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(email: email, password: pass);
      Get.to(const Admin_Screen());
      Get.snackbar('Success', 'Manager account created on mail ($email)',
          snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error Creating Account', e.toString(), duration: Duration(seconds: 9));
    }

 }

 Future<void> addManager(String name,email,pass) async{
    try {
      Manager_Modal manager = Manager_Modal(name: name, email: email, pass: pass);
      CollectionReference ref = FirebaseFirestore.instance.collection('Manager');
      ref.add(manager.toJson());

    } catch (e) {
      // Todo
    }
 }
}
