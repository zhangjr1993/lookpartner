import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../services/network_service.dart';
import '../services/keychain_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;
  String _statusText = '正在启动...';

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initializeApp();
  }

  void _initAnimation() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _fadeController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // 启动延迟1.8秒
      await Future.delayed(const Duration(milliseconds: 1800));
      
      setState(() {
        _statusText = '正在检查用户信息...';
      });
      
      // 检查keychain中是否有用户信息
      final hasUser = await KeychainService.hasUser();
      
      if (hasUser) {
        setState(() {
          _statusText = '启动完成';
        });
        
        // 延迟跳转到主页面
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        setState(() {
          _statusText = '跳转登录页面';
        });
        
        // 延迟跳转到登录页面
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      setState(() {
        _statusText = '启动失败: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _requestNetworkPermission() async {
    try {
      // 请求网络权限
      final status = await Permission.location.request();
      
      if (status.isDenied) {
        // 如果权限被拒绝，显示说明
        if (mounted) {
          _showPermissionDialog();
        }
      }
    } catch (e) {
      debugPrint('权限请求失败: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('需要网络权限'),
          content: const Text('为了正常使用应用功能，需要获取网络访问权限。请在设置中开启网络权限。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('去设置'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryPermission();
              },
              child: const Text('重试'),
            ),
          ],
        );
      },
    );
  }

  void _retryPermission() {
    setState(() {
      _isLoading = true;
      _statusText = '正在重试...';
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: AppSizes.getScreenWidth(context),
        height: AppSizes.getScreenHeight(context),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/launchAssets/bg_launch.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: null,
      ),
    );
  }
}
