import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance;
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final context = this.context; // Assign the context to a local variable

    final user = await DatabaseHelper.instance.getUser(username, password);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 8, 230),
      ), //AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              width: 200,
              height: 100,
              child: Center(
                child: Image.asset(
                  'assets/Daco_1180352.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              'MY CASH BOOK ver 1.0',
              style: TextStyle(
                  fontSize: 9.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 92, 91, 91)),
            ),
            SizedBox(
              height: 100.0,
            ),
            SizedBox(
              height: 50.0,
              width: 300.0,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 50.0,
              width: 300.0,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromARGB(255, 0, 128, 255)),
              ),
              onPressed: _login,
              child: Text(
                'Login',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
