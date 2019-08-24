import 'package:flutter/material.dart';
import 'database/databaseFile.dart';
class ContactList1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Contacts"),
        ),
        body: new ContactList(kContacts));
  }
}

const kContacts = const <Contact>[

  const Contact(
      fullName: 'Romain Hoogmoed', email: 'romain.hoogmoed@example.com'),
  const Contact(fullName: 'Emilie Olsen', email: 'emilie.olsen@example.com')
];

class ContactList extends StatelessWidget {
  final List<Contact> _contacts;

  ContactList(this._contacts);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: new EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        return new _ContactListItem(_contacts[index]);
      },
      itemCount: _contacts.length,
    );
  }
}

class _ContactListItem extends ListTile {
    _ContactListItem(Contact contact)
        : super(
        title: new Text(contact.fullName),
        subtitle: new Text(contact.email,),
        leading: new CircleAvatar(child: new Text(contact.fullName[0])));
}

class Contact {
  final String fullName;
  final String email;

  const Contact({this.fullName, this.email});
}