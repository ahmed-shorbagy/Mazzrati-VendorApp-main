import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/features/transaction/controllers/transaction_controller.dart';
import 'package:mazzraati_vendor_app/features/transaction/widgets/transaction_widget.dart';

class WalletTransactionListViewWidget extends StatelessWidget {
  final TransactionController? transactionProvider;
  const WalletTransactionListViewWidget({super.key, this.transactionProvider});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactionProvider!.transactionList!.length,
      itemBuilder: (context, index) => TransactionWidget(
          transactionModel: transactionProvider!.transactionList![index]),
    );
  }
}
