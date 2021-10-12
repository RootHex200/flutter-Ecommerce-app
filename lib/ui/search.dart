
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _inputtext="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (val){
                  setState(() {
                    _inputtext=val;
                    print(_inputtext);
                  });
                },
              ),
              Expanded(child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Product").where("product-name",
                      isGreaterThanOrEqualTo: _inputtext).snapshots()
                  ,
                  builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasError){
                      return Center(child: Text("something wrong"),);
                    }
                    else if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: Text("something wrong"),);
                    }
                    return ListView(
                      children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text(data['product-name']),
                          leading: Image.network(data['product-img'][0]),
                        ),
                      );
                    }).toList(),
                    );
                    },

                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
