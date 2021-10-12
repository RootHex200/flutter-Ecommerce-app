

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomarce/const/AppColors.dart';
import 'package:flutter_ecomarce/ui/showdata.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../search.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _dotpostion=0;

  TextEditingController _searchcontrolar=TextEditingController();
  List <String> _carsuseiteimage=[];
  List _products=[];
  var _firestoreintance=FirebaseFirestore.instance;
  fetchcarsoritemimage()async{
    QuerySnapshot qn=await _firestoreintance.collection("carsurslider").get();
    setState(() {
      for(int i=0;i<qn.docs.length;i++){
        _carsuseiteimage.add(qn.docs[i]["img"]);
        print(qn.docs[i]["img"]);
      }
    });
    return qn.docs ;
  }
  fetchProducts() async {
    QuerySnapshot qn = await _firestoreintance.collection("Product").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-name": qn.docs[i]["product-name"],
          "product-description": qn.docs[i]["description"],
          "product-price": qn.docs[i]["product-price"],
          "product-img": qn.docs[i]["product-img"],
        });
      }
    });
    print(_products);
    return qn.docs;
  }
  void initState(){
    super.initState();
    fetchProducts();
    fetchcarsoritemimage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left:20.w,right: 20.w),
              child: Row(
                children: [
                  Expanded(child: SizedBox(
                    height: 60.h,
                    child: TextFormField(
                      readOnly: true,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                            color: Colors.blue
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide: BorderSide(
                                color: Colors.grey
                            ),

                        ),
                        hintText: "Serach product here ",
                        hintStyle: TextStyle(fontSize: 15.sp),

                      ),
                    ),
                  )),
                  GestureDetector(
                    child: Container(
                      height: 60.h,
                      width: 60.h,
                      color: AppColors.deep_orange,
                      child: Center(
                        child: Icon(Icons.search,color: Colors.white,),
                      ),
                    ),
                    onTap: (){},
                  )
                ],
              ),
            ),
            SizedBox(height:10.h,),
            AspectRatio(

              aspectRatio: 3.5,
              child: CarouselSlider(items:_carsuseiteimage.map((item) => Padding(
                padding: const EdgeInsets.only(left: 3,right: 3),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:NetworkImage(item),
                      fit: BoxFit.fitWidth,
                    )
                  ),
                ),
              )).toList(), options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (val,carupagereson){
                  setState(() {
                    _dotpostion=val;
                  });

                }
              ),),
            ),
            SizedBox(height:10.h,),
            DotsIndicator(
                dotsCount: _carsuseiteimage.length==0?1:_carsuseiteimage.length,
              position: _dotpostion.toDouble(),
              decorator: DotsDecorator(
                activeColor: AppColors.deep_orange,
                color: AppColors.deep_orange.withOpacity(0.5),
                spacing: EdgeInsets.all(2),
                activeSize: Size(8,9),
                size: Size(6,6)
              ),
            ),
            SizedBox(height:15.h,),
            Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: _products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1),
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowData(_products[index]))),
                        child: Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              AspectRatio(aspectRatio: 2,child: Image.network(_products[index]["product-img"][0])),
                              Text(_products[index]["product-name"]),
                              Text(_products[index]["product-price"]),
                            ],
                          ),
                        ),
                      );
                    }
                )
            )
          ],
        ),
      ),
    );
  }

}

