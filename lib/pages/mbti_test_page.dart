import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/mbti_service.dart';

class MbtiTestPage extends StatefulWidget {
  const MbtiTestPage({super.key});

  @override
  State<MbtiTestPage> createState() => _MbtiTestPageState();
}

class _MbtiTestPageState extends State<MbtiTestPage> {
  int _currentQuestionIndex = 0;
  List<int> _answers = [];
  bool _isLoading = false;
  String? _resultPersonality;
  bool _showResult = false;

  final List<MbtiQuestion> _questions = [
    MbtiQuestion(
      id: 1,
      question: "在社交场合中，你更倾向于：",
      options: ["主动与他人交谈", "等待他人来搭话"],
      dimension: MbtiDimension.EI,
    ),
    MbtiQuestion(
      id: 2,
      question: "你更喜欢的工作环境是：",
      options: ["开放式的团队合作", "安静的独立空间"],
      dimension: MbtiDimension.EI,
    ),
    MbtiQuestion(
      id: 3,
      question: "做决定时，你更依赖：",
      options: ["直觉和感觉", "逻辑和分析"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 4,
      question: "你更喜欢的学习方式是：",
      options: ["实践和体验", "理论和概念"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 5,
      question: "面对新项目，你倾向于：",
      options: ["制定详细计划", "随机应变"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 6,
      question: "你更喜欢的周末安排是：",
      options: ["参加聚会活动", "在家放松休息"],
      dimension: MbtiDimension.EI,
    ),
    MbtiQuestion(
      id: 7,
      question: "处理问题时，你更关注：",
      options: ["具体的事实", "潜在的可能性"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 8,
      question: "你更重视：",
      options: ["公平和逻辑", "和谐和感受"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 9,
      question: "你更喜欢的工作方式是：",
      options: ["按计划执行", "灵活调整"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 10,
      question: "你更喜欢的沟通方式是：",
      options: ["直接表达", "委婉暗示"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 11,
      question: "你更喜欢的书籍类型是：",
      options: ["实用指南", "科幻小说"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 12,
      question: "你更喜欢的旅行方式是：",
      options: ["详细规划", "随性而为"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 13,
      question: "你更喜欢的领导风格是：",
      options: ["民主协商", "果断决策"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 14,
      question: "你更喜欢的解决问题方法是：",
      options: ["分析数据", "凭直觉"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 15,
      question: "你更喜欢的团队角色是：",
      options: ["组织协调", "创意贡献"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 16,
      question: "你更喜欢的表达方式是：",
      options: ["文字写作", "口头表达"],
      dimension: MbtiDimension.EI,
    ),
    MbtiQuestion(
      id: 17,
      question: "你更喜欢的决策依据是：",
      options: ["客观事实", "主观感受"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 18,
      question: "你更喜欢的创新方式是：",
      options: ["改进现有", "完全创新"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 19,
      question: "你更喜欢的压力处理方式是：",
      options: ["制定计划", "寻求支持"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 20,
      question: "你更喜欢的社交方式是：",
      options: ["深度交流", "广泛社交"],
      dimension: MbtiDimension.EI,
    ),
    MbtiQuestion(
      id: 21,
      question: "你更喜欢的评价标准是：",
      options: ["客观标准", "主观感受"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 22,
      question: "你更喜欢的记忆方式是：",
      options: ["具体细节", "整体印象"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 23,
      question: "你更喜欢的任务完成方式是：",
      options: ["按时完成", "质量优先"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 24,
      question: "你更喜欢的冲突处理方式是：",
      options: ["理性分析", "情感理解"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 25,
      question: "你更喜欢的思维方式是：",
      options: ["线性思维", "发散思维"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 26,
      question: "你更喜欢的能量来源是：",
      options: ["外部刺激", "内心反思"],
      dimension: MbtiDimension.EI,
    ),
    MbtiQuestion(
      id: 27,
      question: "你更喜欢的价值观是：",
      options: ["效率优先", "和谐优先"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 28,
      question: "你更喜欢的观察方式是：",
      options: ["关注细节", "把握全局"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 29,
      question: "你更喜欢的改变方式是：",
      options: ["渐进式", "突破式"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 30,
      question: "你更喜欢的沟通重点是：",
      options: ["传递信息", "建立关系"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 31,
      question: "你更喜欢的预测方式是：",
      options: ["基于经验", "基于直觉"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 32,
      question: "你更喜欢的成就感来源是：",
      options: ["完成任务", "帮助他人"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 33,
      question: "你更喜欢的适应方式是：",
      options: ["调整计划", "保持灵活"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 34,
      question: "你更喜欢的专注方式是：",
      options: ["深度专注", "多任务处理"],
      dimension: MbtiDimension.EI,
    ),
    MbtiQuestion(
      id: 35,
      question: "你更喜欢的判断标准是：",
      options: ["逻辑一致", "情感和谐"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 36,
      question: "你更喜欢的理解方式是：",
      options: ["具体分析", "整体把握"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 37,
      question: "你更喜欢的执行方式是：",
      options: ["按部就班", "随机应变"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 38,
      question: "你更喜欢的激励方式是：",
      options: ["挑战目标", "温暖支持"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 39,
      question: "你更喜欢的思考方式是：",
      options: ["系统分析", "灵感迸发"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 40,
      question: "你更喜欢的反馈方式是：",
      options: ["直接批评", "委婉建议"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 41,
      question: "你更喜欢的规划方式是：",
      options: ["长期规划", "短期调整"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 42,
      question: "你更喜欢的表达重点是：",
      options: ["传递事实", "表达感受"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 43,
      question: "你更喜欢的观察角度是：",
      options: ["微观细节", "宏观趋势"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 44,
      question: "你更喜欢的决策速度是：",
      options: ["快速决定", "深思熟虑"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 45,
      question: "你更喜欢的价值观排序是：",
      options: ["效率>和谐", "和谐>效率"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 46,
      question: "你更喜欢的创新思维是：",
      options: ["实用创新", "概念创新"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 47,
      question: "你更喜欢的压力应对是：",
      options: ["控制环境", "适应环境"],
      dimension: MbtiDimension.JP,
    ),
    MbtiQuestion(
      id: 48,
      question: "你更喜欢的沟通风格是：",
      options: ["直接明确", "含蓄委婉"],
      dimension: MbtiDimension.TF,
    ),
    MbtiQuestion(
      id: 49,
      question: "你更喜欢的认知方式是：",
      options: ["经验积累", "直觉判断"],
      dimension: MbtiDimension.SN,
    ),
    MbtiQuestion(
      id: 50,
      question: "你更喜欢的成就定义是：",
      options: ["目标达成", "关系和谐"],
      dimension: MbtiDimension.TF,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _answers = List.filled(_questions.length, -1);
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[_currentQuestionIndex] = answerIndex;
    });

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _calculateResult();
    }
  }

  void _calculateResult() {
    setState(() {
      _isLoading = true;
    });

    // 计算各维度的得分
    int eScore = 0, iScore = 0;
    int sScore = 0, nScore = 0;
    int tScore = 0, fScore = 0;
    int jScore = 0, pScore = 0;

    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i] == -1) continue; // 跳过未回答的题目

      final question = _questions[i];
      final answer = _answers[i];

      switch (question.dimension) {
        case MbtiDimension.EI:
          if (answer == 0) eScore++;
          if (answer == 1) iScore++;
          break;
        case MbtiDimension.SN:
          if (answer == 0) sScore++;
          if (answer == 1) nScore++;
          break;
        case MbtiDimension.TF:
          if (answer == 0) tScore++;
          if (answer == 1) fScore++;
          break;
        case MbtiDimension.JP:
          if (answer == 0) jScore++;
          if (answer == 1) pScore++;
          break;
      }
    }

    // 确定性格类型
    String personality = '';
    personality += eScore >= iScore ? 'E' : 'I';
    personality += sScore >= nScore ? 'S' : 'N';
    personality += tScore >= fScore ? 'T' : 'F';
    personality += jScore >= pScore ? 'J' : 'P';

    setState(() {
      _resultPersonality = personality;
      _showResult = true;
      _isLoading = false;
    });
  }

  void _saveResult() async {
    if (_resultPersonality != null) {
      final success = await MbtiService.savePersonalityResult(_resultPersonality!);
      if (success) {
        _showToast("性格测试结果已保存");
      } else {
        _showToast("保存失败，请重试");
      }
    }
  }

  void _analyzePersonality() async {
    if (_resultPersonality != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final analysis = await MbtiService.analyzePersonality(_resultPersonality!);
        setState(() {
          _isLoading = false;
        });
        
        _showAnalysisDialog(analysis);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showToast("分析失败，请重试");
      }
    }
  }

  void _showAnalysisDialog(String analysis) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI性格分析'),
        content: SingleChildScrollView(
          child: Text(analysis),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _resetTest() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers = List.filled(_questions.length, -1);
      _showResult = false;
      _resultPersonality = null;
    });
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
          'MBTI性格测试',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showResult
              ? _buildResultPage()
              : _buildQuestionPage(),
    );
  }

  Widget _buildQuestionPage() {
    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Column(
      children: [
        // 进度条
        Container(
          width: double.infinity,
          height: 4,
          color: Colors.grey.shade200,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryTextHighlight),
          ),
        ),
        
        // 进度文本
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${_currentQuestionIndex + 1} / ${_questions.length}',
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // 问题
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentQuestion.question,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                                 // 选项
                 ...currentQuestion.options.asMap().entries.map((entry) {
                   final index = entry.key;
                   final option = entry.value;
                   final isSelected = _answers[_currentQuestionIndex] == index;
                   
                   return Container(
                     width: double.infinity,
                     margin: const EdgeInsets.only(bottom: 16),
                     child: ElevatedButton(
                       onPressed: () => _selectAnswer(index),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: isSelected 
                             ? AppColors.primaryTextHighlight 
                             : Colors.white,
                         foregroundColor: isSelected 
                             ? AppColors.primaryText 
                             : AppColors.primaryText,
                         elevation: isSelected ? 0 : 2,
                         padding: const EdgeInsets.symmetric(vertical: 20),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(12),
                           side: BorderSide(
                             color: isSelected 
                                 ? AppColors.primaryTextHighlight 
                                 : Colors.grey.shade300,
                             width: 2,
                           ),
                         ),
                       ),
                       child: Text(
                         option,
                         style: TextStyle(
                           fontSize: 16,
                           fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                         ),
                       ),
                     ),
                   );
                 }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '测试完成！',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // 性格标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF538),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              _resultPersonality ?? '',
              style: const TextStyle(
                color: Color(0xFF171717),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // 保存按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveResult,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTextHighlight,
                foregroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '保存结果',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // AI分析按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _analyzePersonality,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.primaryTextHighlight, width: 2),
                ),
              ),
              child: const Text(
                'AI性格分析',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 重新测试按钮
          TextButton(
            onPressed: _resetTest,
            child: const Text(
              '重新测试',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum MbtiDimension { EI, SN, TF, JP }

class MbtiQuestion {
  final int id;
  final String question;
  final List<String> options;
  final MbtiDimension dimension;

  MbtiQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.dimension,
  });
}
