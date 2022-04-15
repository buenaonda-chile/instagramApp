import 'package:flutter/material.dart';
import './style.dart' as style;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        // initialRoute: '/',
        // routes: {
        //   '/' : (c) => Text('첫페이지'),
        //   '/detail' : (c) => Text('둘째페이지')
        // },
       home: MyApp(),
      )
  );
}

var a = TextStyle();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

final PageController pageController = PageController( initialPage: 0, );

class _MyAppState extends State<MyApp> {
  var data = [];
  var userImage;
  var userContent;

  saveData() async {
    var storage = await SharedPreferences.getInstance();

    var map = {'age' : 20};
    storage.setString('name', 'john');
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? '없습니다';
    print(jsonDecode(result)['age'].runtimeType);
  }

  addMyData(){
    var myData = {
      'id' : data.length + 1,
      'image' : userImage,
      'likes' : 5,
      'date' : 'July 5',
      'content' : userContent,
      'liked' : false,
      'user' : 'John Kim'
    };

    setState(() {
      data.insert(0, myData);
    });
  }

  setUserContent(a){
    setState(() {
      userContent = a;
    });
  }

  addData(a){
    setState(() {
      data.add(a);
    });
  }

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (result.statusCode == 200){

    } else {

    }

    var jsonResult = jsonDecode(result.body);

    setState(() {
      data = jsonResult;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var data = getData();
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            IconButton(onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }
              Navigator.push(context,
                MaterialPageRoute(builder: (c) => Upload(
                    userImage : userImage, setUserContent : setUserContent, addMyData : addMyData
                ))
              );
            },
                icon: Icon(Icons.add_box_outlined),
                iconSize: 30,
            )
          ]
      ),
      body: PageView(
        controller: pageController,
        children: [
          Text('홈페이지'),
          Home(data : data)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            pageController.animateToPage(i, duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, this.data}) : super(key: key);
  final data;

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  getMore() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var jsonResult = jsonDecode(result.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent){
        print('dd');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty){
      return ListView.builder(itemCount: 4, controller: scroll, itemBuilder: (c, i){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.data[i]['image'].runtimeType == String
                  ? Image.network(widget.data[i]['image'])
                  : Image.file(widget.data[i]['image']),
              Text('좋아요 ${widget.data[i]['likes']}'),
              Text(widget.data[i]['content']),
              Text(widget.data[i]['user'])
            ]
        );
      });
    } else {
      return Padding(padding: const EdgeInsets.all(8.0),
                     child: CircularProgressIndicator(
                       valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                       backgroundColor: Colors.black,
                     ),
      );
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
  final addMyData;
  final setUserContent;
  final userImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: (){
          addMyData();
        }, icon: Icon(Icons.send))
      ],),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          TextField(onChanged: (text){
            setUserContent(text);
          }),
          IconButton(
              onPressed: (){
                Navigator.pop(context);
                },
              icon: Icon(Icons.close))
        ],
      ),
    );
  }
}

