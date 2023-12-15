import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_farm/add_customer.dart';
import 'package:milk_farm/extensions.dart';
import 'package:milk_farm/isar_manager.dart';
import 'package:milk_farm/model/customer.dart';
import 'package:milk_farm/supabase_helper.dart';

class CustomersWidget extends ConsumerStatefulWidget {
  final bool selectCustomer;
  final Function? selectCallback;

  const CustomersWidget(
      {super.key, this.selectCustomer = false, this.selectCallback});

  @override
  ConsumerState<CustomersWidget> createState() => _CustomersWidgetState();
}

class _CustomersWidgetState extends ConsumerState<CustomersWidget> {
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  List<Customer> list = [];

  List<Customer> filteredList = [];

  List<String> categories = [
    "Active",
    "InActive",
    "All",
  ];

  int selectedCategoryPos = 0;

  @override
  void initState() {
    super.initState();
    refreshData();
    _searchQueryController.addListener(() {
      final searchText = _searchQueryController.text;
      if (searchText.isEmpty) {
        setState(() {
          filteredList = list;
        });
      } else {
        setState(() {
          filteredList = list
              .where((data) => data.name
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : const Text("Customers"),
        leading: BackButton(onPressed: () {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
            });
            return;
          }
          Navigator.pop(context);
        }),
        actions: _buildActions(),
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 6,
            children: categories.map((element) {
              return ChoiceChip(
                label: Text(element),
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                selected: categories[selectedCategoryPos] == element,
                color: MaterialStateColor.resolveWith((states) {
                  // If the button is pressed, return green, otherwise blue
                  if (states.contains(MaterialState.selected)) {
                    return Colors.purpleAccent.shade700;
                  }
                  return Colors.black54;
                }),
                checkmarkColor: Colors.white,
                onSelected: (bool selected) {
                  setState(() {
                    selectedCategoryPos = categories.indexOf(element);
                    updateFilteredData();
                  });
                },
                labelStyle: const TextStyle(color: Colors.white),
              );
            }).toList(),
          ),
          Flexible(
            child: RefreshIndicator(
              displacement: 100,
              backgroundColor: Colors.purple,
              color: Colors.white,
              strokeWidth: 3,
              onRefresh: () async {
                try {
                  SupabaseHelper.fetchAndUpdateCustomers();
                  IsarManager.getCustomers().then((value) {
                    updateCustomers(value);
                  });
                  return;
                } catch (e) {
                  IsarManager.getCustomers().then((value) {
                    updateCustomers(value);
                  });
                  return;
                }
              },
              child: (filteredList.isEmpty)
                  ? const Center(
                child: Text("No Data Found ...",style: TextStyle(
                  fontSize: 18
                ),),
              )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (ctx, index) =>
                              getCustomerData(filteredList[index], index + 1)),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !widget.selectCustomer,
        child: FloatingActionButton(
          child: const Icon(Icons.add_rounded),
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const AddCustomer()))
          },
        ),
      ),
    );
  }

  Widget getCustomerData(Customer customer, int index) {
    return GestureDetector(
      onTap: (widget.selectCallback != null)
          ? () {
              widget.selectCallback?.call(customer);
              Navigator.pop(context);
            }
          : () {
              showOptionBottomSheet(customer);
            },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors[index % 6],
                      ),
                      child: Center(
                          child: Text(
                        index.toString(),
                        style: const TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: customer.name.isNotEmpty,
                      child: Text(customer.name),
                    ),
                    Visibility(
                      visible: customer.phoneNumber.isNotEmpty,
                      child: Text(customer.phoneNumber),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Visibility(
              visible: customer.description.toString().isNotEmpty &&
                  !widget.selectCustomer,
              child: Text(
                customer.description,
                maxLines: 3,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.grey, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController.text.isEmpty) {
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  void showOptionBottomSheet(Customer customer) {
    showModalBottomSheet(
        context: context,
        builder: (mContext) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddCustomer(customer: customer);
                    }));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.edit),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Edit",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                if (customer.status == AccountStatus.active)
                  GestureDetector(
                    onTap: () {
                      Customer updatedCustomer = customer
                        ..status = AccountStatus.inactive;
                      Navigator.pop(mContext);
                      onStatusChanged(updatedCustomer);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.cancel_presentation_rounded),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Mark As InActive",
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      Customer updatedCustomer = customer
                        ..status = AccountStatus.active;
                      Navigator.pop(mContext);
                      onStatusChanged(updatedCustomer);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.add_card_rounded),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Mark As Active", style: TextStyle(fontSize: 20))
                        ],
                      ),
                    ),
                  )
              ],
            ),
          );
        });
  }

  void updateCustomers(List<Customer>? value) {
    setState(() {
      list = value ?? [];
      filteredList = value ?? [];
      updateFilteredData();
    });
  }

  void updateFilteredData() {
    if (selectedCategoryPos == 2) {
      filteredList = list;
    } else {
      filteredList = list
          .where((e) =>
              categories[selectedCategoryPos].toLowerCase() == e.status.name)
          .toList();
    }
  }

  void refreshData() {
    IsarManager.getCustomers().then((value) {
      setState(() {
        list = value ?? [];
        updateFilteredData();
      });
    });
  }

  void onStatusChanged(Customer updatedCustomer) {
    SupabaseHelper.addCustomer(updatedCustomer).then((data) {
      context.showSnackBar("Success");
      IsarManager.addCustomer(updatedCustomer).then((data) {
        refreshData();
      });
    }).catchError((err) {
      context.showSnackBar("Error");
    });
  }
}

final colors = [
  Colors.purple,
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.amber,
  Colors.blueGrey
];
