// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, await_only_futures, camel_case_types, must_be_immutable

import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';

void main() {
  runApp(const MyApp());
}

//https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/get_all_Sale_all_2
//https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/user_VPoint
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: tes(
          url:
              'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/user_VPoint'),
    );
  }
}

class tes extends StatefulWidget {
  tes({super.key, required this.url});
  String? url;
  @override
  State<tes> createState() => _tesState();
}

class _tesState extends State<tes> {
  List list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _body(context));
  }

  Widget _center(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return KFA_Dialog(
                  url:
                      'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/user_VPoint',
                  list_back: (value) {
                    setState(() {
                      list = value;
                      print('List back = $list');
                    });
                  },
                  call_post_api: true,
                  body: const {
                    2: 'helium',
                    10: 'neon',
                    18: 'argon',
                  },
                  // call_get_api: true,
                  // check: true,
                  details: "",
                );
              });
        },
        child: Text("kokoko"),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [_center(context), Text('List = ${list}')],
      ),
    );
  }
}

typedef OnChangeCallback = void Function(dynamic value);

class KFA_Dialog extends StatefulWidget {
  KFA_Dialog(
      {super.key,
      this.body,
      this.call_get_api,
      this.call_post_api,
      this.details,
      this.seconds,
      this.check,
      this.url,
      this.list_back});
  final bool? call_get_api;
  final bool? call_post_api;
  final String? details;
  final String? url;
  final Double? seconds;
  final bool? check;
  final Map? body;
  OnChangeCallback? list_back;
  @override
  State<KFA_Dialog> createState() => _KFA_DilogState();
}

class _KFA_DilogState extends State<KFA_Dialog> with TickerProviderStateMixin {
  bool showalert = false;
  late final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, -0.6),
    end: const Offset(0.0, -0.5),
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.bounceOut,
  ));
  late CountdownTimerController _controller;
  int endTime = DateTime.now().millisecondsSinceEpoch +
      const Duration(minutes: 1, seconds: 30).inMilliseconds;
  @override
  void initState() {
    super.initState();
    if (widget.check == null) {
      setState(() {
        endTime = DateTime.now().millisecondsSinceEpoch +
            const Duration(seconds: 7).inMilliseconds;
      });
    }
    if (widget.call_get_api != null) {
      get(widget.url);
    }
    if (widget.call_get_api == null) {
      post(widget.url, widget.body!);
    }
    _controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  bool b = false;
  void onEnd() {
    setState(() {
      print('onEnd');
      b = true;
      controller.dispose();
      showalert = true;
      Navigator.pop(context);
      if (_controller.isRunning) {
        _controller.disposeTimer();
      } else {
        _controller.start();
      }
      //Await list back
      if (b == true) {
        widget.list_back!(list);
        print('Value');
      } else {
        print('No');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 25,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.only(top: 10, left: 30, right: 30),
        shape: BeveledRectangleBorder(
          side: const BorderSide(
            color: Color.fromARGB(0, 158, 158, 158),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        insetAnimationDuration: const Duration(seconds: 10),
        insetAnimationCurve: Curves.easeInOutCubic,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            if (widget.call_get_api != null)
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                margin: const EdgeInsets.only(
                    top: 60, left: 20, right: 20, bottom: 80),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.details ?? "Get from datastore",
                      overflow: TextOverflow.visible,
                    ),
                    Image.asset("assets/get_api.gif")
                  ],
                ),
              ),
            if (widget.call_post_api != null)
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                margin: const EdgeInsets.only(
                    top: 60, left: 20, right: 20, bottom: 80),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.details ?? "Post to datastore",
                      overflow: TextOverflow.visible,
                    ),
                    Image.asset("assets/post_api.gif")
                  ],
                ),
              ),
            SlideTransition(
              position: _offsetAnimation,
              child: Container(
                // margin: const EdgeInsets.only(bottom: 30),
                height: 90,
                width: 90,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 36, 47, 255),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey)],
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      scale: 0.5,
                      image: AssetImage("assets/KFA_CRM.png")),
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                // color: Colors.white,
                child: Column(
                  children: [
                    if (showalert == false)
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/loading.gif",
                                scale: 2,
                                // color: Colors.grey,
                                colorBlendMode: BlendMode.src),
                            const SizedBox(width: 10),
                            CountdownTimer(
                              controller: _controller,
                              onEnd: onEnd,
                              widgetBuilder: (_, CurrentRemainingTime? time) {
                                if (time == null) {
                                  return Text('Time over');
                                }
                                return Text(
                                    '${(time.min != null) ? time.min.toString() + "min" : ""} ${(time.sec != null) ? time.sec.toString() + "sec" : ""} ');
                              },
                            ),
                            const SizedBox(width: 10),
                            Image.asset("assets/loading.gif",
                                scale: 2,
                                // color: Colors.grey,
                                colorBlendMode: BlendMode.src)
                          ],
                        ),
                      ),
                    if (widget.check != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                controller.dispose();
                                _controller.disposeTimer();
                                Navigator.pop(context);
                                // if (_controller.isRunning) {
                                //   _controller.disposeTimer();
                                // } else {
                                //   _controller.start();
                                // }
                              },
                              child: const Text("Yes")),
                          TextButton(
                              onPressed: () {
                                controller.dispose();
                                _controller.disposeTimer();
                                Navigator.pop(context);
                              },
                              child: const Text("No"))
                        ],
                      ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text(
            'A dialog is a type of modal window that\n'
            'appears in front of app content to\n'
            'provide critical information, or prompt\n'
            'for a decision to be made.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List list = [];
  Future<void> get(url) async {
    var rs = await http.get(
      Uri.parse('$url'),
    );
    if (rs.statusCode == 200) {
      setState(() {
        var jsonData = jsonDecode(rs.body);
        list = jsonData;
        print('Get Ready');
      });
    }
  }

  void post(_url, Map body) async {
    Map<String, dynamic> payload = {
      'id_ptys': '',
    };
    final url = await Uri.parse('');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print('Success value Sale');
    } else {
      print('value_property: ${response.reasonPhrase}');
    }
  }
}
