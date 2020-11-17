import 'dart:async';
import 'dart:core';
import 'package:path/path.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/models/db/single_shift.dart';
import 'package:sqflite/sqflite.dart';

class DbInstance {
  static DatabaseHelper dbHelper;
}

abstract class DatabaseHelper {
  Future<void> insertScheduledShiftGroup(ShiftGroupModel shiftGroup);

  Future<void> insertHistoryShiftGroup(ShiftGroupModel shiftGroup);

  Future<void> insertShiftModel(SingleShiftModel shiftModel);

  Future<void> deleteScheduledShiftGroup(ShiftGroupModel shiftGroupModel);

  Future<void> deleteHistoryShiftGroup(ShiftGroupModel shiftGroupModel);

  Future<void> deleteHistoryShifts();

  Future<void> deleteShiftModel(SingleShiftModel shiftModel);

  Future<ShiftGroupModel> getShiftGroupModel(ShiftGroupModel shiftGroupModel);

  Future<void> updateScheduledShiftIncome(ShiftGroupModel shiftGroupModel);

  Future<void> moveShiftGroupToHistoryFromScheduled(
      ShiftGroupModel shiftGroupModel);

  Future<void> moveShiftGroupToScheduledFromHistory(
      ShiftGroupModel shiftGroupModel);

  Future<List<ShiftGroupModel>> getScheduledShiftModels();

  Future<List<ShiftGroupModel>> getHistoryShiftModels();

  Future<List<SingleShiftModel>> getShiftModelsForParticularGroup(
      String groupId);

  Future<List<String>> getSiteNameSuggestions();

  Future<void> insertSiteNameSuggestion(String newSuggestion);

  void closeDb();
}

class DatabaseHelperImpl implements DatabaseHelper {
  static const dbName = 'shifts.db';
  static const siteNameTableName = 'site_names';
  static const allShiftsTableName = 'all_shifts';
  static const scheduledShiftGroupsTableName = 'scheduled_shift_groups';
  static const historyShiftGroupsTableName = 'history_shift_groups';

