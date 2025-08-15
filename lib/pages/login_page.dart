import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../services/keychain_service.dart';
import '../models/user_model.dart';
import '../utils/user_generator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  bool _isAgreed = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _shakeProtocolText() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  void _onAgreementChanged(bool? value) {
    setState(() {
      _isAgreed = value ?? false;
    });
  }

  void _onEnterApp() async {
    if (!_isAgreed) {
      _shakeProtocolText();
      return;
    }

    try {
      // 生成随机用户信息
      final user = UserGenerator.generateRandomUser();
      
      // 保存到keychain
      await KeychainService.saveUser(user);
      
      // 导航到主页
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登录失败: $e')),
        );
      }
    }
  }

  void _onUserAgreementTap() {
    // TODO: 打开用户协议网页
    _openWebPage('用户协议');
  }

  void _onPrivacyAgreementTap() {
    // TODO: 打开隐私授权协议网页
    _openWebPage('隐私授权协议');
  }

  void _openWebPage(String title) {
    // 这里可以打开WebView或者外部浏览器
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('打开$title')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSizes.getScreenWidth(context);
    final screenHeight = AppSizes.getScreenHeight(context);
    final bottomSafeArea = AppSizes.getBottomSafeArea(context);

    return Scaffold(
      body: Stack(
        children: [
          // 背景图片
          Positioned.fill(
            child: Image.asset(
              'assets/images/loginAssets/bg_login.webp',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFD4FFC4), Color(0xFFF4FFC7), Colors.white],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 底部阴影
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/loginAssets/bg_login_shadow.webp',
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 主要内容
          Column(
            children: [
              const Spacer(),
              
              // 趣味图片
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Image.asset(
                  'assets/images/loginAssets/img_login_word.webp',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.favorite,
                      size: 120,
                      color: AppColors.primaryTextHighlight,
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 进入app按钮
              Container(
                width: AppSizes.getScreenWidth(context) - 96,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onEnterApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                    foregroundColor: AppColors.primaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '进入app',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 协议勾选框和协议文本
              Container(
                margin: EdgeInsets.only(
                  bottom: bottomSafeArea + 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 协议勾选框
                    GestureDetector(
                      onTap: () => _onAgreementChanged(!_isAgreed),
                      child: Image.asset(
                        _isAgreed
                            ? 'assets/images/loginAssets/btn_login_ok.webp'
                            : 'assets/images/loginAssets/btn_login_no.webp',
                        width: 16,
                        height: 16,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            width: 16,
                            height: 16,
                            child: Checkbox(
                              value: _isAgreed,
                              onChanged: _onAgreementChanged,
                              activeColor: AppColors.primaryTextHighlight,
                              checkColor: Colors.white,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // 协议文本
                    Flexible(
                      child: AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(text: '我已阅读并同意'),
                                  TextSpan(
                                    text: '《用户协议》',
                                    style: const TextStyle(
                                      color: AppColors.primaryTextHighlight,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _onUserAgreementTap,
                                  ),
                                  const TextSpan(text: '和'),
                                  TextSpan(
                                    text: '《隐私授权协议》',
                                    style: const TextStyle(
                                      color: AppColors.primaryTextHighlight,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _onPrivacyAgreementTap,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
