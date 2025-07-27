import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'firebase_options.dart'; // 确保这个文件存在并包含您的 Firebase 配置
import 'auth_screen.dart'; // 稍后创建
import 'item_provider.dart'; // 稍后创建

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        redirect: (BuildContext context, GoRouterState state) {
          // 重定向逻辑：如果用户未登录，则重定向到登录页面
          if (FirebaseAuth.instance.currentUser == null) {
            return '/login';
          }
          return '/home';
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return AuthScreen();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen();
        },
      ),
    ],
    // 监听认证状态变化，以便在用户登录/登出时重定向
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  );

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      title: '货物出货计算APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      themeMode: themeProvider.themeMode,
      routerConfig: _router,
    );
  }
}

// 用于 GoRouter 监听 Stream 的辅助类
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// HomeScreen 保持不变，但现在它将从 ItemProvider 获取数据
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context), // 传递 context
            Expanded(
              child: ListView(
                children: [
                  _buildStatsCard(),
                  _buildVehicleSelection(),
                  _buildItemManagement(context), // 传递 context
                  _buildShareSection(context),
                  _buildHistorySection(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face'),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('张师傅', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('出货管理', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('通知按钮被点击！')),
                  );
                },
              );
            }
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.go('/login'); // 登出后重定向到登录页面
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今日出货统计', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('3', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('车次', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    Text('67', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('货品', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    Text('1,258', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('总数量', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('选择车次', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Builder(
                builder: (BuildContext context) {
                  return TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('新建车次按钮被点击！')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('新建车次'),
                  );
                }
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildVehicleChip('第一车 (23)', isSelected: true),
                _buildVehicleChip('第二车 (18)'),
                _buildVehicleChip('第三车 (26)'),
                _buildVehicleChip('+ 新车次', isNew: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleChip(String label, {bool isSelected = false, bool isNew = false}) {
    return Builder(builder: (context) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('选择了车次: $label')),
            );
          },
          backgroundColor: isNew ? const Color(0xFFf8f9fa) : Colors.grey[200],
          selectedColor: Colors.blue,
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isNew ? const BorderSide(color: Colors.grey, width: 2, style: BorderStyle.solid) : BorderSide.none,
          ),
        ),
      );
    });
  }

  Widget _buildItemManagement(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('第一车 - 商品管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('23件商品', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // 添加新商品逻辑
              itemProvider.addItem(Item(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                itemNumber: '新货号',
                quantity: 0,
                imageUrl: 'https://via.placeholder.com/80x64', // 默认图片
              ));
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('点击添加商品图片'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.blue, width: 2, style: BorderStyle.solid),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 使用 Consumer 监听 ItemProvider 的变化
          Consumer<ItemProvider>(
            builder: (context, itemProvider, child) {
              if (itemProvider.items.isEmpty) {
                return const Center(child: Text('暂无商品，点击上方按钮添加'));
              }
              return Column(
                children: itemProvider.items.map((item) {
                  return _buildItemCard(context, item); // 传递 context 和 item
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Item item) {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    TextEditingController quantityController = TextEditingController(text: item.quantity.toString());

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(item.imageUrl, width: 80, height: 64, fit: BoxFit.cover),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('货号: ${item.itemNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('数量:'),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          onChanged: (value) {
                            // 实时更新数量，但只有在失去焦点时才保存到 Firestore
                            item.quantity = int.tryParse(value) ?? 0;
                          },
                          onSubmitted: (value) {
                            // 在用户提交（例如，按下回车键）时保存到 Firestore
                            itemProvider.updateItem(item);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                itemProvider.deleteItem(item.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.save, color: Colors.blue),
              onPressed: () {
                // 显式保存按钮
                itemProvider.updateItem(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('数量已保存！')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('生成分享截图', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!)
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.wechat, color: Colors.green, size: 24),
                    SizedBox(width: 8),
                    Text('第一车出货清单', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('📦 A001: 156件\n📦 A002: 89件\n📦 A003: 211件'),
                const Divider(height: 24, thickness: 1),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('总计: 456件', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('2024-07-26 15:30', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('生成微信截图按钮被点击！')),
                          );
                        },
                        icon: const Icon(Icons.wechat),
                        label: const Text('生成微信截图'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('复制按钮被点击！')),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('历史记录', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('查看全部', style: TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 16),
          _buildHistoryCard('第二车', '2024-07-25 14:30', '18件商品', '322件'),
          _buildHistoryCard('第三车', '2024-07-24 09:15', '26件商品', '480件'),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String title, String dateTime, String itemCount, String totalCount) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(dateTime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(itemCount),
                Text(totalCount, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: '车次',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: '拍照',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: '历史',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('底部导航栏项目 ${index} 被点击！')),
        );
      },
    );
  }
}