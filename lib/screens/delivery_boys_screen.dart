import 'package:admin_panel_ecommerce/Models/delivery_boys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widegt/delivery_boys_widget.dart';

class DeliveryBoyScreen extends StatefulWidget {
  const DeliveryBoyScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryBoyScreen> createState() => _DeliveryBoyScreenState();
}

class _DeliveryBoyScreenState extends State<DeliveryBoyScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<List<DeliveryBoy>>(builder: (context, deliveryBoys, child) {
      if (deliveryBoys.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ListView.builder(
          itemCount: deliveryBoys.length,
          itemBuilder: (context, index) {
            return DeliveryBoyWidget(
              name: deliveryBoys[index].name!,
              mobile: deliveryBoys[index].mobile!,
              uid: deliveryBoys[index].uid!,
              address: deliveryBoys[index].address!,
              appliedTime: deliveryBoys[index].appliedTime!,
              isVerified: deliveryBoys[index].isVerified!,
              email: deliveryBoys[index].email!,
              index: (index + 1).toString(),
            );
          });
    });
  }
}
