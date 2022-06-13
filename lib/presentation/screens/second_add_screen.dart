// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:general/general.dart';
import 'package:intl/intl.dart';

import 'package:eyyplus/domain/entity/receiptentity.dart';

import '../../domain/entity/productentity.dart';
import '../widgets/customquicksandtext.dart';

class SecondAddScreen extends StatefulWidget {
  final String receipno;
  final String date;
  final String supplier;
  const SecondAddScreen({
    Key? key,
    required this.receipno,
    required this.date,
    required this.supplier,
  }) : super(key: key);

  @override
  State<SecondAddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<SecondAddScreen> {
  final _receipt = TextEditingController();
  final _date = TextEditingController();
  final _supplier = TextEditingController();
  final _product = TextEditingController();
  final _price = TextEditingController();
  final _quantity = TextEditingController();
  final _discount = TextEditingController();
  final _totalp = TextEditingController();
  final _unit = TextEditingController();
  @override
  void initState() {
    _receipt.text = widget.receipno;
    _date.text = widget.date;
    _supplier.text = widget.supplier;
    super.initState();
  }

  List<String> products = [
    'test1',
    'test2',
    'test3',
    'test4',
    'test5',
    'test6',
    'test7',
  ];

  List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(products);
    matches.retainWhere(
        (element) => element.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  // List<ReceiptEntity> searchproduct(String query) {
  //   final suggestions = (widget.receipts ?? []).where((receipt) {
  //     final products = receipt.product.where((product) {
  //       final _product = product.product.toLowerCase();
  //       final input = query.toLowerCase();
  //       print(input);
  //       return _product.contains(input);
  //     }).toList();
  //     return products.isNotEmpty ? true : false;
  //   }).toList();
  //   storage = suggestions;
  //   return storage;
  // }

  int totalquantity = 0;
  double totalprice = 0;
  double _totalprice = 0;
  int totalq = 0;
  int dc = 0;
  double zero = 0;
  var pricekey = GlobalKey<FormState>();
  var quankey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xffBE5108),
          ),
        ),
        title: const CustomQuickSandText(
          text: 'Receipt Detail',
          weight: FontWeight.w700,
          size: 18,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomQuickSandText(text: 'Receipt No.'),
              const SizedBox(height: 15),
              CustomTextField(
                'Receipt No.',
                controller: _receipt,
                color: const Color(0xff58739B).withOpacity(0.40),
                formKey: const ValueKey('Receipt'),
                radius: 0,
              ),
              const SizedBox(height: 15),
              const CustomQuickSandText(text: 'Date'),
              const SizedBox(height: 15),
              CustomTextField(
                'Date',
                controller: _date,
                radius: 0,
                color: const Color(0xff58739B).withOpacity(0.40),
                formKey: const ValueKey('Date'),
                suffix: IconButton(
                    onPressed: () async {
                      DateTime? datetime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2050),
                      );
                      setState(() {
                        _date.text = DateFormat().format(datetime!);
                      });
                    },
                    icon: const Icon(Icons.calendar_today)),
              ),
              const SizedBox(height: 15),
              const CustomQuickSandText(text: 'Supplier Name'),
              const SizedBox(height: 15),
              CustomTextField('Supplier Name',
                  controller: _supplier,
                  formKey: const ValueKey('Supplier'),
                  radius: 0,
                  color: const Color(0xff58739B).withOpacity(0.40),
                  validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                  return 'Enter the correct supplier name';
                } else {
                  return null;
                }
              }),
              const SizedBox(height: 15),
              const HDivider(
                color: Color(0xffBE5108),
                splitter: 50,
                isDot: true,
              ),
              const SizedBox(height: 15),
              const CustomQuickSandText(
                text: 'Add Products',
                weight: FontWeight.w700,
                size: 16,
              ),
              const SizedBox(height: 15),
              const CustomQuickSandText(text: 'Product Name'),
              const SizedBox(height: 15),
              TypeAheadFormField(
                textFieldConfiguration:
                    TextFieldConfiguration(controller: _product),
                onSuggestionSelected: (String? suggestion) {
                  setState(() {
                    _product.text = suggestion!;
                  });
                },
                itemBuilder: (context, String suggestion) {
                  return Text(suggestion);
                },
                suggestionsCallback: (value) {
                  return getSuggestions(value);
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: const [
                  CustomQuickSandText(text: 'Price'),
                  SizedBox(width: 195),
                  CustomQuickSandText(text: 'Total Price')
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      'Price',
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            _totalp.text = '0';
                          } else {
                            _totalp.text = value;
                            _quantity.clear();
                          }
                        });
                      },
                      controller: _price,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the price';
                        } else {
                          return null;
                        }
                      },
                      formKey: pricekey,
                      radius: 0,
                      color: const Color(0xff58739B).withOpacity(0.40),
                      keyboard: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: CustomTextField(
                      'Total Price',
                      controller: _totalp,
                      radius: 0,
                      defaultData: _totalp.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: const [
                  CustomQuickSandText(text: 'Quantity'),
                  SizedBox(width: 170),
                  CustomQuickSandText(text: 'Discount')
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      'Quantity',
                      controller: _quantity,
                      formKey: quankey,
                      radius: 0,
                      color: const Color(0xff58739B).withOpacity(0.40),
                      onChanged: (value) {
                        setState(() {
                          if (pricekey.currentState!.validate()) {
                            if (_quantity.text.isEmpty) {
                              double total = double.parse(_price.text);
                              _totalp.text = NumberFormat.currency(
                                locale: 'fil',
                                symbol: '₱',
                                decimalDigits: 2,
                              ).format(total);
                            } else {
                              double total = double.parse(_price.text) *
                                  int.parse(_quantity.text);
                              _totalp.text = NumberFormat.currency(
                                locale: 'fil',
                                symbol: '₱',
                                decimalDigits: 2,
                              ).format(total);
                            }
                          } else {
                            _quantity.clear();
                          }
                        });
                      },
                      suffix: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CustomText(
                            'x',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      keyboard: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty && _price.text.isNotEmpty) {
                          return 'Please enter the quantity ';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: CustomTextField(
                      'Discount',
                      controller: _discount,
                      formKey: const ValueKey('Discount'),
                      radius: 0,
                      color: const Color(0xff58739B).withOpacity(0.40),
                      onChanged: (value) {
                        setState(() {
                          if (_discount.text.isEmpty) {
                            final multipliedprice = double.parse(_price.text) *
                                int.parse(_quantity.text);
                            _totalp.text = NumberFormat.currency(
                              locale: 'fil',
                              symbol: '₱',
                              decimalDigits: 2,
                            ).format(multipliedprice);
                          } else {
                            final discount = int.parse(_discount.text) / 100;
                            final multipliedprice = double.parse(_price.text) *
                                int.parse(_quantity.text);
                            final discountvalue = multipliedprice * discount;
                            _totalprice = multipliedprice - discountvalue;
                            _totalp.text = NumberFormat.currency(
                              locale: 'fil',
                              symbol: '₱',
                              decimalDigits: 2,
                            ).format(_totalprice);
                          }
                        });
                      },
                      suffix: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CustomText(
                            '%',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      keyboard: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 17,
              ),
              const CustomQuickSandText(text: 'Unit'),
              const SizedBox(
                height: 4,
              ),
              CustomTextField(
                'unit',
                controller: _unit,
                formKey: const ValueKey('Supplier'),
                radius: 0,
                color: const Color(0xff58739B).withOpacity(0.40),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (_product.text.isEmpty ||
                          _price.text.isEmpty ||
                          _quantity.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: CustomQuickSandText(
                              text: 'Please fill up text field',
                            ),
                          ),
                        );
                      }
                      if (_discount.text.isEmpty) {
                        final multipliedprice = double.parse(_price.text) *
                            int.parse(_quantity.text);
                        _totalp.text = NumberFormat.currency(
                          locale: 'fil',
                          symbol: '₱',
                          decimalDigits: 2,
                        ).format(multipliedprice);
                        final product = ProductEntity(
                          product: _product.text,
                          price: double.parse(_price.text),
                          totalprice: multipliedprice,
                          quantity: int.parse(_quantity.text),
                          discount: dc,
                          unit: _unit.text,
                        );

                        _product.clear();
                        _price.clear();
                        _quantity.clear();
                        _discount.clear();
                        _totalp.clear();
                        setState(() {});

                        Navigator.pop(
                          context,
                          product,
                        );
                      } else {
                        final discount = int.parse(_discount.text) / 100;
                        final multipliedprice = double.parse(_price.text) *
                            int.parse(_quantity.text);
                        final discountvalue = multipliedprice * discount;
                        _totalprice = multipliedprice - discountvalue;

                        final product = ProductEntity(
                          product: _product.text,
                          price: double.parse(_price.text),
                          totalprice: _totalprice,
                          quantity: int.parse(_quantity.text),
                          discount: int.parse(_discount.text),
                          unit: _unit.text,
                        );

                        _product.clear();
                        _price.clear();
                        _quantity.clear();
                        _discount.clear();
                        _totalp.clear();

                        setState(() {});

                        Navigator.pop(
                          context,
                          product,
                        );
                      }
                    },
                    child: Container(
                      height: 41,
                      width: 362,
                      color: const Color(0xff58739B),
                      child: const Center(
                        child: CustomQuickSandText(
                          text: 'ADD THIS TO RECEIPT',
                          weight: FontWeight.w700,
                          size: 16,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
