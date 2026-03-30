import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Controller/order_controller.dart';
import '../models/order_model.dart';

class AdminOrdersScreen extends StatelessWidget {
  final OrderController _orderController = OrderController();

  AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      appBar: AppBar(
        title: Text(
          "Manage Orders",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: _orderController.getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: GoogleFonts.poppins(color: Colors.red)));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 15),
                  Text("No orders placed yet.", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildAdminOrderCard(context, order);
            },
          );
        },
      ),
    );
  }

  Widget _buildAdminOrderCard(BuildContext context, OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer: ${order.userName}",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    "Order ID: #${order.orderId.substring(0, 8)}",
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          const Divider(height: 30),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF5E5CE6).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text("${item['quantity']}x", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF5E5CE6), fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item['title'], style: GoogleFonts.poppins(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              )),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Amount", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                  Text("Rs. ${order.totalAmount}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF5E5CE6), fontSize: 18)),
                ],
              ),
              _buildStatusPicker(context, order),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Expanded(child: Text(order.address, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          Text(DateFormat('dd MMM yyyy, hh:mm a').format(order.orderedAt), style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildStatusPicker(BuildContext context, OrderModel order) {
    return PopupMenuButton<String>(
      onSelected: (String newStatus) {
        _orderController.updateOrderStatus(order.orderId, newStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order status updated to $newStatus"), backgroundColor: Colors.green),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(value: 'Pending', child: Text('Pending')),
        const PopupMenuItem<String>(value: 'Shipped', child: Text('Shipped')),
        const PopupMenuItem<String>(value: 'Delivered', child: Text('Delivered')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF5E5CE6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text("Update Status", style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Pending': color = Colors.orange; break;
      case 'Shipped': color = Colors.blue; break;
      case 'Delivered': color = Colors.green; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: GoogleFonts.poppins(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
