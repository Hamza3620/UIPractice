import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout_widgets/bloc/invoice_bloc.dart';
import 'package:layout_widgets/bloc/invoice_events.dart';
import 'package:layout_widgets/bloc/invoice_states.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Invoice Details",
            style: TextStyle(color: Colors.black),
          )),
      body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: BlocBuilder<InvoiceBloc, InvoiceStates>(
            builder: (context, state) {
              if (state is Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is Idle) {
                return ListView(
                  children: [
                    statusCard(),
                    invoiceDetailsCard(),
                    contactDetailsCard()
                  ],
                );
              }

              return Container();
            },
          )),
    );
  }

  Container contactDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Color(0xff141937F1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            contactDetailTextWidget("""123
Street 2
Lisbon, Portugal"""),
            contactDetailTextWidget("Phone: +1 234 567 890"),
            contactDetailTextWidget("Email: someone@example.com"),
            contactDetailTextWidget("ABN: 112 789 6534"),
          ],
        ),
      ),
    );
  }

  contactDetailTextWidget(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.black, fontSize: 16),
    );
  }

  Card invoiceDetailsCard() {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/iTrust.png',
                    scale: 0.75,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    scale: 0.9,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Due: 25-10-2022',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(
                    'Issued: 04-10-2022',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              )
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16, 0, 8.0),
              child: RichText(
                  text: TextSpan(
                      text: 'To: ',
                      style: TextStyle(color: Colors.black),
                      children: [
                    TextSpan(
                        text: 'Clark Inc.',
                        style: TextStyle(color: Color(0xff1937F1)))
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Items",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount:
                    BlocProvider.of<InvoiceBloc>(context).getItems.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(
                        "${BlocProvider.of<InvoiceBloc>(context).getItems[index].name}",
                        style: TextStyle(color: Colors.black)),
                    subtitle: Text(
                      "${BlocProvider.of<InvoiceBloc>(context).getItems[index].count}X",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      "\$${BlocProvider.of<InvoiceBloc>(context).getItems[index].price}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  );
                })),
            Stack(
              alignment: Alignment.center,
              children: [
                BlocProvider.of<InvoiceBloc>(context).getPaidValue
                    ? Image.asset("assets/paid.png")
                    : Container(),
                Column(
                  children: [
                    checkoutTextWidget("Subtotal",
                        BlocProvider.of<InvoiceBloc>(context).getSubtotal),
                    checkoutTextWidget("Commission(10%)",
                        BlocProvider.of<InvoiceBloc>(context).getCommission),
                    checkoutTextWidget("GST(10%)",
                        BlocProvider.of<InvoiceBloc>(context).getGst),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("\$${BlocProvider.of<InvoiceBloc>(context).getTotal}")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  checkoutTextWidget(String title, double value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text("\$$value")],
      ),
    );
  }

  Card statusCard() {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "INV_0123",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color:
                            BlocProvider.of<InvoiceBloc>(context).getPaidValue
                                ? Color(0xff00A699)
                                : Color(0xffF38752),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      BlocProvider.of<InvoiceBloc>(context).getPaidValue
                          ? "Paid"
                          : "Overdue",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                myIconButton(
                    BlocProvider.of<InvoiceBloc>(context).getPaidValue
                        ? "assets/cross.png"
                        : "assets/mark.png",
                    BlocProvider.of<InvoiceBloc>(context).getPaidValue
                        ? "Mark as unpaid"
                        : "Mark as Paid", () {
                  BlocProvider.of<InvoiceBloc>(context).add(TogglePaidValue());
                }),
                myIconButton("assets/print.png", "Print", () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (dialogContext) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10.0,
                            sigmaY: 10.0,
                          ),
                          child: AlertDialog(
                            title: Text("Printing"),
                            content: ListTile(
                              title: Text(
                                  '\$${BlocProvider.of<InvoiceBloc>(context).getTotal}'),
                              subtitle: Text("Your Invoice Total"),
                              trailing: Icon(Icons.print),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Ok"))
                            ],
                          ),
                        );
                      });
                }),
                myIconButton("assets/edit.png", "Edit invoice", () {}),
              ],
            )
          ],
        ),
      ),
    );
  }

  myIconButton(String iconName, String text, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Image.asset(iconName),
            SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: TextStyle(color: Color(0xff1937F1)),
            )
          ],
        ),
      ),
    );
  }
}
