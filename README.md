# myapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>货物出货计算APP - 整合原型</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .phone-frame {
            width: 375px;
            height: 812px;
            background: #000;
            border-radius: 40px;
            padding: 8px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.3);
            position: relative;
            margin: 0 20px;
        }
        .phone-screen {
            width: 100%;
            height: 100%;
            background: #f8f9fa;
            border-radius: 32px;
            overflow: hidden;
            position: relative;
        }
        .status-bar {
            height: 44px;
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(20px);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            font-size: 14px;
            font-weight: 600;
        }
        .tab-bar {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 83px;
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(20px);
            border-top: 0.5px solid rgba(0,0,0,0.1);
            padding-bottom: 34px;
        }
        .annotation {
            position: absolute;
            background: rgba(59, 130, 246, 0.1);
            border: 2px solid #3b82f6;
            border-radius: 8px;
            padding: 8px 12px;
            font-size: 12px;
            color: #1e40af;
            font-weight: 500;
            max-width: 200px;
            line-height: 1.4;
            z-index: 10;
        }
        .annotation::before {
            content: '';
            position: absolute;
            width: 0;
            height: 0;
            border-style: solid;
        }
        .annotation-left::before {
            right: -10px;
            top: 50%;
            transform: translateY(-50%);
            border-width: 8px 0 8px 10px;
            border-color: transparent transparent transparent #3b82f6;
        }
        .annotation-right::before {
            left: -10px;
            top: 50%;
            transform: translateY(-50%);
            border-width: 8px 10px 8px 0;
            border-color: transparent #3b82f6 transparent transparent;
        }
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .card-shadow {
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .image-container {
            position: relative;
            background: #f3f4f6;
            border: 2px dashed #d1d5db;
            border-radius: 12px;
            aspect-ratio: 4/3;
            overflow: hidden;
        }
        .quantity-badge {
            position: absolute;
            top: 8px;
            right: 8px;
            background: rgba(239, 68, 68, 0.9);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .section-divider {
            height: 20px;
            background: linear-gradient(to right, #e5e7eb, #f3f4f6, #e5e7eb);
            margin: 0 -16px;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen p-4">
    <div class="max-w-7xl mx-auto">
        <h1 class="text-3xl font-bold text-center mb-8 text-gray-800">货物出货计算APP - 整合界面原型</h1>
        
        <!-- 整合界面 -->
        <div class="flex items-start justify-center gap-8">
            <!-- 左侧注释 -->
            <div class="flex flex-col gap-6 pt-16">
                <div class="annotation annotation-right" style="margin-top: 60px;">
                    <strong>用户登录模块 / User Login</strong><br>
                    用户身份验证，支持多种登录方式
                </div>
                <div class="annotation annotation-right" style="margin-top: 140px;">
                    <strong>车次管理 / Vehicle Management</strong><br>
                    创建和管理不同车次，显示统计数据
                </div>
                <div class="annotation annotation-right" style="margin-top: 200px;">
                    <strong>图片添加模块 / Image Upload</strong><br>
                    上传商品图片并标注数量信息
                </div>
                <div class="annotation annotation-right" style="margin-top: 120px;">
                    <strong>微信截图生成 / WeChat Screenshot</strong><br>
                    生成格式化的分享截图
                </div>
                <div class="annotation annotation-right" style="margin-top: 80px;">
                    <strong>历史数据模块 / History Data</strong><br>
                    查看和编辑历史出货记录
                </div>
            </div>
            
            <div class="phone-frame">
                <div class="phone-screen">
                    <!-- 状态栏 -->
                    <div class="status-bar">
                        <span>9:41</span>
                        <div class="flex items-center gap-1">
                            <i class="fas fa-signal text-xs"></i>
                            <i class="fas fa-wifi text-xs"></i>
                            <i class="fas fa-battery-three-quarters text-xs"></i>
                        </div>
                    </div>
                    
                    <!-- 导航栏 -->
                    <div class="bg-white px-4 py-3 border-b border-gray-200 flex items-center">
                        <div class="flex items-center">
                            <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face" class="w-8 h-8 rounded-full mr-3">
                            <div>
                                <h2 class="text-lg font-bold text-gray-800">张师傅</h2>
                                <p class="text-xs text-gray-500">出货管理</p>
                            </div>
                        </div>
                        <div class="ml-auto flex items-center gap-3">
                            <i class="fas fa-bell text-gray-400"></i>
                            <button class="text-red-500 text-sm">
                                <i class="fas fa-sign-out-alt"></i>
                            </button>
                        </div>
                    </div>
                    
                    <!-- 主要内容 -->
                    <div class="flex-1 pb-20 overflow-y-auto">
                        <!-- 1. 用户状态和统计 -->
                        <div class="p-4">
                            <div class="gradient-bg rounded-2xl p-4 text-white">
                                <div class="flex justify-between items-center mb-3">
                                    <h3 class="text-lg font-bold">今日出货统计</h3>
                                    <span class="bg-white bg-opacity-20 px-2 py-1 rounded-full text-xs">在线</span>
                                </div>
                                <div class="grid grid-cols-3 gap-4">
                                    <div class="text-center">
                                        <p class="text-2xl font-bold">3</p>
                                        <p class="text-sm opacity-90">车次</p>
                                    </div>
                                    <div class="text-center">
                                        <p class="text-2xl font-bold">67</p>
                                        <p class="text-sm opacity-90">货品</p>
                                    </div>
                                    <div class="text-center">
                                        <p class="text-2xl font-bold">1,258</p>
                                        <p class="text-sm opacity-90">总数量</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 2. 车次选择/创建 -->
                        <div class="px-4 pb-4">
                            <div class="flex justify-between items-center mb-3">
                                <h4 class="text-lg font-bold text-gray-800">选择车次</h4>
                                <button class="text-blue-500 text-sm font-medium">
                                    <i class="fas fa-plus mr-1"></i>新建车次
                                </button>
                            </div>
                            
                            <div class="flex gap-2 overflow-x-auto pb-2">
                                <button class="px-4 py-2 bg-blue-500 text-white rounded-full text-sm font-medium whitespace-nowrap">
                                    第一车 (23)
                                </button>
                                <button class="px-4 py-2 bg-gray-100 text-gray-600 rounded-full text-sm whitespace-nowrap">
                                    第二车 (18)
                                </button>
                                <button class="px-4 py-2 bg-gray-100 text-gray-600 rounded-full text-sm whitespace-nowrap">
                                    第三车 (26)
                                </button>
                                <button class="px-4 py-2 bg-gray-50 text-gray-400 rounded-full text-sm whitespace-nowrap border-2 border-dashed border-gray-300">
                                    + 新车次
                                </button>
                            </div>
                        </div>
                        
                        <div class="section-divider"></div>
                        
                        <!-- 3. 添加图片模块 -->
                        <div class="p-4">
                            <div class="flex justify-between items-center mb-4">
                                <h4 class="text-lg font-bold text-gray-800">第一车 - 商品管理</h4>
                                <span class="text-sm text-gray-500">23件商品</span>
                            </div>
                            
                            <!-- 添加商品按钮 -->
                            <button class="w-full bg-blue-50 border-2 border-dashed border-blue-300 rounded-xl py-4 mb-4 text-blue-500 font-medium">
                                <i class="fas fa-camera text-2xl mb-2 block"></i>
                                点击添加商品图片
                            </button>
                            
                            <!-- 商品列表 -->
                            <div class="space-y-3">
                                <!-- 商品1 -->
                                <div class="bg-white rounded-xl p-3 card-shadow">
                                    <div class="flex gap-3">
                                        <div class="image-container w-20 h-16 flex-shrink-0">
                                            <img src="https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=80&h=64&fit=crop" class="w-full h-full object-cover rounded-lg">
                                            <div class="quantity-badge">156</div>
                                        </div>
                                        <div class="flex-1">
                                            <div class="flex justify-between items-start mb-2">
                                                <h5 class="font-bold text-gray-800 text-sm">货号: A001</h5>
                                                <button class="text-red-400 text-xs">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                            <div class="flex justify-between items-center">
                                                <div class="flex items-center gap-2">
                                                    <span class="text-xs text-gray-500">数量:</span>
                                                    <input type="number" value="156" class="w-16 px-2 py-1 border border-gray-200 rounded text-xs font-bold">
                                                </div>
                                                <button class="px-2 py-1 bg-blue-100 text-blue-600 rounded text-xs">
                                                    <i class="fas fa-edit mr-1"></i>编辑
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- 商品2 -->
                                <div class="bg-white rounded-xl p-3 card-shadow">
                                    <div class="flex gap-3">
                                        <div class="image-container w-20 h-16 flex-shrink-0">
                                            <img src="https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=80&h=64&fit=crop" class="w-full h-full object-cover rounded-lg">
                                            <div class="quantity-badge">89</div>
                                        </div>
                                        <div class="flex-1">
                                            <div class="flex justify-between items-start mb-2">
                                                <h5 class="font-bold text-gray-800 text-sm">货号: A002</h5>
                                                <button class="text-red-400 text-xs">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                            <div class="flex justify-between items-center">
                                                <div class="flex items-center gap-2">
                                                    <span class="text-xs text-gray-500">数量:</span>
                                                    <input type="number" value="89" class="w-16 px-2 py-1 border border-gray-200 rounded text-xs font-bold">
                                                </div>
                                                <button class="px-2 py-1 bg-blue-100 text-blue-600 rounded text-xs">
                                                    <i class="fas fa-edit mr-1"></i>编辑
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- 商品3 -->
                                <div class="bg-white rounded-xl p-3 card-shadow">
                                    <div class="flex gap-3">
                                        <div class="image-container w-20 h-16 flex-shrink-0">
                                            <img src="https://images.unsplash.com/photo-1542838132-92c53300491e?w=80&h=64&fit=crop" class="w-full h-full object-cover rounded-lg">
                                            <div class="quantity-badge">211</div>
                                        </div>
                                        <div class="flex-1">
                                            <div class="flex justify-between items-start mb-2">
                                                <h5 class="font-bold text-gray-800 text-sm">货号: A003</h5>
                                                <button class="text-red-400 text-xs">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                            <div class="flex justify-between items-center">
                                                <div class="flex items-center gap-2">
                                                    <span class="text-xs text-gray-500">数量:</span>
                                                    <input type="number" value="211" class="w-16 px-2 py-1 border border-gray-200 rounded text-xs font-bold">
                                                </div>
                                                <button class="px-2 py-1 bg-blue-100 text-blue-600 rounded text-xs">
                                                    <i class="fas fa-edit mr-1"></i>编辑
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="section-divider"></div>
                        
                        <!-- 4. 微信截图生成 -->
                        <div class="p-4">
                            <div class="flex justify-between items-center mb-4">
                                <h4 class="text-lg font-bold text-gray-800">生成分享截图</h4>
                                <span class="text-sm text-green-600">总计: 456件</span>
                            </div>
                            
                            <!-- 微信截图预览 -->
                            <div class="bg-white rounded-xl p-4 card-shadow mb-4">
                                <div class="bg-green-50 rounded-lg p-3 mb-3">
                                    <div class="flex items-center gap-2 mb-2">
                                        <i class="fab fa-weixin text-green-500 text-lg"></i>
                                        <span class="font-bold text-gray-800">第一车出货清单</span>
                                    </div>
                                    <div class="text-sm text-gray-600 space-y-1">
                                        <p>📦 A001: 156件</p>
                                        <p>📦 A002: 89件</p>
                                        <p>📦 A003: 211件</p>
                                        <div class="border-t pt-2 mt-2">
                                            <p class="font-bold">总计: 456件</p>
                                            <p class="text-xs text-gray-500">2024-07-26 15:30</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="flex gap-2">
                                    <button class="flex-1 bg-green-500 text-white py-2 rounded-lg text-sm font-medium">
                                        <i class="fab fa-weixin mr-1"></i>生成微信截图
                                    </button>
                                    <button class="px-4 bg-gray-100 text-gray-600 py-2 rounded-lg text-sm">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <div class="section-divider"></div>
                        
                        <!-- 5. 历史数据模块 -->
                        <div class="p-4">
                            <div class="flex justify-between items-center mb-4">
                                <h4 class="text-lg font-bold text-gray-800">历史记录</h4>
                                <button class="text-blue-500 text-sm">查看全部</button>
                            </div>
                            
                            <div class="space-y-3">
                                <!-- 历史记录1 -->
                                <div class="bg-white rounded-xl p-3 card-shadow">
                                    <div class="flex justify-between items-start mb-2">
                                        <div>
                                            <h5 class="font-bold text-gray-800 text-sm">第二车</h5>
                                            <p class="text-xs text-gray-500">2024-07-25 14:30</p>
                                        </div>
                                        <div class="flex gap-1">
                                            <button class="px-2 py-1 bg-blue-100 text-blue-600 rounded text-xs">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="px-2 py-1 bg-green-100 text-green-600 rounded text-xs">
                                                <i class="fas fa-share"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="flex justify-between text-xs text-gray-600">
                                        <span>商品: 18件</span>
                                        <span class="font-bold">总计: 322件</span>
                                    </div>
                                </div>
                                
                                <!-- 历史记录2 -->
                                <div class="bg-white rounded-xl p-3 card-shadow">
                                    <div class="flex justify-between items-start mb-2">
                                        <div>
                                            <h5 class="font-bold text-gray-800 text-sm">第三车</h5>
                                            <p class="text-xs text-gray-500">2024-07-24 09:15</p>
                                        </div>
                                        <div class="flex gap-1">
                                            <button class="px-2 py-1 bg-blue-100 text-blue-600 rounded text-xs">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="px-2 py-1 bg-green-100 text-green-600 rounded text-xs">
                                                <i class="fas fa-share"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="flex justify-between text-xs text-gray-600">
                                        <span>商品: 26件</span>
                                        <span class="font-bold">总计: 480件</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 底部操作区 -->
                        <div class="px-4 pb-4">
                            <div class="flex gap-2">
                                <button class="flex-1 bg-blue-500 text-white py-3 rounded-xl font-medium">
                                    <i class="fas fa-save mr-2"></i>保存当前车次
                                </button>
                                <button class="px-4 bg-gray-200 text-gray-700 py-3 rounded-xl">
                                    <i class="fas fa-upload"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 底部导航栏 -->
                    <div class="tab-bar">
                        <div class="flex justify-around items-center h-12 pt-2">
                            <div class="flex flex-col items-center">
                                <i class="fas fa-home text-blue-500 text-lg mb-1"></i>
                                <span class="text-xs text-blue-500 font-medium">首页</span>
                            </div>
                            <div class="flex flex-col items-center">
                                <i class="fas fa-truck text-gray-400 text-lg mb-1"></i>
                                <span class="text-xs text-gray-400">车次</span>
                            </div>
                            <div class="flex flex-col items-center">
                                <i class="fas fa-camera text-gray-400 text-lg mb-1"></i>
                                <span class="text-xs text-gray-400">拍照</span>
                            </div>
                            <div class="flex flex-col items-center">
                                <i class="fas fa-history text-gray-400 text-lg mb-1"></i>
                                <span class="text-xs text-gray-400">历史</span>
                            </div>
                            <div class="flex flex-col items-center">
                                <i class="fas fa-user text-gray-400 text-lg mb-1"></i>
                                <span class="text-xs text-gray-400">我的</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 右侧注释 -->
            <div class="flex flex-col gap-6 pt-16">
                <div class="annotation annotation-left" style="margin-top: 60px;">
                    <strong>用户信息栏 / User Header</strong><br>
                    显示用户状态和退出登录选项
                </div>
                <div class="annotation annotation-left" style="margin-top: 100px;">
                    <strong>车次标签页 / Vehicle Tabs</strong><br>
                    快速切换不同车次，显示商品数量
                </div>
                <div class="annotation annotation-left" style="margin-top: 180px;">
                    <strong>商品卡片 / Product Cards</strong><br>
                    紧凑的商品信息展示和数量编辑
                </div>
                <div class="annotation annotation-left" style="margin-top: 140px;">
                    <strong>微信分享预览 / WeChat Preview</strong><br>
                    模拟微信消息格式的分享预览
                </div>
                <div class="annotation annotation-left" style="margin-top: 100px;">
                    <strong>历史记录卡片 / History Cards</strong><br>
                    紧凑的历史数据展示和操作按钮
                </div>
            </div>
        </div>
        
        <!-- 功能说明 -->
        <div class="mt-12 bg-white rounded-2xl p-8 card-shadow">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">整合界面功能说明</h2>
            <div class="grid md:grid-cols-2 gap-6">
                <div>
                    <h3 class="text-lg font-bold text-blue-600 mb-3">
                        <i class="fas fa-user-check mr-2"></i>用户登录模块
                    </h3>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• 用户身份验证和状态显示</li>
                        <li>• 支持多种登录方式</li>
                        <li>• 在线状态和登出功能</li>
                    </ul>
                </div>
                
                <div>
                    <h3 class="text-lg font-bold text-green-600 mb-3">
                        <i class="fas fa-truck mr-2"></i>车次管理模块
                    </h3>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• 创建和切换不同车次</li>
                        <li>• 实时显示统计数据</li>
                        <li>• 标签页式车次选择</li>
                    </ul>
                </div>
                
                <div>
                    <h3 class="text-lg font-bold text-purple-600 mb-3">
                        <i class="fas fa-image mr-2"></i>图片添加模块
                    </h3>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• 商品图片上传和展示</li>
                        <li>• 图片上数量标注功能</li>
                        <li>• 货号和数量编辑</li>
                    </ul>
                </div>
                
                <div>
                    <h3 class="text-lg font-bold text-indigo-600 mb-3">
                        <i class="fab fa-weixin mr-2"></i>微信截图模块
                    </h3>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• 格式化出货清单生成</li>
                        <li>• 微信消息样式预览</li>
                        <li>• 一键分享和复制功能</li>
                    </ul>
                </div>
                
                <div class="md:col-span-2">
                    <h3 class="text-lg font-bold text-orange-600 mb-3">
                        <i class="fas fa-history mr-2"></i>历史数据模块
                    </h3>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• 所有车次数据自动保存到历史记录</li>
                        <li>• 支持历史数据编辑和查看</li>
                        <li>• 可以为历史记录添加新图片</li>
                        <li>• 货号和数量信息完整保存</li>
                        <li>• 支持历史数据重新分享</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</body>
</html>