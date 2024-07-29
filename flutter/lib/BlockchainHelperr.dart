import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'prescription_request_model.dart';
import 'Lab_model.dart';
import 'LabTest_model.dart';
import 'user_model.dart';
import 'models/Lipid.dart';
import 'models/Blood.dart';
import 'models/Patient.dart';
import 'models/XRay.dart';
import 'models/Surgery.dart';
import 'models/Prescription.dart';
import 'models/Laboratory.dart';
import 'models/Doctor.dart';
import 'models/Medicine.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        nationalId INTEGER PRIMARY KEY,
        name TEXT,
        dateOfBirth TEXT,
        email TEXT,
        password TEXT,
        hasSurgeriesBefore TEXT
      )
    ''');



    await db.execute('''
      CREATE TABLE prescription_requests(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        doctorId INTEGER,
        imageUrl TEXT,
        status TEXT,
        FOREIGN KEY (userId) REFERENCES users(nationalId),
        FOREIGN KEY (doctorId) REFERENCES doctors(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE labs(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE lab_tests(
        labTestId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        labId INTEGER,
        testName TEXT,
        imageUrl TEXT,
        status TEXT,
        FOREIGN KEY (userId) REFERENCES users(nationalId),
        FOREIGN KEY (labId) REFERENCES labs(id)
      )
    ''');

    //maram//

    await db.execute('''
      CREATE TABLE patients(
        nationalId INTEGER PRIMARY KEY,
        name TEXT,
        dateOfBirth TEXT,
        email TEXT,
        password TEXT,
        hasSurgeriesBefore TEXT,
        parentId INTEGER
      )
    ''');

    const lipidTable = '''
    CREATE TABLE lipid (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nationalId INTEGER ,
      labId INTEGER ,
      imageUrl TEXT ,
      status TEXT ,
      cholesterolTotal TEXT ,
      triglycerides TEXT ,
      hdlCholesterol TEXT ,
      ldlCholesterol TEXT ,
      date TEXT 
    )
    ''';

    await db.execute(lipidTable);
    const bloodTable = '''
    CREATE TABLE blood (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nationalId INTEGER ,
      labId INTEGER ,
      imageUrl TEXT ,
      status TEXT ,
      haemoglobin TEXT ,
      haematocrit TEXT ,
      rbcs TEXT ,
      date TEXT 
    )
    ''';
    await db.execute(bloodTable);

    const xrayTable = '''
    CREATE TABLE xray (
      id TEXT PRIMARY KEY,
      nationalId INTEGER,
      imageUrl TEXT,
      date TEXT
    )
    ''';
    await db.execute(xrayTable);

    const prescriptionTable = '''
    CREATE TABLE prescription (
      id TEXT PRIMARY KEY,
      nationalId INTEGER,
      imageUrl TEXT,
      date TEXT
    )
    ''';

    const surgeryTable = '''
    CREATE TABLE surgery (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nationalId INTEGER,
      imageUrl TEXT,
      date TEXT
    )
    ''';
    await db.execute(prescriptionTable);
    await db.execute(surgeryTable);
    const laboratoryTable = '''
    CREATE TABLE laboratory (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      imageHash TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL
    )
    ''';

    await db.execute(laboratoryTable);

    await db.execute(
        '''
      CREATE TABLE medicines(
        nationalId INTEGER,
        name TEXT,
        img TEXT,
        dose TEXT,
        numOfTimes INTEGER
      )
      '''
    );
    ///salma///
    await db.execute('''
  CREATE TABLE doctors(
    nationalId INTEGER PRIMARY KEY,
    name TEXT,
    dateOfBirth TEXT,
    email TEXT,
    password TEXT,
    certificateHash TEXT,
    speciality Text
  )
''');

    // Initialize users data
    await db.insert('users', User(nationalId: 123456789,
        name: 'Omnya',
        dateOfBirth: '1990-01-01',
        email: 'omnya@example.com',
        password: 'password123',
        hasSurgeriesBefore: 'No').toMap());
    await db.insert('users', User(nationalId: 987654321,
        name: 'Ahmed',
        dateOfBirth: '1985-05-05',
        email: 'ahmed@example.com',
        password: 'password123',
        hasSurgeriesBefore: 'Yes').toMap());

    await db.insert(
    'doctors',
    Doctor(
      nationalId: 12345678912311, // Assign appropriate nationalIds
      name: 'Abdel-Rahman Atalla',
      dateOfBirth: '1980-01-01',
      email: 'abdelrahman@example.com',
      password: 'doctor123',
      certificateHash: 'certificate123',
    ).toMap(),
  );

  await db.insert(
    'doctors',
    Doctor(
      nationalId: 12345678912344,
      name: 'Maher Assem',
      dateOfBirth: '1982-02-02',
      email: 'maher@example.com',
      password: 'doctor456',
      certificateHash: 'certificate456',
    ).toMap(),
  );

  await db.insert(
    'doctors',
    Doctor(
      nationalId: 12345678912333,
      name: 'Hesham Shoukry Aly',
      dateOfBirth: '1985-05-05',
      email: 'hesham@example.com',
      password: 'doctor789',
      certificateHash: 'certificate789',
    ).toMap(),
  );

  await db.insert(
    'doctors',
    Doctor(
      nationalId: 12345678912355,
      name: 'Onkar Bhave',
      dateOfBirth: '1988-08-08',
      email: 'onkar@example.com',
      password: 'doctor101112',
      certificateHash: 'certificate101112',
    ).toMap(),
  );

    // Initialize labs data
    await db.insert('labs', Lab(id: 1, name: 'al mokhtabar').toMap());
    await db.insert('labs', Lab(id: 2, name: 'Nile').toMap());
    await db.insert('labs', Lab(id: 3, name: 'Radar').toMap());
    await db.insert('labs', Lab(id: 4, name: 'Delta').toMap());
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'etamnapp_lab_requests.db');
    return await openDatabase(
      path,
      version: 26, // Increment the version number
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS doctors');
      await db.execute('DROP TABLE IF EXISTS prescription_requests');
      await db.execute('DROP TABLE IF EXISTS labs');
      await db.execute('DROP TABLE IF EXISTS lab_tests');
      await _createDb(db, newVersion);
    }
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<User?> getUserByName(String name) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<User?> getUserById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'nationalId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null; // Return null if the user is not found
    }
  }

  Future<List<Doctor>> getDoctors() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('doctors');
    return List.generate(maps.length, (i) {
      return Doctor.fromMap(maps[i]);
    });
  }

  Future<void> insertLab(Lab lab) async {
    final Database db = await database;

    await db.insert(
      'labs',
      lab.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Lab>> getLabs() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('labs');
    return List.generate(maps.length, (i) {
      return Lab.fromMap(maps[i]);
    });
  }

  Future<Lab?> getLabByName(String labName) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'labs',
      where: 'name = ?',
      whereArgs: [labName],
    );

    if (maps.isNotEmpty) {
      return Lab.fromMap(maps.first);
    } else {
      return null;
    }
  }
  Future<Patient?> getPatientByNationalIdAndPassword(int nationalId, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'patients', // Replace with your table name
      where: 'nationalId = ? AND password = ?',
      whereArgs: [nationalId, password],
    );

    if (maps.isNotEmpty) {
      return Patient.fromMap(maps.first); // Assumes you have a fromMap constructor in your Patient model
    }
    return null;
  }

  Future<List<LabTest>> getLabTests(int labId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'lab_tests',
      where: 'labId = ?',
      whereArgs: [labId],
    );
    return List.generate(maps.length, (i) {
      return LabTest.fromMap(maps[i]);
    });
  }

  Future<int> insertLabTest(LabTest request) async {
    Database db = await instance.database;
    print("Inserting LabTest request: ${request.toMap()}");

    // Create a new map without the id
    var map = request.toMap();
    map.remove('labTestId');

    int id = await db.insert(
      'lab_tests',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Inserted LabTest request with id: $id");
    return id;
  }

  Future<List<PrescriptionRequest>> getPrescriptionRequests(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'prescription_requests',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return PrescriptionRequest.fromMap(maps[i]);
    });
  }

  Future<List<PrescriptionRequest>> getDoctorPrescriptionRequests(
      int doctorId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'prescription_requests',
      where: 'doctorId = ?',
      whereArgs: [doctorId],
    );
    return List.generate(maps.length, (i) {
      return PrescriptionRequest.fromMap(maps[i]);
    });
  }

  Future<int> insertPrescriptionRequest(PrescriptionRequest request) async {
    Database db = await instance.database;
    print("Inserting prescription request: ${request.toMap()}");

    // Create a new map without the id
    var map = request.toMap();
    map.remove('id');

    int id = await db.insert(
      'prescription_requests',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Inserted prescription request with id: $id");
    return id;
  }

  Future<Map<int, List<PrescriptionRequest>>> getAllPrescriptionRequests() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> doctorMaps = await db.query('doctors');

    Map<int, List<PrescriptionRequest>> doctorPrescriptions = {};

    for (var doctorMap in doctorMaps) {
      int doctorId = doctorMap['id'];
      List<
          PrescriptionRequest> prescriptions = await getDoctorPrescriptionRequests(
          doctorId);
      doctorPrescriptions[doctorId] = prescriptions;
    }

    return doctorPrescriptions;
  }

  Future<List<PrescriptionRequest>> getUserPrescriptionRequests(
      int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'prescription_requests',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return PrescriptionRequest.fromMap(maps[i]);
    });
  }

  Future<List<LabTest>> getUserLabTests(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'lab_tests',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return LabTest.fromMap(maps[i]);
    });
  }

  Future<void> updatePrescriptionRequest(PrescriptionRequest request) async {
    Database db = await instance.database;
    await db.update(
      'prescription_requests',
      request.toMap(),
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

  Future<PrescriptionRequest> getPrescriptionRequestById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'prescription_requests',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PrescriptionRequest.fromMap(maps.first);
    } else {
      throw Exception('Prescription request with id $id not found');
    }
  }

  Future<void> updateLabTest(LabTest request) async {
    Database db = await instance.database;
    await db.update(
      'lab_tests',
      request.toMap(),
      where: 'labTestId = ?', // Use correct field name
      whereArgs: [request.labTestId],
    );
  }

  Future<LabTest> getLabTestById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'lab_tests',
      where: 'labTestId = ?', // Use correct field name
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return LabTest.fromMap(maps.first);
    } else {
      throw Exception('Lab Test with id $id not found');
    }
  }


  //////////////////////////////////////

  Future<int> insertLipid(Lipid lipid) async {
    final db = await instance.database;

    return await db.insert(
      'lipid',
      lipid.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Lipid>> getLipidsByNationalId(int nationalId) async {
    final db = await instance.database;

    final result = await db.query(
      'lipid',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );

    return result.map((json) => Lipid.fromMap(json)).toList();
  }

  Future<int> insertBlood(Blood blood) async {
    final db = await instance.database;

    return await db.insert(
      'blood',
      blood.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Blood>> getBloodsByNationalId(int nationalId) async {
    final db = await instance.database;

    final result = await db.query(
      'blood',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );

    return result.map((json) => Blood.fromMap(json)).toList();
  }

  Future<int> insertXRay(XRay xRay) async {
    final db = await instance.database;

    return await db.insert(
      'xray',
      xRay.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<XRay>> getXRayByNationalId(int nationalId) async {
    final db = await instance.database;

    final result = await db.query(
      'xray',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );

    return result.map((json) => XRay.fromMap(json)).toList();
  }

  Future<int> insertPrescription(Prescription prescription) async {
    final db = await instance.database;

    return await db.insert(
      'prescription',
      prescription.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Prescription>> getPrescriptionByNationalId(int nationalId) async {
    final db = await instance.database;

    final result = await db.query(
      'prescription',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );

    return result.map((json) => Prescription.fromMap(json)).toList();
  }

  Future<int> insertSurgery(Surgery surgery) async {
    final db = await instance.database;
    print(surgery.nationalId);
    print("Halllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllo");
    return await db.insert(
      'surgery',
      surgery.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Surgery>> getSurgeryByNationalId(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'surgery',
      where: 'nationalId = ?',
      whereArgs: [id],
    );
    print('gggggggggggggggggggggggg');
    if (maps.isNotEmpty) {
      return List<Surgery>.from(maps.map((map) => Surgery.fromMap(map)));
    } else {
      return [];  // Return an empty list if no surgery is found
    }
  }
  Future<int> insertLaboratory(Laboratory laboratory) async {
    final db = await instance.database;

    return await db.insert(
      'laboratory',
      laboratory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<Laboratory?> getLaboratoryByName(String name) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'laboratory',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Laboratory.fromMap(maps.first);
    } else {
      return null;
    }
  }
  Future<List<String>> getAllLaboratoryNames() async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'laboratory',
      columns: ['name'],
    );

    return result.map((map) => map['name'] as String).toList();
  }

  Future<int> insertMedicine(Medicine medicine) async {
    final db = await database;
    return await db.insert(
      'medicines',
      medicine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medicine>> getMedicinesByNationalId(int nationalId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'medicines',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );

    return result.map((map) => Medicine.fromMap(map)).toList();
  }
/////////////maram////////////
  Future<void> insertPatient(Patient patient) async {
    final db = await instance.database;
    await db.insert(
      'patients',
      patient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> checkNationalId(int nationalId) async {
    final db = await instance.database;
    final result = await db.query(
      'patients',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );
    return result.isNotEmpty;
  }

  Future<Patient?> getPatientByNationalId(int nationalId) async {
    final db = await instance.database;
    final result = await db.query(
      'patients',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );

    if (result.isNotEmpty) {
      return Patient.fromMap(result.first);
    } else {
      return null;
    }
  }
  Future<int> updatePatient(Patient patient) async {
    Database db = await instance.database;

    return await db.update(
      'patients',
      patient.toMap(),
      where: 'nationalId = ?',
      whereArgs: [patient.nationalId],
    );
  }

  //////////salma/////////////

  Future<void> insertDoctor(Doctor doctor) async {
    final db = await instance.database;
    await db.insert(
      'doctors',
      doctor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> checkNationalIdForDoctor(int nationalId) async {
    final db = await instance.database;
    final result = await db.query(
      'doctors',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );
    return result.isNotEmpty;
  }

  Future<Doctor?> getDoctorByNationalId(int nationalId) async {
    final db = await instance.database;
    final result = await db.query(
      'doctors',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );

    if (result.isNotEmpty) {
      return Doctor.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<Doctor>> getAllDoctors() async {
    final db = await instance.database;
    final result = await db.query('doctors');

    return result.map((json) => Doctor.fromMap(json)).toList();
  }
  Future<void> updateDoctorSpeciality(int nationalId, String speciality) async {
    Database db = await instance.database;
    await db.update(
      'doctors',
      {'speciality': speciality},
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );
  }

  Future<void> addChild(Patient child) async {
    final db = await instance.database;
    await db.insert(
      'patients',
      child.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Patient>> getChildrenByParentId(int parentId) async {
    final db = await instance.database;
    final result = await db.query(
      'patients',
      where: 'parentId = ?',
      whereArgs: [parentId],
    );

    return result.map((json) => Patient.fromMap(json)).toList();
  }

  Future<int> updatePatientPassword(int nationalId, String newPassword) async {
    final db = await instance.database;
    return await db.update(
      'patients',
      {'password': newPassword},
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );
  }

}