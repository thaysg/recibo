import 'package:recibo/screens/recibo/helper/anotacao_helper.dart';

class Anotacao {
  int id;
  String titulo;
  String descricao;
  String valor;
  String data;

  Anotacao(this.titulo, this.descricao, this.valor, this.data);

  Map toMap() {
    Map<String, dynamic> map = {
      'titulo': this.titulo,
      'descricao': this.descricao,
      'valor': this.valor,
      'data': this.data,
    };
    if (this.id != null) {
      map['id'] = this.id;
    }
    return map;
  }

  Anotacao.fromMap(Map map) {
    this.id = map[AnotacaoHelper.colunaId];
    this.titulo = map[AnotacaoHelper.colunaTitulo];
    this.descricao = map[AnotacaoHelper.colunaDescricao];
    this.valor = map[AnotacaoHelper.colunaValor];
    this.data = map[AnotacaoHelper.colunaData];
  }
}
