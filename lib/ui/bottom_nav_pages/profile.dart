
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _namecontrolar;
  TextEditingController? _phonecontrolar;
  TextEditingController? _agecontrolar;
  updatedata(){
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update(
        {
          "name":_namecontrolar!.text,
          "phone":_phonecontrolar!.text,
          "age":_agecontrolar!.text,
        }
    ).then((value) => print("Updated Successfully"));
  }
  setDataToTextField(data){
    return  Column(
      children: [
        TextFormField(
          controller: _namecontrolar = TextEditingController(text: data['name']),
        ),
        TextFormField(
          controller: _phonecontrolar = TextEditingController(text: data['phone']),
        ),
        TextFormField(
          controller: _agecontrolar = TextEditingController(text: data['age']),
        ),
        ElevatedButton(onPressed: ()=>updatedata(), child: Text("Update"))
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream:FirebaseFirestore.instance.collection("users-form-data").doc(FirebaseAuth.instance.currentUser!.email).snapshots() ,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              var data = snapshot.data;
              if(data==null){
                return Center(child: CircularProgressIndicator(),);
              }
              return setDataToTextField(data);
            },
          ),
        ),
      ),
    );
  }
}
