import 'package:flutter/material.dart';
import '../widgets/release_selection_dialog.dart';
import '../pages/release_page.dart';

// 这是一个使用示例，展示如何在主页面中集成发布选择弹窗
class ReleaseDialogUsageExample extends StatelessWidget {
  const ReleaseDialogUsageExample({super.key});

  void _showReleaseSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ReleaseSelectionDialog(),
    );
  }

  static void _navigateToBuddyRelease() {
    // 这里应该导航到发布搭子页面
    // 由于这是一个示例文件，我们使用一个占位符
    print('导航到发布搭子页面');
  }

  static void _navigateToActivityRelease() {
    // 这里应该导航到发布活动页面
    // 由于这是一个示例文件，我们使用一个占位符
    print('导航到发布活动页面');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布选择弹窗示例'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showReleaseSelectionDialog(context),
          child: const Text('显示发布选择弹窗'),
        ),
      ),
    );
  }
}

// 实际使用时的导航方法示例
class ReleaseNavigationHelper {
  static void navigateToBuddyRelease(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReleasePage(releaseType: ReleaseType.buddy),
      ),
    );
  }

  static void navigateToActivityRelease(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReleasePage(releaseType: ReleaseType.activity),
      ),
    );
  }
}
