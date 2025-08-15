import 'package:flutter/material.dart';

class ImagePickerDialog extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onCancelTap;
  
  const ImagePickerDialog({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 相机选项
                  ListTile(
                    leading: const Icon(Icons.camera_alt, color: Color(0xFF171717)),
                    title: const Text(
                      '相机',
                      style: TextStyle(
                        color: Color(0xFF171717),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: onCameraTap,
                  ),
                  
                  // 相册选项
                  ListTile(
                    leading: const Icon(Icons.photo_library, color: Color(0xFF171717)),
                    title: const Text(
                      '相册',
                      style: TextStyle(
                        color: Color(0xFF171717),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: onGalleryTap,
                  ),
                  
                  // 分割线
                  const Divider(height: 1),
                  
                  // 取消选项
                  ListTile(
                    leading: const Icon(Icons.close, color: Color(0xFF171717)),
                    title: const Text(
                      '取消',
                      style: TextStyle(
                        color: Color(0xFF171717),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: onCancelTap,
                  ),
                  
                  // 底部安全区域
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
