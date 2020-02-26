import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notification2 extends StatefulWidget {
  @override
  _Notification2State createState() => _Notification2State();
}

class _Notification2State extends State<Notification2> {
  QuerySnapshot querySnapshot;
  @override
  void initState() {
    super.initState();
    getNotifications().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NOTIFICATION"),
        centerTitle: true,
      ),
      body:_showNotifications ());
  }

  Widget _showNotifications() {
    //check if querysnapshot is null
    if (querySnapshot != null) {
      return ListView.builder(
        primary: false,
        itemCount: querySnapshot.documents.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
//load data into widgets
              // Text("${querySnapshot.documents[i].data['title']}"),
              // Text("${querySnapshot.documents[i].data['message']}"),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.notifications),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text("${querySnapshot.documents[i].data['title']}")
                    ),
                  ],
                ),
                subtitle: Row(
                  children: <Widget>[
                    SizedBox(width: 35,),
                    Expanded(child: Text("${querySnapshot.documents[i].data['message']}")),
                  ],
                ), 
              ),
              Divider(color: Colors.grey, indent: 10, endIndent: 10,)
           
            ],
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  getNotifications() async {
    return await Firestore.instance.collection('notifications').orderBy('timestamp', descending: false).getDocuments();
    // 
  }
}
