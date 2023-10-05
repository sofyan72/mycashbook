import 'package:flutter/material.dart';
import 'database_helper.dart';

class DetailCashFlowPage extends StatefulWidget {
  @override
  _DetailCashFlowPageState createState() => _DetailCashFlowPageState();
}

class _DetailCashFlowPageState extends State<DetailCashFlowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cash Flow'),
      ),
      body: FutureBuilder(
        future: _fetchCashFlowData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> cashFlowData =
                snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: cashFlowData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = cashFlowData[index];
                return ListTile(
                  title: Text('Nominal: ${item['nominal']}'),
                  subtitle: Text('Tanggal: ${item['tanggal']}'),
                  trailing: Icon(
                    item['type'] == 'pemasukan'
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_forward_ios_rounded,
                    color:
                        item['type'] == 'pemasukan' ? Colors.green : Colors.red,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchCashFlowData() async {
    List<Map<String, dynamic>> pemasukan =
        await DatabaseHelper.instance.getPemasukan();
    List<Map<String, dynamic>> pengeluaran =
        await DatabaseHelper.instance.getPengeluaran();

    List<Map<String, dynamic>> cashFlowData = [];
    for (var pemasukanItem in pemasukan) {
      cashFlowData.add({
        'type': 'pemasukan',
        'tanggal': pemasukanItem['tanggal'],
        'nominal': pemasukanItem['nominal'],
      });
    }

    for (var pengeluaranItem in pengeluaran) {
      cashFlowData.add({
        'type': 'pengeluaran',
        'tanggal': pengeluaranItem['tanggal_pengeluaran'],
        'nominal': pengeluaranItem['nominal_pengeluaran'],
      });
    }

    cashFlowData.sort((a, b) => a['tanggal'].compareTo(b['tanggal']));
    return cashFlowData;
  }
}
