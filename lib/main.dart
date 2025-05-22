import 'package:budgetlog/api/httpClient.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> expenses = [];
  final httpClient apiClient = httpClient('http://14.45.90.158:8888'); // Base URL 설정

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      final data = await apiClient.get('/budget/list'); // 공통 파트를 사용하여 요청
      setState(() {
        expenses = List<String>.from(data['data'].map((item) => item['budgetName']));
      });
    } catch (e) {
      print(e);
    }
  }

  void _showAddBudgetDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('가계부 추가하기'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: '가계부 이름을 입력하세요'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('추가'),
              onPressed: () {
                // 가계부 이름을 처리하는 로직 추가
                String budgetName = controller.text;
                if (budgetName.isNotEmpty) {
                  // 예: 가계부 목록에 추가하는 로직
                  // 예를 들어 expenses.add(budgetName);
                  print('새 가계부 이름: $budgetName');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('가계부'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(10.0),
        children: expenses.map((item) => _buildFolderCard(item)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBudgetDialog, // 팝업 호출
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFolderCard(String title) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}