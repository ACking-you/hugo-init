import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hugo_init/pages/download_page.dart';
import 'package:hugo_init/themes.dart';
import 'package:url_launcher/url_launcher_string.dart';

const _defaultThemePath = 'https://gitee.com/acking-you/FeelIt.git';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  final _gitController = TextEditingController();
  final _blogController = TextEditingController();
  String? _blogPath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          getText(
            '主题仓库&博客路径',
            fontSize: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
            child: TextField(
              controller: _gitController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  icon: FilledButton.tonal(
                      onPressed: () async {
                        await launchUrlString('https://themes.gohugo.io/');
                      },
                      child: const Icon(
                        Icons.shop_sharp,
                      )),
                  fillColor: Colors.white,
                  filled: true,
                  // border: null,
                  labelText: '主题仓库',
                  hintText: _defaultThemePath),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
            child: TextField(
              controller: _blogController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                icon: FilledButton.tonal(
                    onPressed: () async {
                      const unnecessaryPrefix = '/Volumes/Macintosh HD';
                      _blogPath = await FilePicker.platform.getDirectoryPath();
                      if (_blogPath == null) return;
                      if (_blogPath!.startsWith(unnecessaryPrefix)) {
                        _blogPath =
                            _blogPath!.substring(unnecessaryPrefix.length);
                      }
                      _blogController.text = _blogPath!;
                    },
                    child: Icon(
                      Icons.sell_rounded,
                    )),
                fillColor: Colors.white,
                filled: true,
                labelText: '博客路径',
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: getFloatingButton(
        context,
        onNextPressed: () async {
          String gitUrl = _gitController.text;
          if (gitUrl.isNotEmpty && !isGitRepositoryUrl(gitUrl)) {
            await showMyDialog(context, text: '无效的git仓库链接！');
            return;
          }
          if (_blogPath == null) {
            await showMyDialog(context, text: '请选择保存到本地的博客路径');
            return;
          }
          String blogPath = _blogPath!;
          gitUrl = gitUrl.isEmpty ? _defaultThemePath : gitUrl;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => DownloadPage(gitUrl, blogPath)));
        },
      ),
    );
  }
}
