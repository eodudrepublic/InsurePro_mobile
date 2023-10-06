import 'package:insurepro_mobile/_core/url.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocalAccountManager {
  static final LocalAccountManager _instance = LocalAccountManager._(); // DBManager 클래스의 싱글톤 객체 생성
  static Database? _database; // 데이터베이스 인스턴스를 저장하는 변수
  // 스키마(schema) -> 데이터베이스에 저장되는 데이터의 구조와 제약조건을 정의한 것
  // 인스턴스(instance) -> 정의된 스키마에 따라 데이터베이스에 실제로 저장된 값

  LocalAccountManager._(); // DBManager 생성자(private)

  factory LocalAccountManager() => _instance; // DBManager 인스턴스 반환 메소드

  // 데이터베이스 인스턴스를 가져오는 메소드
  Future<Database> get database async {
    if (_database != null) {
      // 인스턴스가 이미 존재한다면
      return _database!; // 저장된 데이터베이스 인스턴스를 반환
    }
    _database = await _initDB(); // 데이터베이스 초기화
    return _database!; // 초기화된 데이터베이스 인스턴스 반환
  }

  // 데이터베이스 초기화 메소드
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // 데이터베이스 경로 가져오기
    final path = join(dbPath, 'account.db'); // 데이터베이스 파일 경로 생성
    return await openDatabase(
      path, // 데이터베이스 파일 경로
      version: 1, // 데이터베이스 버전
      onCreate: (db, version) async {
        await db.execute(
          // SQL 쿼리를 실행하여 데이터베이스 테이블 생성
          '''
            CREATE TABLE account(
              id INTEGER PRIMARY KEY, 
              email TEXT, 
              password TEXT
            )
          ''',
          // id : 테이블의 기본 키, email : 이메일, password : 비밀번호
        );
        await db.insert(
          'account', {'email':'', 'password':''},
          conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
        );
      },
    );
  }

  // 데이터 조회 메소드
  Future<Map<String, dynamic>> selectData() async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    final List<Map<String, dynamic>> maps = await db.query('account'); // 데이터베이스에서 모든 데이터 조회

    // 첫 번째 레코드에서 'email'과 'password' 정보만 가져옴
    return {
      'email': maps[0]['email'],
      'password': maps[0]['password']
    };
  }

  // 데이터 수정 메소드
  Future<void> updateData(String email, String password) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.update(
      'account',
      {'email': email, 'password': password},
      where: 'id = ?',
      whereArgs: [1], // 항상 첫 번째 account 항목을 수정
    );
  }

  // 데이터 삭제 메소드
  Future<void> deleteData() async {
    await updateData('', ''); // email, password 값을 빈 문자열로 수정
  }
}

class User with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  int? _pk;
  String? _id;
  String? _email;

  String? _name;
  String? _team;

  User({
    String? token,
    String? refreshToken,
    int? pk,
    String? id,
    String? email,
  })  : _token = token,
        _refreshToken = refreshToken,
        _pk = pk,
        _id = id,
        _email = email;

  String? get token => _token;
  String? get refreshToken => _refreshToken;
  int? get pk => _pk;
  String? get id => _id;
  String? get email => _email;
  String? get name => _name;
  String? get team => _team;

  // 사용자 정보 저장
  void setToken(String? newToken) {
    _token = newToken;
    notifyListeners();
  }
  void setRefreshToken(String? newRefreshToken) {
    _refreshToken = newRefreshToken;
    notifyListeners();
  }
  void setPK(int newPK) {
    _pk = newPK;
    notifyListeners();
  }
  void setID(String newID) {
    _id = newID;
    notifyListeners();
  }
  void setEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }
  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void setTeam(String newTeam) {
    _team = newTeam;
    notifyListeners();
  }

  Future<void> fetchUserInfo() async {
    if (_token == null) {
      print("_token값이 없습니다!");
      return;
    }

    var url = Uri.parse(URL.get_employee_url);
    var response = await http.get(
      url,
      headers: {
        "Authorization": _token!,
      },
    );

    if (response.statusCode == 200) {
      var body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body);

      // 가져온 데이터를 사용하여 User 객체를 업데이트합니다.
      setName(data['name']);
      // print(data['name']);
      setTeam(data['teamResponseDto']['teamName']);
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  // 추가적으로 필요한 메소드나 변수를 추가/수정할 수 있습니다.
}