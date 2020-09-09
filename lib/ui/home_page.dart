import 'package:agenda_de_contatos/ui/contact_page.dart';
import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem(
                child: Text("Ordernar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem(
                child: Text("Ordernar de Z-A"),
                value: OrderOptions.orderza,
              )
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img))
                        : AssetImage('images/person.png'),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        contacts[index].name ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Text(
                        contacts[index].email ?? '',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Divider(),
                      Text(
                        contacts[index].phone ?? '',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        launch('tel:${contacts[index].phone}');
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Ligar',
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      },
                      child: Text(
                        'Editar',
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        helper.deleteContact(contacts[index].id);
                        setState(() {
                          contacts.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Excluir',
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          onClosing: () {},
        );
      },
    );
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          contact: contact,
        ),
      ),
    );

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case OrderOptions.orderza:
        contacts.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
    }
    setState(() {});
  }
}
