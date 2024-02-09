import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:umer_ems/employee_modal.dart';
import 'package:umer_ems/manager_screen.dart';

class Add_Employee extends StatefulWidget {
  const Add_Employee({super.key});

  @override
  State<Add_Employee> createState() => _Add_EmployeeState();
}

class _Add_EmployeeState extends State<Add_Employee> {

  // Loading
  bool isLoading = false;

  // Key
  final _key = GlobalKey<FormState>();

  // For Date
  String showText = 'Joining Date';
  DateTime? selectedDate ;

  // Employee Data Controller
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNoController = TextEditingController();
  final salaryController = TextEditingController();
  final descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back,color: Colors.black,)),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [

                // Employee ID
                TextFormField(
                  controller: idController,
                  validator: (text){
                    if (text == null){
                      return '';
                    }
                    if (text.isEmpty){
                      return 'Required Information';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    labelText: 'Employee ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.perm_identity)
                  ),
                ),
                const SizedBox(height: 20),

                // Employee Name
                TextFormField(
                  controller: nameController,
                  validator: (text){
                    if (text == null){
                      return '';
                    }
                    if (text.isEmpty){
                      return 'Required Information';
                    }
                    return null;
                  },
                  decoration:  InputDecoration(
                      labelText: 'Employee Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.abc)
                  ),
                ),
                const SizedBox(height: 20),

                // Address
                TextFormField(
                  controller: addressController,
                  validator: (text){
                    if (text == null){
                      return '';
                    }
                    if (text.isEmpty){
                      return 'Required Information';
                    }
                    return null;
                  },
                  decoration:  InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.abc)
                  ),
                ),
                const SizedBox(height: 20),

                // Number
                TextFormField(
                  controller: phoneNoController,
                  keyboardType: TextInputType.number,
                  validator: (text){
                    if (text == null){
                      return '';
                    }
                    if (text.isEmpty){
                      return 'Required Information';
                    }
                    return null;
                  },
                  decoration:  InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.numbers_rounded)
                  ),
                ),
                const SizedBox(height: 20),

                // Date
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined),
                    InkWell(
                      onTap: showDate,
                        child: Text(showText)),

                  ],
                ),
                const SizedBox(height: 20),

                // Salary
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 150,
                    child: TextFormField(
                      controller: salaryController,
                      validator: (text){
                        if (text == null){
                          return '';
                        }
                        if (text.isEmpty){
                          return 'Required field';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Salary per day',
                        prefixIcon: Icon(Icons.attach_money_sharp)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                TextFormField(
                  controller: descriptionController,
                  validator: (text){
                    if (text == null){
                      return '';
                    }
                    if (text.isEmpty){
                      return 'Required Information';
                    }
                    return null;
                  },
                  decoration:  InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.description)
                  ),
                ),
                const SizedBox(height: 20),

                // Submit
                InkWell(
                  onTap: ()async{
                    if(_key.currentState!.validate()){
                      setState(() {
                        isLoading = true;
                      });
                      await addEmployee();

                    }
                  },
                  child: isLoading ? const CircularProgressIndicator() :
                  Container(
                    height: 50,
                    width: 350,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child:  const Center(
                        child: Text('Submit', style: TextStyle(
                            color: Colors.white,
                            fontSize: 19
                        ),),
                      ),
                )),
                const SizedBox(height: 10),

                // Cancel
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
          ),
        ),
      ),
    ) ;
  }

  // Date Picker
  void showDate() async{
    DateTime now = DateTime.now();
   final pickedDate =   await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year-5,now.month,now.day),
        lastDate: now
    );
   if (pickedDate != null){
     setState(() {
       selectedDate = pickedDate;
     });
   }
   if(selectedDate != null){
     setState(() {
       showText = 'Date=${selectedDate!.toLocal()}'.split(' ')[0];
     });
   }

  }

  // Function to Add employee
  Future<void> addEmployee() async{

    try{
      bool isIdUnique = await uniqueIdCheck(idController.text);
      if (!isIdUnique){
        Get.snackbar('Employee ID Error', 'Employee Id already exist.');
      }else{
        EmployeeModal empData =  EmployeeModal(
            id: idController.text,
            name: nameController.text,
            address: addressController.text,
            phoneNo: phoneNoController.text,
            joiningDate: showText,
            salaryPerDay: salaryController.text,
            description: descriptionController.text);

        FirebaseFirestore firebase = FirebaseFirestore.instance;
        CollectionReference employeeRef = firebase.collection('Employee');
        Get.to(const Manager_Screen());
        Get.snackbar('Success', 'Employee added successfully',
            icon: const Icon(Icons.add_task_sharp),snackPosition: SnackPosition.BOTTOM);
        await employeeRef.add(empData.toJson());

      }

    } catch (e){

      Get.snackbar('Error Adding Employee',e.toString());

    }
  }

  // Function to make Employee ID unique
  Future<bool> uniqueIdCheck(String id) async{
    try{
      CollectionReference employRef = FirebaseFirestore.instance.collection('Employee');
      QuerySnapshot queryId = await employRef.where('ID', isEqualTo: id).get();
      return queryId.docs.isEmpty;

    }catch (e){
      return false;
    }
  }
}
