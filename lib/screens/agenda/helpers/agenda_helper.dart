import 'package:recibo/screens/agenda/models/agenda.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AgendaHelper {
  static final String nomeTabela = 'agenda';
  static final String colunaId = 'id';
  static final String colunaTitulo = 'titulo';
  static final String colunaDescricao = 'descricao';
  static final String colunaCalendario = 'calendario';
  static final String colunaData = 'data';

  static final AgendaHelper _agendaHelper = AgendaHelper._internal();

  Database _db;

  factory AgendaHelper() {
    return _agendaHelper;
  }

  // ignore: empty_constructor_bodies
  AgendaHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql = 'CREATE TABLE $nomeTabela('
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, "
        "descricao TEXT, "
        'calendario TEXT,'
        'data DATETIME)';
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, 'banco_minhas_agendas.db');

    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> salvarAgenda(Agenda agenda) async {
    var bancoDados = await db;

    int resultado = await bancoDados.insert(
      nomeTabela,
      agenda.toMap(),
    );
    return resultado;
  }

  recuperarAgenda() async {
    var bancoDados = await db;
    String sql = 'SELECT * FROM $nomeTabela ORDER BY data DESC';
    List agendas = await bancoDados.rawQuery(sql);
    return agendas;
  }

  Future<int> atualizarAgenda(Agenda agenda) async {
    var bancoDados = await db;
    return await bancoDados.update(
      nomeTabela,
      agenda.toMap(),
      where: 'id =?',
      whereArgs: [agenda.id],
    );
  }

  Future<int> removerAgenda(int id) async {
    var bancoDados = await db;
    return await bancoDados.delete(
      nomeTabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> shareAgenda(Agenda agenda) async {
    var bancoDados = await db;

    int resultado = await bancoDados.share(
      nomeTabela,
      agenda.toMap(),
    );
    return resultado;
  }
}
