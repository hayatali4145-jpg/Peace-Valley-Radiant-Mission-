import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDb {
  AppDb._();
  static final instance = AppDb._();
  Database? _db;
  Future<Database> get database async => _db ??= await _open();
  Future<Database> _open() async {
    final base = await getDatabasesPath();
    return openDatabase(p.join(base, 'pvrm_school.db'), version: 1,
      onCreate: (db, _) async {
        await db.execute('CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, className TEXT NOT NULL, guardian TEXT, phone TEXT, createdAt TEXT NOT NULL)');
        await db.execute('CREATE TABLE attendance(id INTEGER PRIMARY KEY AUTOINCREMENT, studentId INTEGER NOT NULL, day TEXT NOT NULL, status TEXT NOT NULL, UNIQUE(studentId,day))');
        await db.execute('CREATE TABLE fee_payments(id INTEGER PRIMARY KEY AUTOINCREMENT, studentId INTEGER NOT NULL, amountPaise INTEGER NOT NULL, purpose TEXT NOT NULL, paidAt TEXT NOT NULL, receiptNo TEXT NOT NULL UNIQUE)');
        await db.execute('CREATE TABLE teachers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, monthlySalaryPaise INTEGER NOT NULL)');
        await db.execute('CREATE TABLE salary_payments(id INTEGER PRIMARY KEY AUTOINCREMENT, teacherId INTEGER NOT NULL, amountPaise INTEGER NOT NULL, paidAt TEXT NOT NULL, note TEXT)');
      });
  }
  Future<List<Map<String,Object?>>> students() async => (await database).query('students', orderBy: 'name');
  Future<void> addStudent(String name, String cls, String guardian, String phone) async => (await database).insert('students', {'name':name,'className':cls,'guardian':guardian,'phone':phone,'createdAt':DateTime.now().toIso8601String()});
  Future<void> markAttendance(int id, String status) async { final d=DateTime.now(); final day='${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}'; await (await database).insert('attendance', {'studentId':id,'day':day,'status':status}, conflictAlgorithm: ConflictAlgorithm.replace); }
  Future<String> addFee(int studentId, int amountPaise, String purpose) async { final now=DateTime.now(); final receipt='PVRM-${now.millisecondsSinceEpoch}'; await (await database).insert('fee_payments', {'studentId':studentId,'amountPaise':amountPaise,'purpose':purpose,'paidAt':now.toIso8601String(),'receiptNo':receipt}); return receipt; }
  Future<void> addTeacher(String name, int salaryPaise) async => (await database).insert('teachers', {'name':name,'monthlySalaryPaise':salaryPaise});
  Future<List<Map<String,Object?>>> teachers() async => (await database).query('teachers', orderBy:'name');
  Future<void> paySalary(int teacherId,int amountPaise,String note) async => (await database).insert('salary_payments', {'teacherId':teacherId,'amountPaise':amountPaise,'paidAt':DateTime.now().toIso8601String(),'note':note});
  Future<int> count(String table) async { final r=await (await database).rawQuery('SELECT COUNT(*) AS n FROM $table'); return (r.first['n'] as int?) ?? 0; }
  Future<int> total(String table, String field) async { final r=await (await database).rawQuery('SELECT COALESCE(SUM($field),0) AS n FROM $table'); return (r.first['n'] as int?) ?? 0; }
  Future<Map<String,Object?>?> feeByReceipt(String receipt) async { final r=await (await database).rawQuery('SELECT fee_payments.*, students.name AS studentName, students.className AS className FROM fee_payments JOIN students ON students.id=fee_payments.studentId WHERE receiptNo=?',[receipt]); return r.isEmpty?null:r.first; }
}
