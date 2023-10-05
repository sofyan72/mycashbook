import 'package:flutter/material.dart';
import 'package:mycashbook/database_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalPengeluaran = 0;
  int totalPemasukan = 0;
  int sisaUang = 0;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil total pengeluaran dan pemasukan
    _updateTotals();
  }

  Future<void> _updateTotals() async {
    int totalPengeluaranFromDB =
        await DatabaseHelper.instance.getTotalPengeluaran();
    int totalPemasukanFromDB =
        await DatabaseHelper.instance.getTotalPemasukan();

    // Perbarui state dengan total pengeluaran dan pemasukan dari database
    setState(() {
      totalPengeluaran = totalPengeluaranFromDB;
      totalPemasukan = totalPemasukanFromDB;
      sisaUang = totalPemasukan - totalPengeluaran;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 8, 230),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rangkuman Bulan Ini',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Label untuk total pengeluaran
            Text(
              'Total Pengeluaran: Rp $totalPengeluaran',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),

            // Label untuk total pemasukan
            Text(
              'Total Pemasukan: Rp $totalPemasukan',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),

            Text(
              'Sisa Uang: Rp $sisaUang',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // [BONUS] Placeholder untuk grafik atau gambar
            Container(
              width: 200,
              height: 200,
              // color: Colors.grey,
              child: Center(
                child: Image.asset(
                  'assets/chart.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover, // Sesuaikan dengan kebutuhanmu
                ),
              ),
            ),

            SizedBox(height: 20),
            // 4 ImageButton untuk navigasi
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: NavigationButton(
                        icon: Icons.attach_money,
                        label: 'Tambah Pemasukan',
                        onPressed: () {
                          Navigator.pushNamed(context, '/tambah_pemasukan');
                        },
                      ),
                    ),
                    SizedBox(width: 16), // Spasi antar tombol
                    Expanded(
                      child: NavigationButton(
                        icon: Icons.money_off,
                        label: 'Tambah Pengeluaran',
                        onPressed: () {
                          Navigator.pushNamed(context, '/tambah_pengeluaran');
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Spasi antara dua baris tombol
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: NavigationButton(
                        icon: Icons.view_list,
                        label: 'Detail Cash Flow',
                        onPressed: () {
                          Navigator.pushNamed(context, '/detail_cash_flow');
                        },
                      ),
                    ),
                    SizedBox(width: 16), // Spasi antar tombol
                    Expanded(
                      child: NavigationButton(
                        icon: Icons.settings,
                        label: 'Pengaturan',
                        onPressed: () {
                          Navigator.pushNamed(context, '/setting');
                        },
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Widget untuk tombol navigasi
class NavigationButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPressed;

  const NavigationButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            // Panggil fungsi onPressed ketika tombol ditekan
            onPressed();
          },
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
