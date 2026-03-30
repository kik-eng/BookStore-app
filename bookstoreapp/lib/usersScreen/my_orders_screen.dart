import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controller/order_controller.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatelessWidget {
  final OrderController _orderController = OrderController();

  MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: _orderController.getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            if (snapshot.error.toString().contains("query requires an index")) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Firestore Index is building. Please wait a few minutes or click the link in your console.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                ),
              );
            }
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 15),
                  Text(
                    "No orders found.",
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(context, order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    String displayId = order.orderId.length > 8 
        ? order.orderId.substring(0, 8) 
        : order.orderId;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #$displayId",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a').format(order.orderedAt),
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
          ),
          const Divider(height: 25),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text(
                      "${item['quantity']}x ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF5E5CE6)),
                    ),
                    Expanded(
                      child: Text(
                        item['title'],
                        style: GoogleFonts.poppins(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "Rs. ${item['price']}",
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              Text(
                "Rs. ${order.totalAmount.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5E5CE6),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Shipped':
        color = Colors.blue;
        break;
      case 'Delivered':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}