import 'package:flutter/material.dart';
import 'database_helper.dart';

class TambahPemasukanPage extends StatefulWidget {
  @override
  _TambahPemasukanPageState createState() => _TambahPemasukanPageState();
}

class _TambahPemasukanPageState extends State<TambahPemasukanPage> {
  TextEditingController _tanggalController = TextEditingController();
  TextEditingController _jumlahController = TextEditingController();
  TextEditingController _keteranganController = TextEditingController();

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _tanggalController.text = pickedDate.toString();
      });
    }
  }

  void _resetFields() {
    _tanggalController.text = '01/01/2021';
    _jumlahController.text = '';
    _keteranganController.text = '';
  }

  void _saveDataToSQLite() async {
    String tanggal = _tanggalController.text;
    String jumlah = _jumlahController.text;
    String keterangan = _keteranganController.text;

    // Pastikan tanggal, jumlah, dan keterangan tidak kosong
    if (tanggal.isEmpty || jumlah.isEmpty || keterangan.isEmpty) {
      // Tampilkan pesan jika ada field yang kosong
      // Misalnya, menggunakan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Isi semua field!'),
        ),
      );
      return;
    }

    // Buat map untuk data pemasukan
    Map<String, dynamic> pemasukan = {
      'tanggal': tanggal,
      'nominal': int.parse(jumlah),
      'keterangan': keterangan,
    };

    // Panggil fungsi untuk menyimpan pemasukan ke SQLite
    int result = await DatabaseHelper.instance.insertPemasukan(pemasukan);

    // Cek apakah penyimpanan berhasil
    if (result != -1) {
      // Tampilkan pesan jika penyimpanan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data pemasukan berhasil disimpan!'),
        ),
      );

      // Reset fields setelah penyimpanan berhasil
      _resetFields();

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    } else {
      // Tampilkan pesan jika terjadi kesalahan saat penyimpanan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan. Data tidak dapat disimpan.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pemasukan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tanggalController,
              decoration: InputDecoration(
                hintText: 'Tanggal',
                suffixIcon: IconButton(
                  onPressed: _showDatePicker,
                  icon: Icon(Icons.calendar_today),
                ),
              ),
              readOnly: true,
            ),
            TextField(
              controller: _jumlahController,
              decoration: InputDecoration(hintText: 'Jumlah (Nominal)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _keteranganController,
              decoration: InputDecoration(hintText: 'Keterangan'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _resetFields,
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _saveDataToSQLite,
                  child: Text('Simpan'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('<< Kembali'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
