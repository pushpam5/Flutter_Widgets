import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _typeAheadController = TextEditingController();
  static List<UserDetail> _det = [];

  Future<List<UserDetail>> _getUsers() async {
    String url = 'https://jsonplaceholder.typicode.com/photos';
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    List<UserDetail> users = [];
    for (var u in jsonData) {
      UserDetail user = UserDetail(
          id: u['id'], title: u['title'], url: u['thumbnailUrl']);
      users.add(user);
    }
    print(users.length);
    _det = users;
    return users;
  }

  static List<UserDetail> getSuggestions(String query) {
    List<UserDetail> matches = [];
    matches.addAll(_det);
    matches.retainWhere((UserDetail s) => s.title.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }




  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder(
          future: _getUsers() ,
          builder:(BuildContext context,
              AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("No Data"),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(labelText: 'State'),
                        controller: this._typeAheadController,
                      ),
                      suggestionsCallback: (pattern) async {
                        return await getSuggestions(pattern);
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      itemBuilder: (context, UserDetail suggestion) {
                        return Padding(padding: EdgeInsets.all(10.0),
                          child: Card(

                            elevation: 10,
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.fromLTRB(
                                    3, 5, 10, 2),

                                    child: ClipRRect(
                                      borderRadius: BorderRadius
                                          .circular(30.0),
                                      child: Image(image: NetworkImage(
                                          suggestion.url, scale: 3),),
                                    )
//
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      suggestion.title, style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'BenchNine',
                                        fontSize: 15),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      50.0, 10, 10, 10),
                                  child: Text(suggestion.id.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'BenchNine',
                                          fontSize: 15)),
                                )
                              ],
                            ),
                          ),);
                      },
                      onSuggestionSelected: (suggestion) {
                        this._typeAheadController.text = suggestion;
                      }),
                ),
              );
            }
          }),
      ),
    );
  }
}

class StateService {
  static final List<String> states = [
    'ANDAMAN AND NICOBAR ISLANDS', 'ANDHRA PRADESH', 'ARUNACHAL PRADESH', 'ASSAM', 'BIHAR', 'CHATTISGARH', 'CHANDIGARH', 'DAMAN AND DIU', 'DELHI',
    'DADRA AND NAGAR HAVELI', 'GOA', 'GUJARAT', 'HIMACHAL PRADESH', 'HARYANA', 'JAMMU AND KASHMIR', 'JHARKHAND', 'KERALA', 'KARNATAKA', 'LAKSHADWEEP',
    'MEGHALAYA', 'MAHARASHTRA', 'MANIPUR', 'MADHYA PRADESH', 'MIZORAM', 'NAGALAND', 'ORISSA', 'PUNJAB', 'PONDICHERRY', 'RAJASTHAN', 'SIKKIM',
    'TAMIL NADU', 'TRIPURA', 'UTTARAKHAND', 'UTTAR PRADESH', 'WEST BENGAL', 'TELANGANA' , 'LADAKH'
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(states);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class UserDetail {
  final int id;
  final String title;
  final String url;

  UserDetail({this.id, this.title, this.url});
}


