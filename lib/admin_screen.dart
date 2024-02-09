import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:umer_ems/add_manager.dart';
import 'package:umer_ems/admin_login.dart';
import 'package:umer_ems/check_attendance.dart';
import 'package:umer_ems/manage_employee.dart';

class Admin_Screen extends StatefulWidget {
  const Admin_Screen({super.key});

  @override
  State<Admin_Screen> createState() => _Admin_ScreenState();
}

class _Admin_ScreenState extends State<Admin_Screen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Admin Portal', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('')),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.checklist_rtl),
                  SizedBox(width: 10,),
                  Text('Check Employees'),
                ],
              ),
              onTap: (){
                  Get.to(const Manage_Employee());
              },
            ),
            const SizedBox(height: 15),
             ListTile(
              title: const Row(
                children: [
                  Icon(Icons.accessibility_new_sharp),
                  SizedBox(width: 10,),
                  Text('Create Manager'),
                ],
              ),
              onTap: (){
                Get.to(const Add_Manager());
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.fact_check),
                  SizedBox(width: 10,),
                  Text('Check Attendance'),
                ],
              ),
              onTap: (){
                Get.to(Check_Attendance());
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 10,),
                  Text('Logout'),
                ],
              ),
              onTap: (){
                showCupertinoDialog(
                    context: context,
                    builder: (c) {
                      return CupertinoAlertDialog(
                        title: const Text('Do you want to Logout?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('Logout'),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const Admin_Login()),
                                      (route) => false);
                            },
                          )
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Employee').snapshots(),
         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            Get.snackbar('Error', 'Can not fetch employees data', snackPosition: SnackPosition.BOTTOM);
         }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
    List documents = snapshot.data!.docs;

    return Center(
        child: Text('Total Employees registered: ${documents.length}'));
  }
        )
    );
}}
