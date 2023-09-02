import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hugo_init/data_state.dart';
import 'package:hugo_init/pages/guide_page.dart';
import 'package:hugo_init/themes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (ctx) => DataState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hugo Init'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '嗨！你好啊！',
              style: TextStyle(fontSize: 50.0, color: kTextColor),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              '欢迎使用 Hugo 博客一键搭建工具',
              style: TextStyle(fontSize: 25.0, color: kTextColor),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'By L_B__ From ',
                  style: TextStyle(fontSize: 15.0, color: kTextColor),
                ),
                RichText(
                    text: TextSpan(
                  text: "acking-you.github.io",
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrlString('https://acking-you.github.io');
                    },
                )),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '不知道怎么使用？',
                  style: TextStyle(fontSize: 15.0, color: kTextColor),
                ),
                getLinkedText("视频教程",
                    url: "https://www.bilibili.com/video/BV11S4y1G7SW/")
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GuidePage()));
        },
        tooltip: '下一步',
        backgroundColor: kButtonColor,
        child: const Icon(
          Icons.navigate_next,
          color: Colors.white,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
