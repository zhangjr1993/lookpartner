import Foundation
import Security

@objc class KeychainHandler: NSObject {
    
    private static let serviceName = "com.lookpartner.userinfo"
    private static let accountName = "user_info_v4"
    
    /// 保存用户信息到Keychain
    @objc func saveUser(_ userData: [String: Any], result: @escaping FlutterResult) {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData) else {
            result(FlutterError(code: "INVALID_DATA", message: "用户数据格式无效", details: nil))
            return
        }
        
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainHandler.serviceName,
            kSecAttrAccount as String: KeychainHandler.accountName,
            kSecValueData as String: jsonData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        
        // 先删除已存在的数据
        let deleteStatus = SecItemDelete(query as CFDictionary)
        
        // 保存新数据
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            result(true)
        } else {
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "未知错误"
            result(FlutterError(code: "SAVE_FAILED", message: "保存用户信息失败: \(errorMessage)", details: nil))
        }
    }
    
    /// 从Keychain读取用户信息
    @objc func getUser(result: @escaping FlutterResult) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainHandler.serviceName,
            kSecAttrAccount as String: KeychainHandler.accountName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var resultTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &resultTypeRef)
        
        if status == errSecSuccess {
            if let data = resultTypeRef as? Data {
                do {
                    let userData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    result(userData)
                } catch {
                    result(FlutterError(code: "PARSE_FAILED", message: "解析用户数据失败", details: nil))
                }
            } else {
                result(nil)
            }
        } else if status == errSecItemNotFound {
            result(nil)
        } else {
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "未知错误"
            result(FlutterError(code: "READ_FAILED", message: "读取用户信息失败: \(errorMessage)", details: nil))
        }
    }
    
    /// 从Keychain删除用户信息
    @objc func deleteUser(result: @escaping FlutterResult) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainHandler.serviceName,
            kSecAttrAccount as String: KeychainHandler.accountName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess || status == errSecItemNotFound {
            result(true)
        } else {
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "未知错误"
            result(FlutterError(code: "DELETE_FAILED", message: "删除用户信息失败: \(errorMessage)", details: nil))
        }
    }
    
    /// 检查Keychain中是否有用户信息
    @objc func hasUser(result: @escaping FlutterResult) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainHandler.serviceName,
            kSecAttrAccount as String: KeychainHandler.accountName,
            kSecReturnData as String: false,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            result(true)
        } else if status == errSecItemNotFound {
            result(false)
        } else {
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "未知错误"
            result(FlutterError(code: "CHECK_FAILED", message: "检查用户信息失败: \(errorMessage)", details: nil))
        }
    }
    
    /// 更新用户信息
    @objc func updateUser(_ userData: [String: Any], result: @escaping FlutterResult) {
        saveUser(userData, result: result)
    }
}
