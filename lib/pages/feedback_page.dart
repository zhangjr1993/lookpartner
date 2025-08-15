import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String _selectedFeedbackType = '';
  String _feedbackContent = '';
  bool _isSubmitting = false;

  final List<Map<String, String>> _feedbackTypes = [
    {'value': 'bug', 'label': '功能异常'},
    {'value': 'suggestion', 'label': '功能建议'},
    {'value': 'ui', 'label': '界面优化'},
    {'value': 'performance', 'label': '性能问题'},
    {'value': 'other', 'label': '其他问题'},
  ];

  void _submitFeedback() async {
    if (_selectedFeedbackType.isEmpty) {
      _showToast('请选择反馈类型');
      return;
    }

    if (_feedbackContent.trim().isEmpty) {
      _showToast('请输入反馈内容');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // 模拟提交过程
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSubmitting = false;
    });

    _showToast('感谢您的反馈，我们会认真修改');
    
    // 清空表单
    setState(() {
      _selectedFeedbackType = '';
      _feedbackContent = '';
    });
    
    // 延迟退出页面
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '意见反馈',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 反馈类型选择
            const Text(
              '反馈类型',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 单选项
            ..._feedbackTypes.map((type) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: RadioListTile<String>(
                value: type['value']!,
                groupValue: _selectedFeedbackType,
                onChanged: (value) {
                  setState(() {
                    _selectedFeedbackType = value!;
                  });
                },
                title: Text(
                  type['label']!,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16,
                  ),
                ),
                activeColor: AppColors.primaryTextHighlight,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )),
            
            const SizedBox(height: 32),
            
            // 反馈内容
            const Text(
              '反馈内容',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 输入框
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                maxLines: 8,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: '请详细描述您遇到的问题或建议...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  counterText: '',
                ),
                onChanged: (value) {
                  setState(() {
                    _feedbackContent = value;
                  });
                },
              ),
            ),
            
            // 字数统计
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_feedbackContent.length}/500',
                style: TextStyle(
                  color: _feedbackContent.length > 450 
                      ? Colors.orange 
                      : Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTextHighlight,
                  foregroundColor: AppColors.primaryText,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryText),
                        ),
                      )
                    : const Text(
                        '提交反馈',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 提示信息
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '您的反馈对我们很重要，我们会认真处理每一条建议。',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
