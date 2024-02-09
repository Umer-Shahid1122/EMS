import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:umer_ems/attendance_modal.dart';
import 'package:umer_ems/manager_screen.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<Color> presentColor = List.filled(20, Colors.black);
  List<Color> absentColor = List.filled(20, Colors.black);

  String showText = 'Select Date';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Add Attendance', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('Employee').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }

            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            return Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 15),
                    InkWell(
                        onTap: showDate,
                        child: Text(showText)
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.separated(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      Attendance_Modal attendanceModal = Attendance_Modal(
                        status: 'Absent',
                        id: documents[index]['ID'],
                        date: showText
                      );
                      var name = documents[index]['Name'];
                      var id = documents[index]['ID'];

                      return ListTile(
                        title: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                            boxShadow:  const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                blurStyle: BlurStyle.outer,
                                spreadRadius: 10,
                              )
                            ]
                          ),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Name: $name'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('ID: $id'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Present Button
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (id == attendanceModal.id && absentColor[index] == Colors.white) {
                                          attendanceModal.status = 'Present';
                                          presentColor[index] = Colors.green;
                                        } else {
                                          attendanceModal.status = 'Present';
                                          presentColor[index] = Colors.green;
                                          absentColor[index] = Colors.white;
                                        }
                                      });
                                    },
                                    child: Text('Present', style: TextStyle(color: presentColor[index])),
                                  ),

                                  const SizedBox(width: 40,),
                                  // Absent Button
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (id == attendanceModal.id && presentColor[index] == Colors.white) {
                                          attendanceModal.status = 'Absent';
                                          absentColor[index] = Colors.red;
                                        } else {
                                          presentColor[index] = Colors.white;
                                          attendanceModal.status = 'Absent';
                                          absentColor[index] = Colors.red;
                                        }
                                      });
                                    },
                                    child: Text('Absent', style: TextStyle(color: absentColor[index])),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(20.0),
                          //   child: Container(
                          //     height: 2,
                          //     color: Colors.grey,
                          //   ),
                          // ),
                          SizedBox(height: 1)
                        ],
                      );
                    },
                  ),
                ),

                //Submit Button
                InkWell(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    for (int i = 0; i < documents.length; i++) {
                      var id = documents[i].id;
                      var status = presentColor[i] == Colors.green ? 'Present' : 'Absent';
                      await addAttendance(id, status,showText);
                    }
                  },
                  child: isLoading? const CircularProgressIndicator(): Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // Cancel button
                InkWell(
                  onTap: () {
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
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> addAttendance(String id, String status, String date) async {
    try{
      CollectionReference ref = FirebaseFirestore.instance.collection('Employee');
      DocumentReference docRef = ref.doc(id);

      bool docExist = (await docRef.get()).exists;
      bool isDateUnique = await uniqueDate(id, date);

      if (docExist && isDateUnique ) {
        Attendance_Modal finalModal = Attendance_Modal(status: status, id: id, date: showText);
        CollectionReference statusRef = docRef.collection('Status');
        await statusRef.add(finalModal.toJson());
        Get.to(const Manager_Screen());
        Get.snackbar('SUBMITTED','Attendance submitted successfully',icon: const Icon(Icons.add_task_sharp));
      } else if (!isDateUnique) {
        setState(() {
          isLoading = false;
        });
        Get.snackbar('Date Issue', '$date already added',icon: const Icon(Icons.error));
      } else{
        Get.snackbar('ERROR', 'Error submitting attendance');

      }
    } catch (e){
      Get.snackbar('Error', e.toString());
    }

  }

  // Unique date
  Future<bool> uniqueDate (id, date) async {
    try {
      CollectionReference empRef = FirebaseFirestore.instance.collection('Employee');
      DocumentReference empDocRef = empRef.doc(id);

      CollectionReference statusRef = empDocRef.collection('Status');
      QuerySnapshot snapshot = await statusRef.where('Date',isEqualTo: date).get();
      return snapshot.docs.isEmpty;

    } catch (e) {
      return false;
    }
  }

  // DatePicker
void showDate() async{
  DateTime now = DateTime.now();
  final pickedDate = await showDatePicker(
        context: context,
        initialDate: now ,
        firstDate: DateTime(now.year-10,now.day,now.month),
        lastDate: now
    );
  if(pickedDate!= null){
    setState(() {
      showText = '$pickedDate'.split(' ')[0];
    });
  }
}
}
