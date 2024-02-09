import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Attendance_Details extends StatelessWidget {
  final String date;
   Attendance_Details(
      {
        super.key,
        required this.date
      }
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance of $date',style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: const Icon(Icons.arrow_back,color: Colors.black)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Employee').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error Occurred'));
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.separated(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              String name = documents[index]['Name'];
              String id = documents[index]['ID'];

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Employee').doc(documents[index].id).collection('Status').where('Date',isEqualTo: date).snapshots(),
                builder: (context, statusSnapshot) {
                  if (statusSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (statusSnapshot.hasError) {
                    return const Center(child: Text('Error Occurred'));
                  }

                  List<DocumentSnapshot> statusDocuments = statusSnapshot.data!.docs;

                  String status = statusDocuments.isNotEmpty ? statusDocuments.last['Status'] : 'Not available';

                  return ListTile(
                    title: Container(
                          decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 12,
                                blurStyle: BlurStyle.outer,
                                offset: Offset(2, 2),
                                blurRadius: 12
                              )
                            ]
                          ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Name: $name'),
                            const SizedBox(width: 10),
                            Text('ID: $id'),
                            const SizedBox(width: 10),
                            Text('Status: $status'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }, separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
          );
        },
      ),
    );
  }
}
