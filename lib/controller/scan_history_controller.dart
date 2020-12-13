import 'package:barcode_info/barcode_info.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/scan_history.dart';

/// Barcode Scan History Controller
class ScanHistoryController {
  static ScanHistoryController _instance = ScanHistoryController._internal();

  factory ScanHistoryController() {
    return _instance;
  }

  static ScanHistoryController get instance => ScanHistoryController();

  ScanHistoryController._internal();

  Future<bool> open() async {
    if (_db != null) return true;

    const createTableStmt = '''
    CREATE TABLE scan_history (
      timestamp	INTEGER NOT NULL,
      format	TEXT,
      code	TEXT,
      PRIMARY KEY(timestamp)
    )''';

    var path = join(await getDatabasesPath(), 'jkqrcode.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(createTableStmt);
    });

    // jktest
    //await generateTestHistory(5000);

    return _db != null;
  }

  generateTestHistory(int count,
      {Duration interval = const Duration(minutes: 1)}) async {
    await clear();
    var timestamp = DateTime(2020, 11, 21);
    for (var i = 0; i < count; i++) {
      await add(
          BarcodeInfo.fromString(
              'qrCode,http://m.dhlottery.co.kr/?v=0936m041720353943q071215303244m071113171829q010222253142m0414182731421050908394'),
          timestamp: timestamp);
      timestamp = timestamp.add(interval);
    }
  }

  Future<List<ScanRecord>> history() async {
    /// 최근 스캔결과가 먼저 나오도록
    final list = await _db.rawQuery(
        'SELECT timestamp, format, code FROM scan_history ORDER BY timestamp DESC');

    final records = List<ScanRecord>();
    for (var item in list) {
      print(item.toString());
      final record = ScanRecord(
          DateTime.fromMillisecondsSinceEpoch(item['timestamp']),
          BarcodeInfo.create(item['format'], item['code']));
      records.add(record);
    }
    return records;
  }

  /// 스캔기록에 추가
  Future<bool> add(BarcodeInfo data, {DateTime timestamp}) async {
    final now = timestamp == null ? DateTime.now().toUtc() : timestamp;
    return await _db.transaction<bool>((txn) async {
      final id = await txn.rawInsert(
          'INSERT INTO scan_history(timestamp, format, code)' +
              ' VALUES(${now.millisecondsSinceEpoch}, "${data.format.toString().split('.').last}", "${data.code}")');
      return id > 0;
    });
  }

  /// 스캔기록 삭제
  Future<bool> remove(ScanRecord record) async {
    final key = record.timestamp.millisecondsSinceEpoch;
    final count =
        await _db.rawDelete('DELETE FROM scan_history WHERE timestamp=$key');
    return count == 1;
  }

  Future<int> clear() async {
    return _db.rawDelete('DELETE FROM scan_history');
  }

  Database _db;
}
