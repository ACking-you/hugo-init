import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:hugo_init/pages/tip_page.dart';
import 'package:hugo_init/themes.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:hugo_init/data_state.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatefulWidget {
  final String gitUrl;
  final String blogPath;
  const DownloadPage(this.gitUrl, this.blogPath, {super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final _taskMemo = AsyncMemoizer();
  Future<void> startTask() async {
    if (kDebugMode) {
      print('启动task成功');
    }
    final data = context.read<DataState>();
    // 1. Start run hugo new site my_blog
    data.taskStatus = TaskStatus.kStartBlogInit;
    var res = await Process.run('hugo', ['new', 'site', 'my_blog'],
        workingDirectory: widget.blogPath);
    if (res.exitCode != 0) {
      data.errorInfo = "该路径已经存在hugo博客，请勿重复创建！";
      return;
    }
    data.taskStatus = TaskStatus.kFinishBlogInit;
    // 2. Start run git clone
    data.taskStatus = TaskStatus.kStartGit;
    res = await Process.run('git', ['clone', widget.gitUrl],
        workingDirectory: path.join(widget.blogPath, 'my_blog', 'themes'));
    if (res.exitCode != 0) {
      data.errorInfo = res.stderr;
      return;
    }
    data.taskStatus = TaskStatus.kFinishGit;
    // 3. Fnish all
    data.taskStatus = TaskStatus.kFinishAll;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _taskMemo.runOnce(startTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child:
                  getText('一切即将准备就绪', color: kLighterTextColor, fontSize: 45.0),
            ),
            const SizedBox(
              height: 15.0,
            ),
            getText('正在下载并初始化您的 hugo 博客', fontSize: 28.0),
            getText('这可能会耗费几分钟，请不要强制关闭应用程序', fontSize: 18.0),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getText('闲得无聊？'),
                  getLinkedText('给个star(￣▽￣)~*',
                      url: 'https://github.com/ACking-you/AutoHugoSetup')
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: 60.0,
                width: 60.0,
                child: CircularProgressIndicator(
                  color: Colors.white70,
                  strokeWidth: 8.0,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SelectionArea(
              child: Consumer<DataState>(builder: (context, data, child) {
                if (data.errorInfo != null) {
                  return getText('出现错误：${data.errorInfo}');
                }
                if (data.taskStatus == TaskStatus.kStartBlogInit) {
                  return getText('正在初始化hugo博客');
                }
                if (data.taskStatus == TaskStatus.kFinishBlogInit) {
                  return getText('hugo博客初始化完成');
                }
                if (data.taskStatus == TaskStatus.kStartGit) {
                  return getText('正在从git仓库下载主题：${widget.gitUrl}');
                }
                if (data.taskStatus == TaskStatus.kFinishGit) {
                  return getText('主题下载完成');
                }
                if (data.taskStatus == TaskStatus.kFinishAll) {
                  return getText('博客初始化和主题下载已经完成，可以进入下一步了(～￣▽￣)～');
                }
                return getText('后台任务并未启动，重启程序试试?');
              }),
            )
          ],
        ),
      ),
      floatingActionButton: getFloatingButton(context, onNextPressed: () async {
        final data = context.read<DataState>();
        if (data.errorInfo != null) {
          await showMyDialog(context, text: '执行出现错误，请检查环境！');
          return;
        }
        final status = data.taskStatus;
        if (status == TaskStatus.kWait) {
          await showMyDialog(context, text: '后台任务未启动，请重启应用程序');
          return;
        }
        if (status == TaskStatus.kStartBlogInit) {
          await showMyDialog(context, text: '还在初始化博客阶段，别着急呀');
          return;
        }
        if (status == TaskStatus.kStartGit) {
          await showMyDialog(context, text: '目前已经初始化了博客，但是正在下载主题，请耐心等待');
          return;
        }
        if (status == TaskStatus.kFinishAll) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TipPage(
                      path.join(widget.blogPath, 'my_blog'), widget.gitUrl)));
          return;
        }
        await showMyDialog(context, text: '后台任务目前还未完成，进度：${status.toString()}');
      }, onlyLeft: true),
    );
  }
}
