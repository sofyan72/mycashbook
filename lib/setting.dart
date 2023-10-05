import 'package:flutter/material.dart';
import 'package:mycashbook/database_helper.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  String _message = '';

  void _clearFields() {
    setState(() {
      _currentPasswordController.clear();
      _newPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ubah Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Saat Ini',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final oldPassword = _currentPasswordController.text;
                final newPassword = _newPasswordController.text;

                final user =
                    await DatabaseHelper.instance.getUser('user', oldPassword);

                if (user != null) {
                  // Kata sandi lama benar
                  final rowsAffected = await DatabaseHelper.instance
                      .updatePassword('user', newPassword);

                  if (rowsAffected > 0) {
                    // Kata sandi berhasil diperbarui
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kata Sandi Berhasil Diperbarui'),
                      ),
                    );

                    // Clear the password fields after successful update
                    _clearFields();
                  } else {
                    // Terjadi kesalahan
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Terjadi Kesalahan. Silakan Coba Lagi.'),
                      ),
                    );
                  }
                } else {
                  // Kata sandi lama salah
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kata sandi lama salah!'),
                      ),
                    );
                  });
                }
              },
              child: Text('Simpan Perubahan'),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Developer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/1941720198.jpg'),
              ),
              title: Text('Ahmad Sofyan Argyanto'),
              subtitle: Text('1941720198'),
            ),
            SizedBox(height: 10),
            Text(_message), // Display the message here
          ],
        ),
      ),
    );
  }
}
