import 'package:flutter/material.dart';
import '../widgets/release_selection_dialog.dart';

// 这是一个示例，展示如何在tabbar中添加发布按钮
class TabbarReleaseButtonExample extends StatelessWidget {
  const TabbarReleaseButtonExample({super.key});

  void _showReleaseSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ReleaseSelectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('主页面内容'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '发布',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            // 点击发布按钮
            _showReleaseSelectionDialog(context);
          }
        },
      ),
    );
  }
}

// 或者，如果你想要一个更简单的tabbar示例
class SimpleTabbarExample extends StatelessWidget {
  const SimpleTabbarExample({super.key});

  void _showReleaseSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ReleaseSelectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('主页面内容'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '发布',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            // 点击发布按钮
            _showReleaseSelectionDialog(context);
          }
        },
      ),
    );
  }
}
