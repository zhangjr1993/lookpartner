import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../services/in_app_purchase_service.dart';
import '../services/current_user_service.dart';
import '../services/diamond_service.dart';

class VipMembershipPage extends StatefulWidget {
  const VipMembershipPage({super.key});

  @override
  State<VipMembershipPage> createState() => _VipMembershipPageState();
}

class _VipMembershipPageState extends State<VipMembershipPage> {
  final InAppPurchaseService _purchaseService = InAppPurchaseService();
  bool _isLoading = true;
  Map<String, bool> _purchaseInProgress = {};

  // 本地写死的档位数据
  final List<Map<String, dynamic>> _products = [
    {
      'name': '月会员',
      'id': 'com.core2025.jm.f',
      'price': '98',
      'type': 'subscription',
    },
    {
      'name': '首充月会员',
      'id': 'com.core2025.jm.sf',
      'price': '88',
      'type': 'subscription',
    },
    {
      'name': '年会员',
      'id': 'com.core2025.jm.y',
      'price': '268',
      'type': 'subscription',
    },
    {
      'name': '60钻石',
      'id': 'com.core2025.jm.6',
      'price': '6',
      'type': 'consumable',
    },
    {
      'name': '300钻石',
      'id': 'com.core2025.jm.28',
      'price': '28',
      'type': 'consumable',
    },
    {
      'name': '1130钻石',
      'id': 'com.core2025.jm.98',
      'price': '98',
      'type': 'consumable',
    },
    {
      'name': '2350钻石',
      'id': 'com.core2025.jm.198',
      'price': '198',
      'type': 'consumable',
    },
    {
      'name': '30700钻石',
      'id': 'com.core2025.jm.268',
      'price': '268',
      'type': 'consumable',
    },
    {
      'name': '3600钻石',
      'id': 'com.core2025.jm.298',
      'price': '298',
      'type': 'consumable',
    },
  ];

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
      body: Stack(
        children: [
          // 背景图片从屏幕顶部开始，左右贴合屏幕
          Positioned.fill(
            child: Image.asset(
              'assets/images/memberAssets/bg_vip.webp',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stack) {
                return Container(
                  color: const Color(0xFFFFF8DC),
                );
              },
            ),
          ),
          
          // 固定内容区域
          Column(
            children: [
              // 返回按钮固定在顶部
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildBackButton(),
                ),
              ),
              
              // VIP特权展示固定在返回按钮下方
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildVipBenefits(),
              ),
              
              const SizedBox(height: 20),
              
              // 可滚动的套餐内容
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildProductList(),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF443F23),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildVipBenefits() {
    return Column(
      children: [
        // 无限报名
        _buildBenefitItem(
          'assets/images/memberAssets/icon_me_vip_3.webp',
          '无限报名',
          '无限报名权限可以让你得到更多人的关注',
        ),
        const SizedBox(height: 28),
        
        // 无限畅聊
        _buildBenefitItem(
          'assets/images/memberAssets/icon_me_vip_2.webp',
          '无限畅聊',
          '可以对感兴趣的活动直接发起私聊',
        ),
        const SizedBox(height: 28),
        
        // 双倍曝光
        _buildBenefitItem(
          'assets/images/memberAssets/icon_me_vip_1.webp',
          '双倍曝光',
          '让更多的人看到你的信息，机会双倍提升',
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String iconPath, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513),
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                iconPath,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stack) {
                  return const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 24,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // 文字内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF443F23),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF443F23),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择套餐',
          style: TextStyle(
            color: Color(0xFF443F23),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // 会员套餐
        _buildProductSection('会员套餐', _products.where((p) => p['type'] == 'subscription').toList()),
        const SizedBox(height: 20),
        
        // 钻石套餐
        _buildProductSection('钻石套餐', _products.where((p) => p['type'] == 'consumable').toList()),
      ],
    );
  }

  Widget _buildProductSection(String title, List<Map<String, dynamic>> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF443F23),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        ...products.map((product) => _buildProductCard(product)).toList(),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final String productId = product['id'];
    final bool isPurchasing = _purchaseInProgress[productId] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFCEF600),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 产品信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    color: Color(0xFF443F23),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '¥${product['price']}',
                  style: const TextStyle(
                    color: Color(0xFFCEF600),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // 购买按钮
          SizedBox(
            width: 80,
            height: 36,
            child: ElevatedButton(
              onPressed: isPurchasing ? null : () => _purchaseProduct(productId),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCEF600),
                foregroundColor: const Color(0xFF443F23),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: isPurchasing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF443F23)),
                      ),
                    )
                  : const Text(
                      '购买',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _purchaseProduct(String productId) async {
    setState(() {
      _purchaseInProgress[productId] = true;
    });

    try {
      bool success = await _purchaseService.purchaseProduct(productId);
      
      if (success) {
        // 等待一段时间让购买处理完成
        await Future.delayed(const Duration(seconds: 2));
        
        // 检查购买是否成功
        bool purchaseSuccess = await _checkPurchaseSuccess(productId);
        
        if (purchaseSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('购买成功！'),
              backgroundColor: Color(0xFFCEF600),
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          // 返回上一页，让我的页面刷新
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('购买请求已发送，请完成支付'),
              backgroundColor: Color(0xFFCEF600),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
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
        _purchaseInProgress[productId] = false;
      });
    }
  }



  // 检查购买是否成功
  Future<bool> _checkPurchaseSuccess(String productId) async {
    try {
      // 检查是否为VIP产品
      if (_isVipProduct(productId)) {
        // 检查VIP状态是否已激活
        return await CurrentUserService.isVipValid();
      } else {
        // 检查钻石余额是否已增加
        final currentBalance = await DiamondService.getDiamondBalance();
        // 这里可以根据产品ID检查具体的钻石数量
        // 为了简化，我们假设如果余额大于200（初始值），说明购买成功
        return currentBalance > 200;
      }
    } catch (e) {
      print('检查购买状态失败: $e');
      return false;
    }
  }

  // 判断是否为VIP产品
  bool _isVipProduct(String productId) {
    return productId == 'com.core2025.jm.f' || 
           productId == 'com.core2025.jm.sf' || 
           productId == 'com.core2025.jm.y';
  }
}
