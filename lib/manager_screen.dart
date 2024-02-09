import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:umer_ems/manage_employee.dart';
import 'add_Employee.dart';
import 'attendance.dart';
import 'manager_login.dart';

class Manager_Screen extends StatefulWidget {
  const Manager_Screen({super.key});

  @override
  State<Manager_Screen> createState() => _Manager_ScreenState();
}

class _Manager_ScreenState extends State<Manager_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Portal',style: TextStyle(color: Colors.black) ),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      drawer: Drawer(
          child: ListView(
            children:  [
              const DrawerHeader(child: Text('')),

              // Add Employee
              ListTile(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.add, color: Colors.black,),
                    SizedBox(width: 20),
                    Text('Add Employee')
                  ],
                ),
                onTap: (){
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context)=> const Add_Employee()));
                },
              ),

              // Manage Employee
              const SizedBox(height: 15),
              ListTile(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.update, color: Colors.black,),
                    SizedBox(width: 20,),
                    Text('Manage Employees')
                  ],
                ),
                onTap: (){
                  Get.to(const Manage_Employee());
                },
              ),

              // Attendance
              const SizedBox(height: 15),
              ListTile(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.airplane_ticket, color: Colors.black,),
                    SizedBox(width: 20,),
                    Text('Attendance')
                  ],
                ),
                onTap: (){
                  Get.to(const Attendance());
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.logout,color: Colors.black,),
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
                                        builder: (context) => const Manager_Login()),
                                        (route) => false);
                              },
                            )
                          ],
                        );
                      });
                },
              ),
            ],
          )
      ),
      body: const Center(child: Text('This is manager Screen')),
    );
  }
}


