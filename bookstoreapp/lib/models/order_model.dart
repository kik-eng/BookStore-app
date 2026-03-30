import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String userName;
  final String address;
  final String phone;
  final String status; // Pending, Shipped, Delivered
  final DateTime orderedAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.userName,
    required this.address,
    required this.phone,
    required this.status,
    required this.orderedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'userName': userName,
      'address': address,
      'phone': phone,
      'status': status,
      'orderedAt': orderedAt,
    };
  }

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      orderId: id,
      userId: data['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      userName: data['userName'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      status: data['status'] ?? 'Pending',
      orderedAt: (data['orderedAt'] as Timestamp).toDate(),
    );
  }
}