  Future<Database> database = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, dbName),
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE $scheduledShiftGroupsTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, uniqueGroupId TEXT, nightShiftCount INTEGER, dayShiftCount INTEGER, weekEnding INTEGER, estimatedIncome REAL, jobPosition TEXT, permStaffName TEXT, pngSignatureBytesInStr TEXT)");
        await db.execute(
            "CREATE TABLE $allShiftsTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, siteName TEXT, startTime INTEGER, endTime INTEGER, date INTEGER, isDay INTEGER, breakTimeInMins INTEGER, isSigned INTEGER, hourlyRate REAL, parentId TEXT, comment TEXT, estimatedIncome REAL, workedHours REAL)");
        await db.execute(
            "CREATE TABLE $historyShiftGroupsTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, uniqueGroupId TEXT, nightShiftCount INTEGER, dayShiftCount INTEGER, weekEnding INTEGER, estimatedIncome REAL, jobPosition TEXT, permStaffName TEXT, pngSignatureBytesInStr TEXT)");
        await db.execute(
            "CREATE TABLE $siteNameTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, siteName TEXT)");
      },
      version: 1,
    );
  });

  // Future onCreate
  @override
  void closeDb() async {
    Database db = await database;
    if (db.isOpen) db.close();
  }

  @override
  Future<void> insertScheduledShiftGroup(ShiftGroupModel shiftGroup) async {
    Database db = await database;
    print("Inserting data to db");
    await db.insert(scheduledShiftGroupsTableName, shiftGroup.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  @override
  Future<void> updateScheduledShiftIncome(
      ShiftGroupModel shiftGroupModel) async {
    Database db = await database;
    await db.update(
      scheduledShiftGroupsTableName,
      shiftGroupModel.toMap(),
      where: "id = ?",
      whereArgs: [shiftGroupModel.id],
    );
  }

  @override
  Future<void> insertShiftModel(SingleShiftModel shiftModel) async {
    Database db = await database;
    await db.insert(allShiftsTableName, shiftModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<void> insertHistoryShiftGroup(ShiftGroupModel shiftGroupModel) async {
    Database db = await database;
    await db.insert(historyShiftGroupsTableName, shiftGroupModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<void> deleteHistoryShifts() async {
    List<ShiftGroupModel> shifts = await getHistoryShiftModels();
    for (int i = 0; i < shifts.length; i++) {
      ShiftGroupModel historyShiftGroup = shifts[i];
      await deleteHistoryShiftGroup(historyShiftGroup);
    }
  }

  @override
  Future<void> deleteScheduledShiftGroup(
      ShiftGroupModel shiftGroupModel) async {
    Database db = await database;
    await db.delete(
      scheduledShiftGroupsTableName,
      where: 'id = ?',
      whereArgs: [shiftGroupModel.id],
    );
  }

  @override
  Future<void> deleteHistoryShiftGroup(ShiftGroupModel shiftGroupModel) async {
    Database db = await database;
    await db.delete(
      scheduledShiftGroupsTableName,
      where: 'uniqueGroupId = ?',
      whereArgs: [shiftGroupModel.uniqueGroupId],
    );

    await db.delete(
      historyShiftGroupsTableName,
      where: 'id = ?',
      whereArgs: [shiftGroupModel.id],
    );
  }

  @override
  Future<void> deleteShiftModel(SingleShiftModel shiftModel) async {
    Database db = await database;
    await db.delete(
      allShiftsTableName,
      where: 'id = ?',
      whereArgs: [shiftModel.id],
    );
  }

  @override
  Future<List<ShiftGroupModel>> getScheduledShiftModels() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(scheduledShiftGroupsTableName);

    return List.generate(
      maps.length,
      (i) => ShiftGroupModel.toShiftGroupModelObject(maps[i]),
    );
  }

  @override
  Future<List<ShiftGroupModel>> getHistoryShiftModels() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(historyShiftGroupsTableName);

    return List.generate(
      maps.length,
      (i) => ShiftGroupModel.toShiftGroupModelObject(maps[i]),
    );
  }

  @override
  Future<void> moveShiftGroupToScheduledFromHistory(
      ShiftGroupModel shiftGroupModel) async {
    Database db = await database;
    print('moving ${shiftGroupModel.name}');

    await db.insert(
      scheduledShiftGroupsTableName,
      ShiftGroupModel(
        id: null,
        nightShiftCount: shiftGroupModel.nightShiftCount,
        dayShiftCount: shiftGroupModel.dayShiftCount,
        uniqueGroupId: shiftGroupModel.uniqueGroupId,
        name: shiftGroupModel.name,
        weekEnding: shiftGroupModel.weekEnding,
        estimatedIncome: shiftGroupModel.estimatedIncome,
        jobPosition: shiftGroupModel.jobPosition,
        permStaffName: shiftGroupModel.permStaffName,
        pngSignatureBytesInStr: shiftGroupModel.pngSignatureBytesInStr,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    await db.delete(
      historyShiftGroupsTableName,
      where: "id = ?",
      whereArgs: [shiftGroupModel.id],
    );
  }

  @override
  Future<void> moveShiftGroupToHistoryFromScheduled(
      ShiftGroupModel shiftGroupModel) async {
    Database db = await database;
    await db.insert(
      historyShiftGroupsTableName,
      ShiftGroupModel(
        id: null,
        nightShiftCount: shiftGroupModel.nightShiftCount,
        dayShiftCount: shiftGroupModel.dayShiftCount,
        uniqueGroupId: shiftGroupModel.uniqueGroupId,
        name: shiftGroupModel.name,
        weekEnding: shiftGroupModel.weekEnding,
        estimatedIncome: shiftGroupModel.estimatedIncome,
        jobPosition: shiftGroupModel.jobPosition,
        permStaffName: shiftGroupModel.permStaffName,
        pngSignatureBytesInStr: shiftGroupModel.pngSignatureBytesInStr,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    await db.delete(
      scheduledShiftGroupsTableName,
      where: "id = ?",
      whereArgs: [shiftGroupModel.id],
    );
  }

  @override
  Future<List<SingleShiftModel>> getShiftModelsForParticularGroup(
      String groupId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      allShiftsTableName,
      where: 'parentId = ?',
      orderBy: "date ASC",
      whereArgs: [groupId],
    );

    return List.generate(
      maps.length,
      (i) => SingleShiftModel.toShiftModelObject(maps[i]),
    );
  }

  @override
  Future<ShiftGroupModel> getShiftGroupModel(
      ShiftGroupModel shiftGroupModel) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      scheduledShiftGroupsTableName,
      where: 'uniqueGroupId = ?',
      orderBy: "name ASC",
      whereArgs: [shiftGroupModel.uniqueGroupId],
    );

    List<ShiftGroupModel> list = List.generate(
      maps.length,
      (i) => ShiftGroupModel.toShiftGroupModelObject(maps[i]),
    );
    if (list.length >= 1) return list[0];
    return null;
  }

  @override
  Future<List<String>> getSiteNameSuggestions() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(siteNameTableName);

    return List.generate(
      maps.length,
      (i) => maps[i]['siteName'],
    );
  }

  @override
  Future<void> insertSiteNameSuggestion(String newSuggestion) async {
    Database db = await database;
    await db.insert(
        siteNameTableName,
        {
          'id': null,
          'siteName': newSuggestion,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }
}

///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
