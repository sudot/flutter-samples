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
  List<GroupData> _data = [];

  /// 加载数据
  ///
  /// 先将未分组的账户加载,并放在最前面
  /// 然后加载所有的分组,并将分组下的账号加载出来
  List<ItemData> loadData() {
    _data.clear();
    List<AccountData> accountDataList = [];
    var random = Random.secure();
    for (int i = 0; i < 3; i++) {
      accountDataList
          .add(AccountData(tempData[random.nextInt(tempData.length)]));
    }
    _data.add(GroupData(null, accountDataList)..isExpanded = false);

    for (int i = 0; i < 5; i++) {
      List<AccountData> accountDataList = [];
      for (int i = 0; i < 3; i++) {
        accountDataList
            .add(AccountData(tempData[random.nextInt(tempData.length)]));
      }
      _data.add(GroupData('分组$i', accountDataList)..isExpanded = false);
    }
    return _data;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget _buildItem(List<ItemData> items, int index) {
    ItemData item = items[index];
    if (item.name == null || item.name.isEmpty) {
      return null;
    }
    if (item is GroupData) {
      return ListTile(
        leading: Icon(Icons.folder_open),
        title: Text(item.name ?? ''),
      );
    } else {
      return ListTile(
        leading: Icon(Icons.account_balance_wallet),
        title: Text(item.name),
      );
    }
  }

  Widget _addDismissible(Widget child, List<ItemData> items, int index) {
    return Dismissible(
      key: ValueKey(child),
      direction: DismissDirection.horizontal,
      child: child,
      background: Container(
        alignment: AlignmentDirectional.centerStart,
        color: Colors.grey,
        padding: EdgeInsets.only(left: 24.0),
        child: Text(
          '编辑',
          style: TextStyle(color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.only(right: 24.0),
        color: Colors.red,
        child: Text(
          '删除',
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.white),
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
        var viewData = items.removeAt(index);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('删除了：$viewData'),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (_data.length <= index) {
          return null;
        }
        List<Widget> children = [];
        var item = _buildItem(_data, index);
        if (item != null) {
          children.add(_addDismissible(item, _data, index));
        }
        List<AccountData> accounts = _data[index].accountDataList;
        for (int i = 0; i < accounts.length; i++) {
          item = _buildItem(accounts, i);
          if (item != null) {
            children.add(_addDismissible(item, accounts, i));
          }
        }
        return Card(child: Column(children: children));
      }),
    );
  }
}

abstract class ItemData {
  ItemData(this.name);

  String name;
}

class GroupData extends ItemData {
  GroupData(String name, this.accountDataList) : super(name);

  bool isExpanded = false;
  List<AccountData> accountDataList;
}

class AccountData extends ItemData {
  AccountData(String name) : super(name);
}

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
