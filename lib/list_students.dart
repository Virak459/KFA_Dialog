import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:t1/db.dart';
import 'package:t1/edit_student.dart';

class ListStudents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListStudents();
  }
}

class _ListStudents extends State<ListStudents> {
  List<Map> slist = [];
  MyDb mydb = new MyDb();

  @override
  void initState() {
    mydb.open();
    getdata();
    super.initState();
  }

  getdata() {
    Future.delayed(Duration(milliseconds: 500), () async {
      slist = await mydb.db.rawQuery('SELECT * FROM students');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Students"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: slist.length == 0
              ? Text("No any students to show.")
              : Column(
                  children: slist.map((stuone) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.people),
                        title: Text(stuone["name"]),
                        subtitle: Text("Roll No:" +
                            stuone["roll_no"].toString() +
                            ", Add: " +
                            stuone["address"]),
                        trailing: Wrap(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return EditStudent(
                                        rollno: stuone["roll_no"]);
                                  }));
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () async {
                                  await mydb.db.rawDelete(
                                      "DELETE FROM students WHERE roll_no = ?",
                                      [stuone["roll_no"]]);
                                  print("Data Deleted");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Student Data Deleted")));
                                  getdata();
                                },
                                icon: Icon(Icons.delete, color: Colors.red))
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}
