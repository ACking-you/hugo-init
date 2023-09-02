import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const kBackgroundColor = Color.fromRGBO(23, 34, 41, 1);
const kTextColor = Color.fromRGBO(171, 196, 216, 1);
const kButtonColor = Color.fromRGBO(50, 129, 184, 1);
const kLighterTextColor = Color.fromRGBO(206, 223, 229, 0.88);
Widget getFloatingButton(
  BuildContext context, {
  required VoidCallback? onNextPressed,
  bool onlyLeft = false,
}) {
  if (onlyLeft) {
    return FloatingActionButton(
      heroTag: 'right',
      tooltip: '下一步',
      backgroundColor: kButtonColor,
      onPressed: onNextPressed,
      child: const Icon(
        Icons.navigate_next,
        color: Colors.white,
      ),
    );
  }
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Padding(
      padding: const EdgeInsets.only(left: 35.0),
      child: FloatingActionButton(
          heroTag: 'left',
          tooltip: '上一步',
          backgroundColor: kButtonColor,
          child: const Icon(
            Icons.navigate_before,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
    ),
    FloatingActionButton(
      heroTag: 'right',
      tooltip: '下一步',
      backgroundColor: kButtonColor,
      onPressed: onNextPressed,
      child: const Icon(
        Icons.navigate_next,
        color: Colors.white,
      ),
    )
  ]);
}

Text getText(String data,
    {Color color = kTextColor,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign}) {
  return Text(
    data,
    style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    textAlign: textAlign,
  );
}

RichText getLinkedText(String data, {required String url}) {
  return RichText(
      text: TextSpan(
    text: data,
    style: const TextStyle(color: Colors.blue),
    recognizer: TapGestureRecognizer()
      ..onTap = () {
        launchUrlString(url);
      },
  ));
}

Future<String?> showMyDialog(BuildContext context,
    {String? text, Widget? widget}) async {
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (text != null) Text(text),
            if (widget != null) widget,
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    ),
  );
}

bool isGitRepositoryUrl(String url) {
  final gitRepoRegex = RegExp(
    r'^(?:https?|git|ssh)://' // 支持http、https、git和ssh协议
    r'(?:[A-Za-z0-9.-]+)(?::\d+)?' // 主机名，支持可选的端口号
    r'/(?:[A-Za-z0-9._-]+/)+[A-Za-z0-9._-]+\.git$', // 仓库路径（用户名和仓库名）以及.git扩展名
  );

  return gitRepoRegex.hasMatch(url);
}

Widget getToolTipButton(Widget? child, double width,
    {required VoidCallback? call, String? tooltip}) {
  return SizedBox(
    width: width,
    child: FloatingActionButton(
      tooltip: tooltip,
      onPressed: call,
      child: child,
    ),
  );
}
