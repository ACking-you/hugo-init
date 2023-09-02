import 'package:flutter/material.dart';
import 'package:hugo_init/themes.dart';

const tip1 =
    '进入博客根目录，更改 hugo.toml 文件，通过添加 `theme=主题名` 来选择主题，默认下载的是 `FeelIt` 主题，如果选择该主题，则添加 `theme=FeelIt`';
const tip2 =
    '进入博客根目录，运行 `hugo new content posts/new_post.md` 新建 markdown 文件，然后编辑该文件即可';
const tip3 =
    '进入博客根目录，运行 `hugo serve` 可以启动后台服务，然后进入 localhost:1313 即可看到博客，呈现的内容是实时渲染的';
const tip4 = '自定义配置：进入主题官网（一般在仓库中有标明），查看如何自定义配置，打造适合自己的博客形态';

class TipPage extends StatelessWidget {
  final String _blogPath;
  final String _themeUrl;
  const TipPage(this._blogPath, this._themeUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 38.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: getText('恭喜！本地博客搭建完成（￣︶￣）↗',
                // color: kLighterTextColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
          SelectionArea(child: getText('博客路径：$_blogPath', fontSize: 22.0)),
          SelectionArea(child: getText('主题仓库：$_themeUrl', fontSize: 22.0)),
          const SizedBox(
            height: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getToolTipButton(
                    getText('选择主题', color: Colors.black, fontSize: 18.0), 200.0,
                    call: () async {
                  await showMyDialog(context,
                      widget: SelectionArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getText(
                            tip1,
                            color: Colors.black,
                          ),
                        ),
                      ));
                }, tooltip: tip1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getToolTipButton(
                    getText(
                      '新建文章',
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    200.0, call: () async {
                  await showMyDialog(context,
                      widget: SelectionArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getText(
                            tip2,
                            color: Colors.black,
                          ),
                        ),
                      ));
                }, tooltip: tip2),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getToolTipButton(
                    getText('启动博客服务', color: Colors.black, fontSize: 18.0),
                    200.0, call: () async {
                  await showMyDialog(context,
                      widget: SelectionArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getText(
                            tip3,
                            color: Colors.black,
                          ),
                        ),
                      ));
                }, tooltip: tip3),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getToolTipButton(
                    getText('自定义', color: Colors.black, fontSize: 18.0), 200.0,
                    call: () async {
                  await showMyDialog(context,
                      widget: SelectionArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getText(
                            '$tip4。比如默认使用的 FeelIt 主题配置文档：https://feelit.khusika.dev/zh-cn/theme-documentation-basics/',
                            color: Colors.black,
                          ),
                        ),
                      ));
                }, tooltip: tip4),
              ),
            ],
          )
        ]),
      ),
      floatingActionButton: getFloatingButton(context, onNextPressed: () async {
        await showMyDialog(context,
            widget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: getText('已经没有下一步了喔，你已经在本地部署好博客了哦ψ(｀∇´)ψ',
                  color: Colors.black),
            ));
      }),
    );
  }
}
