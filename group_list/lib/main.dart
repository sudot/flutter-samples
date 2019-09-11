import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 150.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Group List'),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // 此渐变确保工具栏图标与背景图像不同。
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, -0.4),
                          colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AccountListView(),
          ],
        ),
      ),
    );
  }
}

/// 账号列表视图
class AccountListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountListViewState();
  }
}

/// 账号列表视图状态
class _AccountListViewState extends State<AccountListView> {
  /// 账户列表数据
  List<ItemData> _data = [];

  /// 加载数据
  ///
  /// 先将未分组的账户加载,并放在最前面
  /// 然后加载所有的分组,并将分组下的账号加载出来
  Future<List<ItemData>> loadData() async {
    _data.clear();
    for (int i = 0; i < 3; i++) {
      _data.add(AccountData()
        ..name = tempData[Random.secure().nextInt(tempData.length)]);
    }

    for (int i = 0; i < 5; i++) {
      _data.add(GroupData()
        ..name = tempData[Random.secure().nextInt(tempData.length)]);
      for (int i = 0; i < 3; i++) {
        _data.add(AccountData()
          ..name = tempData[Random.secure().nextInt(tempData.length)]);
      }
    }
    return _data;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (_data.length <= index) {
            return null;
          }
          var itemData = _data[index];
          return Dismissible(
            key: ValueKey(index),
            direction: DismissDirection.horizontal,
            child: Column(
              children: <Widget>[
                itemData is GroupData
                    ? ListTile(
                        title: Text(itemData.name,
                            style: TextStyle(color: Colors.teal)))
                    : ListTile(
                        title: ListBody(
                        children: <Widget>[Text(itemData.name)],
                      )),
                Divider(height: 0.0),
              ],
            ),
            background: Container(
              color: themeData.primaryColor,
              child: Row(
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Text(
                      '编辑',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Text(
                      '删除',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            confirmDismiss: (DismissDirection direction) {
              if (DismissDirection.endToStart == direction) {
                return Future.value(true);
              } else {
                return Future.value(false);
              }
            },
            onDismissed: (DismissDirection direction) async {
              var viewData = _data.removeAt(index);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('删除了：$viewData'),
              ));
              await loadData();
            },
          );
        },
      ),
    );
  }
}

abstract class ItemData {
  String name;
}

class GroupData extends ItemData {}

class AccountData extends ItemData {}

const List<String> tempData = [
  '程勇',
  '顾明',
  '谢洋',
  '邱伟',
  '邹敏',
  '杨强',
  '龚超',
  '赵涛',
  '汪娜',
  '丁杰',
  '侯磊',
  '史涛',
  '程秀英',
  '陆艳',
  '丁刚',
  '尹刚',
  '魏丽',
  '潘平',
  '龙伟',
  '董明',
  '贾秀兰',
  '曾霞',
  '侯明',
  '乔丽',
  '陆霞',
  '白静',
  '廖秀英',
  '康洋',
  '侯静',
  '康超',
];
