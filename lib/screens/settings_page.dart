import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Profil'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Gece/Gündüz Modu'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Tema'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
