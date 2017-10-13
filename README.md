# ZSLRecorderButton
一个常见的长按按钮录音功能库

### 集成

1.在Podifle里面添加pod库依赖：
```
pod 'ZSLRecorderButton', :git=>'https://github.com/Nihility-Ming/ZSLRecorderButton.git'
```

之后执行pod install

2.在info.plist文件添加：  
```
<key>NSMicrophoneUsageDescription</key>
<string>是否允许此App使用你的麦克风？</string>
```