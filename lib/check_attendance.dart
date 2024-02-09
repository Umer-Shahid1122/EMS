import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'attendance_details.dart';

class Check_Attendance extends StatefulWidget {
  const Check_Attendance({super.key});

  @override
  State<Check_Attendance> createState() => _Check_AttendanceState();
}

class _Check_AttendanceState extends State<Check_Attendance> {

  var docId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance List',style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back,color: Colors.black,)),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Employee').snapshots() ,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasError){
            return const Text('Error');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> document = snapshot.data!.docs;
          // if(document.isNotEmpty && docId.isEmpty){
          //   setState(() {
          //     docId = document[0].id;
          //
          //   });
          // }

          return Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Employee').doc(document[0].id).collection('Status').snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.hasError){
                          return const Center(child: Text('Error'));
                        }
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        }

                        List documentStatus = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: documentStatus.length,
                          itemBuilder: (BuildContext context, int index) {
                            var date = documentStatus[index]['Date'];
                            return ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Center(child: Text('Date: $date')),
                              ),
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>  Attendance_Details(date: date))
                                );
                              },
                            );
                          },
                        );
                      }
                  )
              )
            ],
          );
        },

      )
    );
  }
}
