import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum ReportStatus { pending, processing, resolved, rejected }

class ReportRecord {
  final String id;
  final String targetUserId;
  final String targetName;
  final String reportType;
  final String content;
  final DateTime reportTime;
  final ReportStatus status;
  final DateTime? resolveTime;
  final String? result;

  ReportRecord({
    required this.id,
    required this.targetUserId,
    required this.targetName,
    required this.reportType,
    required this.content,
    required this.reportTime,
    required this.status,
    this.resolveTime,
    this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetUserId': targetUserId,
      'targetName': targetName,
      'reportType': reportType,
      'content': content,
      'reportTime': reportTime.millisecondsSinceEpoch,
      'status': status.index,
      'resolveTime': resolveTime?.millisecondsSinceEpoch,
      'result': result,
    };
  }

  factory ReportRecord.fromJson(Map<String, dynamic> json) {
    return ReportRecord(
      id: json['id'],
      targetUserId: json['targetUserId'],
      targetName: json['targetName'],
      reportType: json['reportType'],
      content: json['content'],
      reportTime: DateTime.fromMillisecondsSinceEpoch(json['reportTime']),
      status: ReportStatus.values[json['status']],
      resolveTime: json['resolveTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['resolveTime'])
          : null,
      result: json['result'],
    );
  }
}

class ReportService {
  static const String _reportFileName = 'report_records.json';

  // 获取举报记录文件路径
  static Future<String> _getReportFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_reportFileName';
  }

  // 保存举报记录
  static Future<bool> saveReport(ReportRecord report) async {
    try {
      final filePath = await _getReportFilePath();
      final file = File(filePath);
      
      List<ReportRecord> reports = [];
      
      // 读取现有举报记录
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        reports = jsonData.map((item) => ReportRecord.fromJson(item)).toList();
      }
      
      // 添加新举报记录
      reports.add(report);
      
      // 保存到文件
      final jsonString = jsonEncode(reports.map((r) => r.toJson()).toList());
      await file.writeAsString(jsonString);
      
      print('举报记录保存成功: ${report.id}');
      return true;
    } catch (e) {
      print('保存举报记录失败: $e');
      return false;
    }
  }

  // 获取所有举报记录
  static Future<List<ReportRecord>> getAllReports() async {
    try {
      final filePath = await _getReportFilePath();
      final file = File(filePath);
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        return jsonData.map((item) => ReportRecord.fromJson(item)).toList();
      }
      
      return [];
    } catch (e) {
      print('获取举报记录失败: $e');
      return [];
    }
  }

  // 获取指定用户的举报记录
  static Future<List<ReportRecord>> getReportsByTargetUser(String targetUserId) async {
    try {
      final allReports = await getAllReports();
      return allReports.where((report) => report.targetUserId == targetUserId).toList();
    } catch (e) {
      print('获取用户举报记录失败: $e');
      return [];
    }
  }

  // 更新举报记录状态
  static Future<bool> updateReportStatus(String reportId, ReportStatus status, {String? result}) async {
    try {
      final filePath = await _getReportFilePath();
      final file = File(filePath);
      
      if (!await file.exists()) {
        return false;
      }
      
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final reports = jsonData.map((item) => ReportRecord.fromJson(item)).toList();
      
      // 查找并更新指定举报记录
      final index = reports.indexWhere((report) => report.id == reportId);
      if (index != -1) {
        final originalReport = reports[index];
        reports[index] = ReportRecord(
          id: originalReport.id,
          targetUserId: originalReport.targetUserId,
          targetName: originalReport.targetName,
          reportType: originalReport.reportType,
          content: originalReport.content,
          reportTime: originalReport.reportTime,
          status: status,
          resolveTime: status == ReportStatus.resolved ? DateTime.now() : originalReport.resolveTime,
          result: result ?? originalReport.result,
        );
        
        // 保存更新后的记录
        final updatedJsonString = jsonEncode(reports.map((r) => r.toJson()).toList());
        await file.writeAsString(updatedJsonString);
        
        print('举报记录状态更新成功: $reportId');
        return true;
      }
      
      return false;
    } catch (e) {
      print('更新举报记录状态失败: $e');
      return false;
    }
  }

  // 删除举报记录
  static Future<bool> deleteReport(String reportId) async {
    try {
      final filePath = await _getReportFilePath();
      final file = File(filePath);
      
      if (!await file.exists()) {
        return false;
      }
      
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final reports = jsonData.map((item) => ReportRecord.fromJson(item)).toList();
      
      // 移除指定举报记录
      reports.removeWhere((report) => report.id == reportId);
      
      // 保存更新后的记录
      final updatedJsonString = jsonEncode(reports.map((r) => r.toJson()).toList());
      await file.writeAsString(updatedJsonString);
      
      print('举报记录删除成功: $reportId');
      return true;
    } catch (e) {
      print('删除举报记录失败: $e');
      return false;
    }
  }

  // 清除所有举报记录
  static Future<bool> clearAllReports() async {
    try {
      final filePath = await _getReportFilePath();
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
        print('所有举报记录已清除');
      }
      
      return true;
    } catch (e) {
      print('清除举报记录失败: $e');
      return false;
    }
  }
}
