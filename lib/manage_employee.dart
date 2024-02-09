import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umer_ems/manager_screen.dart';

class Manage_Employee extends StatefulWidget {
  const Manage_Employee({super.key});

  @override
  State<Manage_Employee> createState() => _Manage_EmployeeState();
}

class _Manage_EmployeeState extends State<Manage_Employee> {
  double height = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Manage Employees', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Employee').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              Get.snackbar('Error', 'Can not fetch employees data', snackPosition: SnackPosition.BOTTOM);
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            List documents = snapshot.data!.docs;
            return ListView.separated(
              shrinkWrap: true,
              itemCount: documents.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                var name = documents[index]['Name'];
                var id = documents[index]['ID'];
                var address = documents[index]['Address'];
                var phone = documents[index]['Phone No'];
                var date = documents[index]['Joining Date'];
                var salary = documents[index]['Salary'];
                var desc = documents[index]['Description'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      height = height == 50.0 ? 120.0 : 50.0;
                    });
                  },
                  child: Dismissible(
                    onDismissed: (direction){
                      deleteItem(id);
                    },
                    key: GlobalKey(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: AnimatedContainer(
                          height: height,
                          duration: const Duration(seconds: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Name: $name', style: const TextStyle(color: Colors.white)),
                                    Text('Employee ID: $id', style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (height == 120.0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Address: $address', style: const TextStyle(color: Colors.white)),
                                  Text(date, style: const TextStyle(color: Colors.white)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (height == 120.0 )
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Phone: $phone', style: const TextStyle(color: Colors.white)),
                                  Text('Salary: $salary', style: const TextStyle(color: Colors.white)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (height == 120.0)
                                SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Description: $desc', style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void deleteItem(String id) async{

    try {
      CollectionReference empRef = FirebaseFirestore.instance.collection('Employee');
      QuerySnapshot queryDel = await empRef.where('ID',isEqualTo: id).get();
      if (queryDel.docs.isNotEmpty){
        await empRef.doc(queryDel.docs.first.id).delete();
        Get.snackbar('Success', 'Message deleted successfully');
      }

    }  catch (e) {
      Get.snackbar('Error Deleting', e.toString());
    }
  }
}
