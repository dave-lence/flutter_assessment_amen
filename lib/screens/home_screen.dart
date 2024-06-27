import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_developer_assessment/model/product_model.dart';
import 'package:flutter_developer_assessment/utils/custom_colloer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> products = [];
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();
  }

  Future<List<ProductModel>> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');

    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse(
              'https://central-backend-e6ln.onrender.com/api/devtest/products'),
          headers: {
            'x-access-token': token,
          },
        );

        if (response.statusCode == 200) {
          // print(responseData);
          List<dynamic> jsonData = jsonDecode(response.body);
          return jsonData.map((item) => ProductModel.fromJson(item)).toList();
        } else {
          print('Response: ${response.body}');
          return [];
        }
      } else {
        return [];
      }
    } on SocketException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
              content: const Text('No network connection...'),
            );
          });
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor().customWhite,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Hey User,',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CustomColor().customBalck,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future:
                                fetchProducts(), // Ensure this is called in initState or elsewhere before build
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(color: CustomColor().customGreen,));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No products found'));
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    final product = snapshot.data![0];
                                    return Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                product.images.first,
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.95,
                                                height: 240,
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    CustomColor().customBalck),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(product.description),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '\$ ${product.price.toString()}',
                                            style: TextStyle(
                                                color:
                                                    CustomColor().customGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                         Text('Trending',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CustomColor().customBalck,
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        LayoutBuilder(builder: (context, constraint) {
                          return FutureBuilder(
                              future:
                                  fetchProducts(), // Ensure this is called in initState or elsewhere before build
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      heightFactor: 7.5,
                                      child: CircularProgressIndicator(color: CustomColor().customGreen));
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text('No products found'));
                                } else {
                                  return Container(
                                    height: 200,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          snapshot.data!.length,
                                          (index) {
                                            final product = snapshot.data![index];
                                            return Container(
                                              width: 110,
                                              margin: const EdgeInsets.only(
                                                  right: 10, top: 10),
                                              
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    child: Image.network(
                                                      product.images[1],
                                                      fit: BoxFit.cover,
                                                      width: 110,
                                                      height: 110,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    product.name,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '\$ ${product.price.toString()}',
                                                    style: TextStyle(
                                                      color: CustomColor()
                                                          .customGreen,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                        })
                      ],
                    )))));
  }
}
