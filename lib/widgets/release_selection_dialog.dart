import 'package:flutter/material.dart';
import '../pages/release_page.dart';

class ReleaseSelectionDialog extends StatelessWidget {
  const ReleaseSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5), // 黑色全屏半透明背景
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white, // 白色容器
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), // 左上圆角16
                topRight: Radius.circular(16), // 右上圆角16
              ),
            ),
            child: Column(
              children: [
                // 选择按钮区域
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Row(
                    children: [
                      // 左侧按钮 - 寻找搭子
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ReleasePage(releaseType: ReleaseType.buddy),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/pubAssets/btn_release_friends.webp',
                                  width: 60,
                                  height: 60,
                                  errorBuilder: (context, error, stack) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.people,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  '寻找搭子', // 按钮title=寻找搭子
                                  style: TextStyle(
                                    color: Color(0xFF171717), // 色号#171717
                                    fontSize: 22, // 字号22
                                    fontWeight: FontWeight.bold, // 粗体
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '即时有伴', // 左侧按钮描述=即时有伴
                                  style: TextStyle(
                                    color: const Color(0xFF171717).withValues(alpha: 0.4), // 色号#171717不透明度0.4
                                    fontSize: 16, // 字号16
                                    fontWeight: FontWeight.w600, // 中粗
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // 右侧按钮 - 发布活动
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ReleasePage(releaseType: ReleaseType.activity),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/pubAssets/btn_release_activity.webp',
                                  width: 60,
                                  height: 60,
                                  errorBuilder: (context, error, stack) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.event,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  '发布活动', // 按钮title=发布活动
                                  style: TextStyle(
                                    color: Color(0xFF171717), // 色号#171717
                                    fontSize: 22, // 字号22
                                    fontWeight: FontWeight.bold, // 粗体
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '多人成行', // 右侧按钮描述=多人成行
                                  style: TextStyle(
                                    color: const Color(0xFF171717).withValues(alpha: 0.4), // 色号#171717不透明度0.4
                                    fontSize: 16, // 字号16
                                    fontWeight: FontWeight.w600, // 中粗
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 关闭按钮 - 居中展示，宽高45x45
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context), // 点击关闭按钮：关闭弹窗
                      child: Container(
                        width: 45, // 宽高45x45
                        height: 45,
                        child: Image.asset(
                          'assets/images/pubAssets/btn_tab_release_close.webp',
                          width: 45,
                          height: 45,
                          errorBuilder: (context, error, stack) {
                            return Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
