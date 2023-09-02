import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugo_init/data_state.dart';
import 'package:hugo_init/pages/theme_page.dart';
import 'package:hugo_init/themes.dart';
import 'package:process_run/process_run.dart';
import 'package:provider/provider.dart';

bool checkGitInstalled() {
  return whichSync('git') != null;
}

bool checkHugoInstalled() {
  return whichSync('hugo') != null;
}

const _hugoGuideUrl = 'https://gohugo.io/installation/';
const _gitGuideUrl = 'https://git-scm.com/downloads';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

Widget getCheckButton(bool? isInstalled,
    {required String data,
    required VoidCallback? callback,
    required String installTip,
    required String installUrl,
    double? buttonWidth}) {
  Widget button = ElevatedButton(
    style: ButtonStyle(
        fixedSize: buttonWidth == null
            ? null
            : MaterialStateProperty.all(Size.fromWidth(buttonWidth))),
    onPressed: callback,
    child: Text(
      data,
    ),
  );
  if (isInstalled == null) {
    return button;
  }
  return LayoutBuilder(
      builder: ((context, constraints) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: constraints.maxWidth / 2 - 100,
              ),
              button,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isInstalled
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 22,
                      )
                    : const Icon(
                        Icons.warning,
                        color: Colors.red,
                        size: 22,
                      ),
              ),
              if (!isInstalled) getLinkedText(installTip, url: installUrl)
            ],
          )));
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: getText('环境检查', fontSize: 40.0),
          ),
          Consumer<DataState>(
            builder: (ctx, data, child) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: getCheckButton(data.checkGit, data: 'check git',
                  callback: () {
                data.checkGit = checkGitInstalled();
              },
                  installTip: '安装',
                  installUrl: _gitGuideUrl,
                  buttonWidth: 200.0),
            ),
          ),
          Consumer<DataState>(
            builder: (ctx, data, child) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: getCheckButton(data.checkHugo, data: 'check hugo',
                  callback: () {
                data.checkHugo = checkHugoInstalled();
              },
                  installTip: '安装',
                  installUrl: _hugoGuideUrl,
                  buttonWidth: 200.0),
            ),
          )
        ])),
        floatingActionButton:
            getFloatingButton(context, onNextPressed: () async {
          final state = context.read<DataState>();
          if (state.checkGit == null) {
            await showMyDialog(context, text: '请检查 git 环境');
            return;
          }
          if (state.checkHugo == null) {
            await showMyDialog(context, text: '请检查 hugo 环境');
            return;
          }
          if (!state.checkGit!) {
            await showMyDialog(context, text: 'git 环境缺失');
            return;
          }
          if (!state.checkGit!) {
            await showMyDialog(context, text: 'hugo 环境缺失');
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return const ThemePage();
          }));
        }));
  }
}
