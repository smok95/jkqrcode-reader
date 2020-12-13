import 'package:barcode_info/barcode_info.dart';
import 'package:hive/hive.dart';

@HiveType()
class ScanRecord extends HiveObject {
  /// 생성일자
  @HiveField(0)
  final DateTime timestamp;

  /// 스캔값 리스트
  @HiveField(1)
  BarcodeInfo data;

  ScanRecord(this.timestamp, this.data);
}

class ScanDailyHistory extends HiveObject {
  /// 일자
  @HiveField(0)
  final DateTime date;

  /// 일간 스캔값 리스트
  @HiveField(1)
  List<ScanRecord> records;

  ScanDailyHistory(this.date, {List<ScanRecord> records})
      : records = records ?? List<ScanRecord>();
}

class ScanHistoryAdapter extends TypeAdapter<ScanRecord> {
  @override
  int get typeId => 0;

  @override
  ScanRecord read(BinaryReader reader) {
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final data = BarcodeInfo.fromString(reader.readString());
    return ScanRecord(date, data);
  }

  @override
  void write(BinaryWriter writer, ScanRecord obj) {
    writer
      ..writeInt(obj.timestamp.millisecondsSinceEpoch)
      ..writeString(obj.data.toString());
  }
}

class ScanDailyHistoryAdapter extends TypeAdapter<ScanDailyHistory> {
  @override
  ScanDailyHistory read(BinaryReader reader) {
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final records =
        reader.readList().map((e) => e as ScanRecord).toList(growable: false);
    return ScanDailyHistory(date, records: records);
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, ScanDailyHistory obj) {
    writer
      ..writeInt(obj.date.millisecondsSinceEpoch)
      ..writeList(obj.records);
  }
}
