import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:milk_farm/common/ui/counter_field.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:milk_farm/supabase_helper.dart';
import 'package:uuid/uuid.dart';

class AddCustomer extends StatefulWidget {
  final Customer? customer;

  const AddCustomer({super.key, this.customer});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phNoController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController morningLitresController =
      TextEditingController(text: (0.0).toStringAsFixed(2));
  final TextEditingController eveningLitresController =
      TextEditingController(text: (0.0).toStringAsFixed(2));

  String? phoneNumberError;
  String? nameError;

  String? morningLitresError;
  String? eveningLitresError;

  bool isUpdateUserFlow = false;

  @override
  void initState() {
    super.initState();
    FlutterContactPicker.requestPermission();
    final customer = widget.customer;
    if (customer != null) {
      isUpdateUserFlow = true;
      nameController.text = customer.name;
      phNoController.text = customer.phoneNumber;
      descriptionController.text = customer.description;
      morningLitresController.text = customer.morningLtrsPref.toString();
      eveningLitresController.text = customer.eveningLtrsPref.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phNoController.dispose();
    descriptionController.dispose();
    morningLitresController.dispose();
    eveningLitresController.dispose();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      hintText: "Description(Optional)",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text("Preferences"),
                ),
                const SizedBox(
                  height: 30,
                ),
                CounterTextField(
                  label: "Morning Litres",
                  initialValue: 0.0,
                  textEditingController: morningLitresController,
                  errorText: morningLitresError,
                ),
                const SizedBox(
                  height: 20,
                ),
                CounterTextField(
                  label: "Evening Litres",
                  initialValue: 0.0,
                  textEditingController: eveningLitresController,
                  errorText: eveningLitresError,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, backgroundColor: Colors.purple.shade700),
                    onPressed: _addOrUpdateCustomer,
                    child: Text(
                      (isUpdateUserFlow == false)
                          ? "Add Customer"
                          : "Update Customer",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addOrUpdateCustomer() {
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
    if (!isValidDecimal(morningLitresController.text)) {
      setState(() {
        morningLitresError = "Enter Valid Number";
      });
      return;
    }
    setState(() {
      morningLitresError = null;
    });
    if (!isValidDecimal(eveningLitresController.text)) {
      setState(() {
        eveningLitresError = "Enter Valid Number";
      });
      return;
    }
    setState(() {
      eveningLitresError = null;
    });

    Customer customer = Customer(
        nameController.text,
        phoneNumber,
        const Uuid().v1(),
        descriptionController.text,
        double.parse(morningLitresController.text.toString()),
        double.parse(eveningLitresController.text.toString()),
        AccountStatus.active);
    if (widget.customer != null) {
      customer.uuId == widget.customer?.uuId;
    }
    SupabaseHelper.addCustomer(customer).then((data) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text((isUpdateUserFlow)
              ? "Customer Updated"
              : "Customer Added")));
      if(!isUpdateUserFlow) {
        _clearValues();
      }
    }).catchError((err,stackTrace) {
      print(err.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error Occurred")));
    });

  }

  void _clearValues() {
    setState(() {
      phNoController.clear();
      nameController.clear();
      descriptionController.clear();
      morningLitresController.clear();
      eveningLitresController.clear();
    });
  }

  bool isValidDecimal(String input) {
    if (input.isEmpty) {
      return false;
    }
    final regex = RegExp(r'^\d+(\.\d+)?$');
    return regex.hasMatch(input) && double.parse(input) >= 0;
  }
}
