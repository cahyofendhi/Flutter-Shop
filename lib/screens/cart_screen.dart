import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' show Cart;
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    var children2 = <Widget>[
      Text(
        'Total',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Spacer(),
      Chip(
        label: Text(
          '\$ ${cart.totalAmount}',
          style:
              TextStyle(color: Theme.of(context).primaryTextTheme.title.color),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      new OrderButton(cart: cart),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children2,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) {
                final item = cart.items.values.toList()[
                    index]; //! get item from "Map list" => eq: Map<String, Object>
                final productId =
                    cart.items.keys.toList()[index]; // ! get key of map list
                return CartItem(
                    item.id, productId, item.price, item.quantity, item.title);
              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;

  void _updateLoading(bool isProcess) {
    setState(() {
      _isLoading = isProcess;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null //! button automatic disable when onPress have null value
          : () async {
              _updateLoading(true);
              final productData = Provider.of<Orders>(context, listen: false);
              await productData.addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.clear();
              _updateLoading(false);
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
