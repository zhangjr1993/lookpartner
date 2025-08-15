import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'current_user_service.dart';
import 'diamond_service.dart';

class InAppPurchaseService {
  // 会员产品ID
  static const String _monthlyVipId = 'com.core2025.jm.f';
  static const String _firstChargeVipId = 'com.core2025.jm.sf';
  static const String _yearlyVipId = 'com.core2025.jm.y';
  
  // 钻石产品ID
  static const String _diamond6Id = 'com.core2025.jm.6';
  static const String _diamond28Id = 'com.core2025.jm.28';
  static const String _diamond98Id = 'com.core2025.jm.98';
  static const String _diamond198Id = 'com.core2025.jm.198';
  static const String _diamond268Id = 'com.core2025.jm.268';
  static const String _diamond298Id = 'com.core2025.jm.298';
  
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;

  // 单例模式
  static final InAppPurchaseService _instance = InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  // 初始化应用内购买
  Future<void> initialize() async {
    try {
      // 检查应用内购买是否可用
      _isAvailable = await _inAppPurchase.isAvailable();
      
      if (!_isAvailable) {
        print('应用内购买不可用');
        return;
      }

      // 设置购买更新监听器
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription.cancel(),
        onError: (error) => print('购买流错误: $error'),
      );

      // 加载产品信息
      await loadProducts();
      
      print('应用内购买初始化成功');
    } catch (e) {
      print('应用内购买初始化失败: $e');
    }
  }

  // 加载产品信息
  Future<void> loadProducts() async {
    try {
      final Set<String> productIds = {
        _monthlyVipId,
        _firstChargeVipId,
        _yearlyVipId,
        _diamond6Id,
        _diamond28Id,
        _diamond98Id,
        _diamond198Id,
        _diamond268Id,
        _diamond298Id,
      };

      final ProductDetailsResponse response = 
          await _inAppPurchase.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        print('未找到的产品ID: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      print('加载到 ${_products.length} 个产品');
      
      for (var product in _products) {
        print('产品: ${product.id} - ${product.title} - ${product.price}');
      }
    } catch (e) {
      print('加载产品信息失败: $e');
    }
  }

  // 购买产品
  Future<bool> purchaseProduct(String productId) async {
    try {
      if (!_isAvailable) {
        print('应用内购买不可用');
        return false;
      }

      final ProductDetails? product = _products
          .where((element) => element.id == productId)
          .firstOrNull;

      if (product == null) {
        print('产品不存在: $productId');
        return false;
      }

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      bool success = false;
      
      // 判断产品类型
      if (_isVipProduct(product.id)) {
        // 购买VIP会员（非消耗性商品）
        success = await _inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      } else {
        // 购买钻石（消耗性商品）
        success = await _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
        );
      }

      if (success) {
        _purchasePending = true;
        print('购买请求已发送');
      } else {
        print('购买请求失败');
      }

      return success;
    } catch (e) {
      print('购买产品失败: $e');
      return false;
    }
  }

  // 处理购买更新
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  // 处理单个购买
  void _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      print('购买待处理: ${purchaseDetails.productID}');
    } else if (purchaseDetails.status == PurchaseStatus.purchased ||
               purchaseDetails.status == PurchaseStatus.restored) {
      print('购买成功: ${purchaseDetails.productID}');
      
      // 验证购买
      bool valid = await _verifyPurchase(purchaseDetails);
      
      if (valid) {
        // 交付产品
        await _deliverProduct(purchaseDetails);
        
        // 完成购买
        await _inAppPurchase.completePurchase(purchaseDetails);
        
        _purchasePending = false;
      } else {
        print('购买验证失败');
      }
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      print('购买错误: ${purchaseDetails.error}');
      _purchasePending = false;
    } else if (purchaseDetails.status == PurchaseStatus.canceled) {
      print('购买取消: ${purchaseDetails.productID}');
      _purchasePending = false;
    }
  }

  // 验证购买（在实际应用中，这里应该调用服务器验证）
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      // 这里应该实现服务器端验证
      // 为了演示，我们直接返回true
      print('验证购买: ${purchaseDetails.productID}');
      return true;
    } catch (e) {
      print('验证购买失败: $e');
      return false;
    }
  }

  // 交付产品
  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    try {
      if (_isVipProduct(purchaseDetails.productID)) {
        await _activateVipMembership(purchaseDetails.productID);
      } else {
        await _activateDiamondPurchase(purchaseDetails.productID);
      }
    } catch (e) {
      print('交付产品失败: $e');
    }
  }

  // 激活VIP会员
  Future<void> _activateVipMembership(String productId) async {
    print('激活VIP会员: $productId');
    
    try {
      // 设置VIP状态为true
      await CurrentUserService.setCurrentUserVip(true);
      
      // 根据产品ID设置不同的过期时间
      DateTime expireTime;
      switch (productId) {
        case _monthlyVipId:
        case _firstChargeVipId:
          expireTime = DateTime.now().add(const Duration(days: 30));
          break;
        case _yearlyVipId:
          expireTime = DateTime.now().add(const Duration(days: 365));
          break;
        default:
          expireTime = DateTime.now().add(const Duration(days: 30));
      }
      
      await CurrentUserService.setVipExpireTime(expireTime);
      print('VIP会员激活成功，过期时间: $expireTime');
    } catch (e) {
      print('激活VIP会员失败: $e');
      throw e;
    }
  }

  // 激活钻石购买
  Future<void> _activateDiamondPurchase(String productId) async {
    print('激活钻石购买: $productId');
    
    try {
      // 根据产品ID增加相应的钻石数量
      int diamondAmount;
      switch (productId) {
        case _diamond6Id:
          diamondAmount = 60;
          break;
        case _diamond28Id:
          diamondAmount = 300;
          break;
        case _diamond98Id:
          diamondAmount = 1130;
          break;
        case _diamond198Id:
          diamondAmount = 2350;
          break;
        case _diamond268Id:
          diamondAmount = 30700;
          break;
        case _diamond298Id:
          diamondAmount = 3600;
          break;
        default:
          diamondAmount = 0;
      }
      
      if (diamondAmount > 0) {
        await DiamondService.addDiamonds(diamondAmount);
        print('钻石购买成功，增加 $diamondAmount 钻石');
      }
    } catch (e) {
      print('激活钻石购买失败: $e');
      throw e;
    }
  }

  // 恢复购买
  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      print('恢复购买请求已发送');
    } catch (e) {
      print('恢复购买失败: $e');
    }
  }

  // 获取产品列表
  List<ProductDetails> get products => _products;

  // 检查是否可用
  bool get isAvailable => _isAvailable;

  // 检查是否有待处理的购买
  bool get purchasePending => _purchasePending;



  // 判断是否为VIP产品
  bool _isVipProduct(String productId) {
    return productId == _monthlyVipId || 
           productId == _firstChargeVipId || 
           productId == _yearlyVipId;
  }

  // 获取VIP产品
  List<ProductDetails> get vipProducts => _products
      .where((product) => _isVipProduct(product.id))
      .toList();

  // 获取钻石产品
  List<ProductDetails> get diamondProducts => _products
      .where((product) => !_isVipProduct(product.id))
      .toList();

  // 释放资源
  void dispose() {
    _subscription.cancel();
  }
}
