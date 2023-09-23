import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk_farm/add_customer.dart';

class CustomersWidget extends StatefulWidget {
  const CustomersWidget({super.key});

  @override
  State<CustomersWidget> createState() => _CustomersWidgetState();
}

class _CustomersWidgetState extends State<CustomersWidget> {
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  List<QueryDocumentSnapshot> list = [];

  List<QueryDocumentSnapshot> filteredList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10), () {
      FirebaseFirestore.instance.collection('customer').get().then((data) {
        setState(() {
          list = data.docs;
          filteredList = data.docs;
        });
      });
    });

    _searchQueryController.addListener(() {
      final searchText = _searchQueryController.text;
      if (searchText.isEmpty) {
        setState(() {
          filteredList = list;
        });
      } else {
        setState(() {
          filteredList = list
              .where((data) => data['name']
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
      body: ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (ctx, index) =>
              getCustomerData(filteredList[index], index + 1)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCustomer()))
        },
      ),
    );
  }

  Widget getCustomerData(QueryDocumentSnapshot<Object?>? doc, int index) {
    return Column(
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
                    visible: doc?['name'] != null,
                    child: Text(doc?['name']),
                  ),
                  Visibility(
                    visible: doc?['phoneNumber'] != null,
                    child: Text(doc?['phoneNumber']),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Visibility(
            visible: doc?['description'] != null &&
                doc!['description'].toString().isNotEmpty,
            child: Text(
              doc?['description'],
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
}

final colors = [
  Colors.purple,
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.amber,
  Colors.blueGrey
];
