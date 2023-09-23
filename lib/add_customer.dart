import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:uuid/uuid.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phNoController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? phoneNumberError;
  String? nameError;

  @override
  void initState() {
    super.initState();
    FlutterContactPicker.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Customer"),
        actions: [
          GestureDetector(
            onTap: () {
              FlutterContactPicker.pickPhoneContact(askForPermission: true)
                  .then((data) {
                nameController.text = data.fullName ?? nameController.text;
                phNoController.text =
                    (data.phoneNumber?.number ?? phNoController.text)
                        .replaceAll(" ", "")
                        .replaceAll("-", "");
              });
            },
            child: Row(
              children: [
                Icon(
                  Icons.contacts_rounded,
                  color: Colors.purple.shade600,
                ),
                const Text(
                  "Select Contact",
                  style: TextStyle(color: Colors.purple),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintStyle: const TextStyle(),
                    hintText: "Enter your name",
                    errorText: nameError,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: phNoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintStyle: const TextStyle(),
                    hintText: "Phone Number",
                    errorText: phoneNumberError,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                maxLines: 5,
                minLines: 1,
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(),
                    hintText: "Description",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Colors.purple.shade700),
                  onPressed: _addCustomer,
                  child: const Text(
                    "Add Customer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _addCustomer() {
    if (phNoController.text.length < 10) {
      setState(() {
        phoneNumberError = "Enter Phone Number";
      });
      return;
    }
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = "Enter Name";
      });
      return;
    }
    setState(() {
      phoneNumberError = nameError = null;
    });
    String phoneNumber = phNoController.text;
    if (!phoneNumber.startsWith("+91")) {
      phoneNumber = "+91$phoneNumber";
    }
    Customer customer = Customer(nameController.text, phoneNumber,
        const Uuid().v1(), descriptionController.text);
    FirebaseFirestore.instance
        .collection("customer")
        .doc(customer.uuId)
        .set(customer.toJson())
        .then((data) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Customer Added")));
    }).catchError((err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err?.toString() ?? "Error")));
    });
    _clearValues();
  }

  void _clearValues() {
    setState(() {
      phNoController.clear();
      nameController.clear();
      descriptionController.clear();
    });
  }
}
