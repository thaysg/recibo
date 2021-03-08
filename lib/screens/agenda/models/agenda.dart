import 'package:recibo/screens/agenda/helpers/agenda_helper.dart';

class Agenda {
  int id;
  String titulo;
  String descricao;
  String calendario;
  String data;

  Agenda(this.titulo, this.descricao, this.calendario, this.data);

  Map toMap() {
    Map<String, dynamic> map = {
      'titulo': this.titulo,
      'descricao': this.descricao,
      'calendario': this.calendario,
      'data': this.data,
    };
    if (this.id != null) {
      map['id'] = this.id;
    }
    return map;
  }

  Agenda.fromMap(Map map) {
    this.id = map[AgendaHelper.colunaId];
    this.titulo = map[AgendaHelper.colunaTitulo];
    this.descricao = map[AgendaHelper.colunaDescricao];
    this.calendario = map[AgendaHelper.colunaCalendario];
    this.data = map[AgendaHelper.colunaData];
  }
}

/* class Agenda {
  int id;
  String nome;
  String descricao;

  agendaMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['nome'] = nome;
    mapping['descricao'] = descricao;

    return mapping;
  }
}
 */
