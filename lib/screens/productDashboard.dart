import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Models/product_attr.dart';
import '../product/product_full.dart';
import '../responsive_helper.dart';
import './upload_product_form.dart';

class ProductDashboard extends StatefulWidget {
  static const routeName = '/productDashboard';

  @override
  State<ProductDashboard> createState() => _ProductDashboardState();
}

class _ProductDashboardState extends State<ProductDashboard> {
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

  List<ProductAttr> _productsList = [];

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
    var sizeToEachRow = size / 13;

    return Consumer<List<ProductAttr>>(builder: (context, products, child) {
      if (products.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return ResponsiveDesign(
          desktop: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Products',
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
                      'Products',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, UploadProductForm.routeName);
                },
                child: const Text(
                  'Upload Product',
                  style: TextStyle(fontSize: 14, color: Colors.white),
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
                      onPressed: _searchTextController.text.isEmpty
                          ? null
                          : () {
                              _searchTextController.clear();
                              _node.unfocus();
                            },
                      icon: Icon(Icons.close,
                          color: _searchTextController.text.isNotEmpty
                              ? Colors.red
                              : Colors.grey),
                    ),
                  ),
                  onChanged: (value) {
                    _searchTextController.text.toLowerCase();
                    setState(() {
                      _productsList = products
                          .where((element) => element.title
                              .toString()
                              .toLowerCase()
                              .contains(
                                  _searchTextController.text.toLowerCase()))
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
                        'All Products',
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
                        'Product Id',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Product Name',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Description',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Price',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Cutted Price',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Image',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Product Category',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Unit Amount',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'isPopular',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Percent Off',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'inStock',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Action',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                  child: _searchTextController.text.isEmpty
                      ? ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ProductFull(
                              index: (index + 1).toString(),
                              id: products[index].id!,
                              title: products[index].title!,
                              description: products[index].description!,
                              price: products[index].price!,
                              cuttedPrice: products[index].cuttedPrice!,
                              imageUrl: products[index].imageUrl!,
                              productCategoryName:
                                  products[index].productCategoryName!,
                              unitAmount: products[index].unitAmount!,
                              percentOff: products[index].percentOff!,
                              isPopular: products[index].isPopular!,
                              inStock: products[index].inStock!,
                            );
                          })
                      : ListView.builder(
                          itemCount: _productsList.length,
                          itemBuilder: (context, index) {
                            return ProductFull(
                              index: (index + 1).toString(),
                              id: _productsList[index].id!,
                              title: _productsList[index].title!,
                              description: _productsList[index].description!,
                              price: _productsList[index].price!,
                              cuttedPrice: _productsList[index].cuttedPrice!,
                              imageUrl: _productsList[index].imageUrl!,
                              productCategoryName:
                                  _productsList[index].productCategoryName!,
                              unitAmount: _productsList[index].unitAmount!,
                              percentOff: _productsList[index].percentOff!,
                              isPopular: _productsList[index].isPopular!,
                              inStock: _productsList[index].inStock!,
                            );
                          })),
            ],
          ),
          mobile: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                width: 1200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Products',
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
                            'Products',
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, UploadProductForm.routeName);
                      },
                      child: const Text(
                        'Upload Product',
                        style: TextStyle(fontSize: 14, color: Colors.white),
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
                            onPressed: _searchTextController.text.isEmpty
                                ? null
                                : () {
                                    _searchTextController.clear();
                                    _node.unfocus();
                                  },
                            icon: Icon(Icons.close,
                                color: _searchTextController.text.isNotEmpty
                                    ? Colors.red
                                    : Colors.grey),
                          ),
                        ),
                        onChanged: (value) {
                          _searchTextController.text.toLowerCase();
                          setState(() {
                            _productsList = products
                                .where((element) => element.title
                                    .toString()
                                    .toLowerCase()
                                    .contains(_searchTextController.text
                                        .toLowerCase()))
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
                              'All Products',
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
                              'Product Id',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Product Name',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Description',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Price',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Cutted Price',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Image',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Product Category',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Unit Amount',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'isPopular',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Percent Off',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'inStock',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Action',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                        child: _searchTextController.text.isEmpty
                            ? ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return ProductFull(
                                    index: (index + 1).toString(),
                                    id: products[index].id!,
                                    title: products[index].title!,
                                    description: products[index].description!,
                                    price: products[index].price!,
                                    cuttedPrice: products[index].cuttedPrice!,
                                    imageUrl: products[index].imageUrl!,
                                    productCategoryName:
                                        products[index].productCategoryName!,
                                    unitAmount: products[index].unitAmount!,
                                    percentOff: products[index].percentOff!,
                                    isPopular: products[index].isPopular!,
                                    inStock: products[index].inStock!,
                                  );
                                })
                            : ListView.builder(
                                itemCount: _productsList.length,
                                itemBuilder: (context, index) {
                                  return ProductFull(
                                    index: (index + 1).toString(),
                                    id: _productsList[index].id!,
                                    title: _productsList[index].title!,
                                    description:
                                        _productsList[index].description!,
                                    price: _productsList[index].price!,
                                    cuttedPrice:
                                        _productsList[index].cuttedPrice!,
                                    imageUrl: _productsList[index].imageUrl!,
                                    productCategoryName: _productsList[index]
                                        .productCategoryName!,
                                    unitAmount:
                                        _productsList[index].unitAmount!,
                                    percentOff:
                                        _productsList[index].percentOff!,
                                    isPopular: _productsList[index].isPopular!,
                                    inStock: _productsList[index].inStock!,
                                  );
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
