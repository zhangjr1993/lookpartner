# 卡片约束修复说明

## 问题描述

用户要求按照以下规则设置emptyCard1和emptyCard2的约束：

1. **emptyCard1**：以mainCard为准，左右上约束比mainCard内边距均小10px，底部超出mainCard的12px
2. **emptyCard2**：以mainCard为准，左右上约束比mainCard内边距均小18px，底部超出mainCard的18px
3. **mainCard**：约束保持不变

## 解决方案

### 1. 修改`_buildEmptyCard`方法

将原来的`bottomOffset`参数扩展为完整的约束控制：

```dart
Widget _buildEmptyCard({
  required double width,
  required Color color,
  required double topOffset,      // 新增：顶部偏移
  required double leftOffset,     // 新增：左边偏移
  required double bottomOffset,   // 保持：底部偏移
  required Animation<double> animation,
})
```

### 2. 设置emptyCard2的约束

```dart
// 空卡片2 - 最先入场 (最浅灰色)
// 以mainCard为准，左右上约束比mainCard内边距均小18px，底部超出mainCard的18px
_buildEmptyCard(
  width: cardWidth - 36,         // 比mainCard宽度小18px*2
  color: const Color(0xFFE8E8E8),
  topOffset: 18,                 // 比mainCard顶部大18px
  leftOffset: 18,                // 比mainCard左边大18px
  bottomOffset: -18,             // 底部超出mainCard的18px
  animation: _emptyCard2Animation,
),
```

### 3. 设置emptyCard1的约束

```dart
// 空卡片1 - 第二个入场 (中灰色)
// 以mainCard为准，左右上约束比mainCard内边距均小10px，底部超出mainCard的12px
_buildEmptyCard(
  width: cardWidth - 20,         // 比mainCard宽度小10px*2
  color: const Color(0xFFAAAAAA),
  topOffset: 10,                 // 比mainCard顶部大10px
  leftOffset: 10,                // 比mainCard左边大10px
  bottomOffset: -12,             // 底部超出mainCard的12px
  animation: _emptyCard1Animation,
),
```

## 约束计算逻辑

### mainCard约束（保持不变）
- 宽度：`cardWidth`（屏幕宽度 - 32px）
- 水平居中：`left: (screenWidth - 32 - cardWidth) / 2`
- 顶部：`top: 0`
- 底部：无约束

### emptyCard1约束
- 宽度：`cardWidth - 20`（比mainCard小20px）
- 左边：`left: 10`（比mainCard左边大10px）
- 顶部：`top: 10`（比mainCard顶部大10px）
- 底部：`bottom: -12`（超出mainCard底部12px）

### emptyCard2约束
- 宽度：`cardWidth - 36`（比mainCard小36px）
- 左边：`left: 18`（比mainCard左边大18px）
- 顶部：`top: 18`（比mainCard顶部大18px）
- 底部：`bottom: -18`（超出mainCard底部18px）

## 视觉效果

修复后的布局将呈现：
1. **mainCard**：在最上层，显示主要内容
2. **emptyCard1**：在mainCard下方，稍微偏移，作为第一层背景
3. **emptyCard2**：在最底层，更大的偏移，作为第二层背景

这种布局确保了：
- 主卡片完全可见
- 背景卡片有层次感
- 菜单按钮不会被遮挡
- 符合设计规范

## 文件修改清单

1. `lib/pages/discover_page.dart` - 修改`_buildEmptyCard`方法和调用参数

## 预期效果

修复后，用户应该能够看到：
- ✅ mainCard正常显示，约束保持不变
- ✅ emptyCard1按照10px规则偏移，底部超出12px
- ✅ emptyCard2按照18px规则偏移，底部超出18px
- ✅ 所有卡片都有正确的层次关系
- ✅ 菜单按钮完全可见，不被遮挡
