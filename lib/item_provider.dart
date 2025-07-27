import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id;
  String itemNumber;
  int quantity;
  String imageUrl;

  Item({
    required this.id,
    required this.itemNumber,
    required this.quantity,
    required this.imageUrl,
  });

  // 从 Firestore 文档创建 Item 对象
  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      itemNumber: data['itemNumber'] ?? '',
      quantity: data['quantity'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // 将 Item 对象转换为 Map，以便存储到 Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'itemNumber': itemNumber,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

class ItemProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Item> _items = [];

  List<Item> get items => _items;

  ItemProvider() {
    _fetchItems(); // 初始化时获取商品数据
  }

  // 从 Firestore 获取商品数据
  void _fetchItems() {
    _firestore.collection('items').snapshots().listen((snapshot) {
      _items = snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
      notifyListeners();
    });
  }

  // 添加新商品
  Future<void> addItem(Item item) async {
    await _firestore.collection('items').add(item.toFirestore());
  }

  // 更新商品
  Future<void> updateItem(Item item) async {
    await _firestore.collection('items').doc(item.id).update(item.toFirestore());
  }

  // 删除商品
  Future<void> deleteItem(String id) async {
    await _firestore.collection('items').doc(id).delete();
  }
}
