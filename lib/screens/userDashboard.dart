import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Models/user_attr.dart';
import '../responsive_helper.dart';
import '../user/user_full.dart';

class UserDashboard extends StatefulWidget {
  static const routeName = '/UserDashboard';

  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  late TextEditingController _searchTextController;
  final FocusNode _node = FocusNode();
  late Future future;

  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _node.dispose();
    _searchTextController.dispose();
  }

  List<UserAttr> _searchList = [];

  @override
  Widget build(BuildContext context) {
    var mediaQueryWidth = MediaQuery.of(context).size.width;
    var size;

    if (mediaQueryWidth < 768) {
      size = 1200;
    } else {
      size = mediaQueryWidth - 200;
    }
    // var size = MediaQuery.of(context).size.width - 200;
    var sizeToEachRow = size / 7;

    return Consumer<List<UserAttr>>(builder: (context, usersList, child) {
      return ResponsiveDesign(
          desktop: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Users',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 30,
                color: Colors.grey.shade200,
                child: Row(
                  children: const [
                    SizedBox(
                      width: 5,
                    ),
                    Text('Dashboard / '),
                    Text(
                      'Users',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _searchTextController,
                minLines: 1,
                focusNode: _node,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  hintText: 'Search',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: _searchTextController.text.isEmpty
                        ? null
                        : () {
                            _searchTextController.clear();
                            _node.unfocus();
                          },
                    icon: Icon(FontAwesomeIcons.times,
                        color: _searchTextController.text.isNotEmpty
                            ? Colors.red
                            : Colors.grey),
                  ),
                ),
                onChanged: (value) {
                  _searchTextController.text.toLowerCase();
                  setState(() {
                    _searchList = usersList
                        .where((element) =>
                            element.name!
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            element.email!
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'All Users',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                color: Colors.pink.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'S.No.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'ID',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Name',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Phone Number',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Email',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Joined Date',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Status',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(child: Consumer<List<UserAttr>>(
                  builder: (context, usersList, child) {
                if (usersList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return _searchTextController.text.isEmpty
                    ? ListView.builder(
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          return UserFull(
                            index: (index + 1).toString(),
                            id: usersList[index].id!,
                            name: usersList[index].name!,
                            email: usersList[index].email!,
                            joinedDate: usersList[index].joinedDate!,
                            phoneNumber: '',
                            status: usersList[index].status!,
                          );
                        })
                    : ListView.builder(
                        itemCount: _searchList.length,
                        itemBuilder: (context, index) {
                          return UserFull(
                            index: (index + 1).toString(),
                            id: _searchList[index].id!,
                            name: _searchList[index].name!,
                            email: _searchList[index].email!,
                            joinedDate: _searchList[index].joinedDate!,
                            phoneNumber: '',
                            status: _searchList[index].status!,
                          );
                        });
              })),
            ],
          ),
          mobile: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 1200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Users',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 30,
                      color: Colors.grey.shade200,
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 5,
                          ),
                          Text('Dashboard / '),
                          Text(
                            'Users',
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _searchTextController,
                        minLines: 1,
                        focusNode: _node,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                          ),
                          hintText: 'Search',
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          suffixIcon: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: _searchTextController.text.isEmpty
                                ? null
                                : () {
                                    _searchTextController.clear();
                                    _node.unfocus();
                                  },
                            icon: Icon(FontAwesomeIcons.times,
                                color: _searchTextController.text.isNotEmpty
                                    ? Colors.red
                                    : Colors.grey),
                          ),
                        ),
                        onChanged: (value) {
                          _searchTextController.text.toLowerCase();
                          setState(() {
                            _searchList = usersList
                                .where((element) =>
                                    element.name!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    element.email!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'All Users',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      color: Colors.pink.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'S.No.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'ID',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Name',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Phone Number',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Email',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Joined Date',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Status',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(child: Consumer<List<UserAttr>>(
                        builder: (context, usersList, child) {
                      if (usersList.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return _searchTextController.text.isEmpty
                          ? ListView.builder(
                              itemCount: usersList.length,
                              itemBuilder: (context, index) {
                                return UserFull(
                                  index: (index + 1).toString(),
                                  id: usersList[index].id!,
                                  name: usersList[index].name!,
                                  email: usersList[index].email!,
                                  joinedDate: usersList[index].joinedDate!,
                                  phoneNumber: '',
                                  status: usersList[index].status!,
                                );
                              })
                          : ListView.builder(
                              itemCount: _searchList.length,
                              itemBuilder: (context, index) {
                                return UserFull(
                                  index: (index + 1).toString(),
                                  id: _searchList[index].id!,
                                  name: _searchList[index].name!,
                                  email: _searchList[index].email!,
                                  joinedDate: _searchList[index].joinedDate!,
                                  phoneNumber: '',
                                  status: _searchList[index].status!,
                                );
                              });
                    })),
                  ],
                ),
              )
            ],
          ));
    });
  }
}

class ListCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color color;

  ListCard(
      {required this.title,
      required this.subTitle,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(
          icon,
          color: Colors.white,
        ),
        isThreeLine: false,
      ),
    );
  }
}
