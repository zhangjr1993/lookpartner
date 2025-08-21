import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../services/in_app_purchase_service.dart';
import '../constants/app_colors.dart';

class VipPurchasePage extends StatefulWidget {
  const VipPurchasePage({super.key});

  @override
  State<VipPurchasePage> createState() => _VipPurchasePageState();
}

class _VipPurchasePageState extends State<VipPurchasePage> {
  final InAppPurchaseService _purchaseService = InAppPurchaseService();
  bool _isLoading = true;
  bool _purchaseInProgress = false;

  @override
  void initState() {
    super.initState();
    _initializePurchase();
  }

  Future<void> _initializePurchase() async {
    await _purchaseService.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF171717)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'VIP会员',
          style: TextStyle(
            color: Color(0xFF171717),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VIP会员介绍
          _buildVipIntroduction(),
          const SizedBox(height: 30),
          
          // 会员特权
          _buildVipBenefits(),
          const SizedBox(height: 30),
          
          // 购买选项
          _buildPurchaseOptions(),
          const SizedBox(height: 30),
          
          // 恢复购买按钮
          _buildRestoreButton(),
        ],
      ),
    );
  }

  Widget _buildVipIntroduction() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.verified,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'VIP会员',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '解锁更多特权，享受专属服务',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '会员特权',
          style: TextStyle(
            color: Color(0xFF171717),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildBenefitItem(Icons.star, '专属活动优先参与'),
        _buildBenefitItem(Icons.message, '无限聊天消息'),
        _buildBenefitItem(Icons.visibility, '查看完整用户资料'),
        _buildBenefitItem(Icons.favorite, '无限喜欢功能'),
        _buildBenefitItem(Icons.notifications, '优先推送通知'),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFCEF600),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF171717),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseOptions() {
    final vipProducts = _purchaseService.vipProducts;
    
    if (vipProducts.isEmpty) {
      return const Center(
        child: Text(
          '暂无可用产品',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 16,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择套餐',
          style: TextStyle(
            color: Color(0xFF171717),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPurchaseCard(vipProducts.first),
      ],
    );
  }

  Widget _buildPurchaseCard(ProductDetails product) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            product.title,
            style: const TextStyle(
              color: Color(0xFF171717),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            product.price,
            style: const TextStyle(
              color: Color(0xFFCEF600),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _purchaseInProgress ? null : () => _purchaseVip(product.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCEF600),
                foregroundColor: const Color(0xFF171717),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _purchaseInProgress
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF171717)),
                      ),
                    )
                  : const Text(
                      '立即购买',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestoreButton() {
    return Center(
      child: TextButton(
        onPressed: _restorePurchases,
        child: const Text(
          '恢复购买',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> _purchaseVip(String productId) async {
    setState(() {
      _purchaseInProgress = true;
    });

    try {
      bool success = await _purchaseService.purchaseProduct(productId);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('购买请求已发送，请完成支付'),
            backgroundColor: Color(0xFFCEF600),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('购买失败，请重试'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('购买出错: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _purchaseInProgress = false;
      });
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await _purchaseService.restorePurchases();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('恢复购买请求已发送'),
          backgroundColor: Color(0xFFCEF600),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('恢复购买失败: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
