import 'package:flutter/material.dart';
import 'package:topperspakistan/models/sale-order-item_model.dart';
import 'package:topperspakistan/models/sale-order.dart';
import 'package:topperspakistan/orderhistory.dart/reorder.dart';
import 'package:topperspakistan/services/sale-order-item_service.dart';
import 'package:topperspakistan/simple-future-builder.dart';

class OrderStatus extends StatefulWidget {
  final SaleOrder orderModel;

  OrderStatus({this.orderModel});

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus>
    with TickerProviderStateMixin {
  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Status",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Image.asset('images/ApnaStore.png'),
            iconSize: 80.0,
            onPressed: null,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10)),
          new Container(
            decoration: new BoxDecoration(
              color: Color(0xffbc282b),
            ),
            child: new TabBar(
              indicator: BoxDecoration(
                color: Color(0xffCE862A),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.pink,
              controller: _tabController,
              tabs: [
                new Tab(
                  child: Text(
                    'Shopping Cart',
                    // textScaleFactor: 1.2,
                  ),
                ),
                new Tab(
                  child: Text(
                    'Order Completed',
                    // textScaleFactor: 1.2,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Order1(orderModel: widget.orderModel),
                Status(orderModel: widget.orderModel),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Order1 extends StatefulWidget {
  final SaleOrder orderModel;

  Order1({this.orderModel});
  @override
  _Order1State createState() => _Order1State();
}

class _Order1State extends State<Order1> {
  // _parseDate(DateTime date) {
  //   return formatDate(date, [d, '-', MM, '-', yyyy, '|', HH, ':', nn, am])
  //       .toString();
  // }

  int taxCharges = 0;
  int subTotal;
  int totalPrice;

  List<SaleOrderItem> orderItems;

  final _service = SaleOrderItemService();
  @override
  Widget build(BuildContext context) {
    totalPrice = int.parse(widget.orderModel.amount);
    if (widget.orderModel.delivery > 0) {
      subTotal =
          int.parse(widget.orderModel.amount) - widget.orderModel.deliveryFee - taxCharges;
    } else {
      subTotal =
          int.parse(widget.orderModel.amount) + widget.orderModel.discount;
      widget.orderModel.deliveryFee = 0;
    }
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text(
                      "ORDER ID # " + widget.orderModel.id.toString(),
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "Good",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text(
                      "Payment Status",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )),
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.orderModel.delivery > 0
                        ? widget.orderModel.deliveryStatus
                        : 'Completed',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 35,
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
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "QTY",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        )),
                    Expanded(
                        flex: 0,
                        child: Text(
                          "PRICE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
        SimpleFutureBuilder<List<SaleOrderItem>>.simplerSliver(
          future: _service.fetchAllOrderItemsByOrder(widget.orderModel.id),
          context: context,
          builder: (AsyncSnapshot<List<SaleOrderItem>> snapshot) {
            orderItems = snapshot.data;
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 5,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data[i].product.name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  snapshot.data[i].variant != null ? Text(snapshot.data[i].variant.name,
                                      style: TextStyle(
                                        fontSize: 11,
                                      )) : SizedBox(),
                                ],
                              ))),
                      Expanded(
                          flex: 2,
                          child: Text(snapshot.data[i].qty.toString())),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                            child: Text(
                                "Rs. " +
                                    (int.parse(snapshot.data[i].price) *
                                            int.parse(snapshot.data[i].qty))
                                        .toString(),
                                style: TextStyle(fontSize: 16)),
                          )),
                    ],
                  ),
                );
              }, childCount: snapshot.data.length),
            );
          },
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.black45,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(80, 10, 40, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Sub Total",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("Rs. " + subTotal.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.black45,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(80, 10, 40, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Tax",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("Rs. " + taxCharges.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.black45,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(80, 10, 40, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Delivery Charges",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("Rs. " + widget.orderModel.deliveryFee.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.black45,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(80, 10, 40, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Discount",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("Rs. " + widget.orderModel.discount.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.black45,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(80, 10, 40, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("Rs. " + totalPrice.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.black45,
            ),
          ),
        ),
        widget.orderModel.delivery > 0
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 22,
                    child: RaisedButton(
                      color: Color(0xffCE862A),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReOrder(
                                    order: widget.orderModel,
                                    orderItems: orderItems)));
                      },
                      child: Text("Re-Order",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
              )
            : SliverToBoxAdapter(
                child: SizedBox(),
              )
      ],
    );
  }
}

class Status extends StatefulWidget {
  final SaleOrder orderModel;

  Status({this.orderModel});
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  // _parseDate(DateTime date) {
  //   return formatDate(date, [d, '-', MM, '-', yyyy, '|', HH, ':', nn, am])
  //       .toString();
  // }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      children: <Widget>[
        ListTile(
          leading: Text(
            "Where is my Order?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          height: 0,
          color: Colors.black45,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 0, 5),
          child: Row(
            children: <Widget>[
              Text(
                "Order Placed",
                style: TextStyle(fontSize: 16),
              ),
              widget.orderModel.deliveryStatus == "Placed"
                  ? Icon(Icons.check)
                  : Text(''),
              // }
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Divider(
            color: Colors.black45,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 0, 5),
          child: Row(
            children: <Widget>[
              Text(
                "Order Pending",
                style: TextStyle(fontSize: 16),
              ),
              widget.orderModel.deliveryStatus == "Pending"
                  ? Icon(Icons.check)
                  : Text(''),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Divider(
            color: Colors.black45,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 0, 5),
          child: Row(
            children: <Widget>[
              Text(
                "Order Rejected",
                style: TextStyle(fontSize: 16),
              ),
              widget.orderModel.deliveryStatus == "Rejected"
                  ? Icon(Icons.check)
                  : Text(''),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Divider(
            color: Colors.black45,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 0, 5),
          child: Row(
            children: <Widget>[
              Text(
                "Order Delivered",
                style: TextStyle(fontSize: 16),
              ),
              widget.orderModel.deliveryStatus == "Complete"
                  ? Icon(Icons.check)
                  : Text(''),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Divider(
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}
