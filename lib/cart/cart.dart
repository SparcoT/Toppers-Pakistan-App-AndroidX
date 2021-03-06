import 'package:flutter/material.dart';
import 'package:topperspakistan/cart/selectDeliveryAddress.dart';
import 'package:topperspakistan/cart_list.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  TextEditingController instructionController = new TextEditingController();

  void selectDelivery() {
    CartList.instruction = instructionController.text;
    CartList.totalPrice = calcTotal();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SelectDeliveryAddress()));
  }

  int calcTotal() {
    int total = 0;
    if (CartList.getItems() != null) {
      for (var i = 0; i < CartList.getItems().length; i++) {
        print("This=>" + CartList.getItems()[i].unitPrice.toString());
        print("Me: " + CartList.getItems()[i].unitPrice.toString());
        total += CartList.getItems()[i].quantity *
            int.parse(CartList.getItems()[i].unitPrice);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CART",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Image.asset('images/LogoTrans.png'),
            iconSize: 80.0,
            onPressed: null,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "ITEMS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "QTY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        "PRICE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                var items = CartList.getItems();
                return Dismissible(
                  onDismissed: (direction) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("${items[i].name} Dissmised")));
                    setState(() {
                      CartList.removeFromCart(i);
                      if (CartList.getItems().length == 0) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[Icon(Icons.delete), Text("Delete")],
                      ),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: ListTile(
                                subtitle: Text(
                                  "(" +
                                      items[i].weight +
                                      " " +
                                      items[i].unit +
                                      " " +
                                      items[i].unitPrice +
                                      ")",
                                ),
                                title: Text(
                                  items[i].name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                    icon:
                                        Icon(Icons.remove, color: Colors.black),
                                    onPressed: () {
                                      if (items[i].quantity > 0) {
                                        setState(() {
                                          items[i].quantity--;
                                        });
                                      }
                                    }),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(items[i].quantity.toString()),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      items[i].quantity++;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
                              child: Text(
                                  (int.parse(items[i].unitPrice) *
                                          items[i].quantity)
                                      .toString(),
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 0,
                      )
                    ],
                  ),
                );
              },
              childCount: CartList.getItems().length,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  trailing: Text(
                    calcTotal().toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Container(
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: instructionController,
                      decoration: InputDecoration(
                        hintText: "Additional Instructions",
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                    ),
                  ),
                ),
                Divider(
                  height: 5,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 15,
                    child: RaisedButton(
                      color: Color(0xffCE862A),
                      onPressed: selectDelivery,
                      child: Text(
                        "Select Delivery Address",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
