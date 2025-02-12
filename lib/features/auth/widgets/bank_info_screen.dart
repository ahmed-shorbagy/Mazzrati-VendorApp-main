import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';

class BankEditingScreen extends StatefulWidget {
  const BankEditingScreen({super.key});

  @override
  BankEditingScreenState createState() => BankEditingScreenState();
}

class BankEditingScreenState extends State<BankEditingScreen> {
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  final FocusNode _bankNameNode = FocusNode();
  final FocusNode _branchNode = FocusNode();
  final FocusNode _holderNameNode = FocusNode();
  final FocusNode _accountNode = FocusNode();

  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();

  @override
  void dispose() {
    _bankNameController.dispose();
    _branchController.dispose();
    _holderNameController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  void _updateUserAccount() async {
    String bankName = _bankNameController.text.trim();
    String branchName = _branchController.text.trim();
    String holderName = _holderNameController.text.trim();
    String accountNo = _accountController.text.trim();

    if (bankName.isEmpty ||
        branchName.isEmpty ||
        holderName.isEmpty ||
        accountNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields."),
            backgroundColor: Colors.red),
      );
    } else {
      // await Provider.of<AuthController>(context, listen: false).updateBankInfo(
      //   bankName: bankName,
      //   branchName: branchName,
      //   holderName: holderName,
      //   accountNo: accountNo,
      // );

      // On success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Account Updated Successfully!"),
            backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyLogin,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              // Holder Name
              const Text('Holder Name',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _holderNameController,
                focusNode: _holderNameNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Mr. John',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_bankNameNode);
                },
              ),
              const SizedBox(height: 16),

              // Bank Name
              const Text('Bank Name',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bankNameController,
                focusNode: _bankNameNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Bank Name',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_branchNode);
                },
              ),
              const SizedBox(height: 16),

              // Branch Name
              const Text('Branch Name',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _branchController,
                focusNode: _branchNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Branch Name',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_accountNode);
                },
              ),
              const SizedBox(height: 16),

              // Account No
              const Text('Account No',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _accountController,
                      focusNode: _accountNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '',
                          labelText: "SA"),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: _accountController,
                      focusNode: _accountNode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Account No',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Save Button
              Consumer<AuthController>(
                builder: (context, authController, child) {
                  return authController.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: _updateUserAccount,
                          child: const Text('Save'),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
