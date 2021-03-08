import 'package:flutter/material.dart';
import 'package:recibo/drawer/drawer_navigation.dart';
import 'package:recibo/screens/recibo/helper/anotacao_helper.dart';
import 'package:recibo/screens/recibo/model/anotacao.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:share/share.dart';

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _valorController = TextEditingController();
  var _db = AnotacaoHelper();
  // ignore: deprecated_member_use
  List<Anotacao> _anotacoes = List<Anotacao>();

  _exibirTelaCadastro({Anotacao anotacao}) {
    String textoSalvarAtualizar = '';
    if (anotacao == null) {
      _tituloController.text;
      _descricaoController.text;
      _valorController.text;
      textoSalvarAtualizar = 'Salvar';
    } else {
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      _valorController.text = anotacao.valor;
      textoSalvarAtualizar = 'Atualizar';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Recebimento"),
          content: Builder(
            builder: (context) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _tituloController,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: "Nome", hintText: "Digite o nome..."),
                    ),
                    TextField(
                      controller: _descricaoController,
                      decoration: InputDecoration(
                          labelText: "Descrição",
                          hintText: "Digite descrição..."),
                    ),
                    TextField(
                      controller: _valorController,
                      decoration: InputDecoration(
                        labelText: "Valor",
                        prefixText: 'R\$ ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              primary: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xff009933),
                              primary: Colors.white,
                            ),
                            onPressed: () {
                              //salvar
                              _salvarAtualizarAnotacao(
                                  anotacaoSelecionada: anotacao);
                              Navigator.pop(context);
                            },
                            child: Text(
                              textoSalvarAtualizar,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  _removerAnotacao(int id) async {
    await _db.removerAnotacao(id);
    _recuperarAnotacoes();
  }

  _salvarAtualizarAnotacao({Anotacao anotacaoSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    String valor = _valorController.text;

    print('data atual: ' + DateTime.now().toString());
    print(titulo);
    print(descricao);
    print(valor);

    if (anotacaoSelecionada == null) {
      Anotacao anotacao =
          Anotacao(titulo, descricao, valor, DateTime.now().toString());

      int resultado = await _db.salvarAnotacao(anotacao);
      print('salvar anotacao ' + resultado.toString());
    } else {
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.valor = valor;
      anotacaoSelecionada.data = DateTime.now().toString();
      // ignore: unused_local_variable
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _tituloController.clear();
    _descricaoController.clear();
    _valorController.clear();

    _recuperarAnotacoes();
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    // ignore: deprecated_member_use
    List<Anotacao> listTemporaria = List<Anotacao>();
    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listTemporaria.add(anotacao);
    }

    setState(() {
      _anotacoes = listTemporaria;
    });
    listTemporaria = null;

    print('Lista anotaçõe: ' + anotacoesRecuperadas.toString());
  }

  _formatarData(String data) {
    initializeDateFormatting('fr_FR', null);

    var formatador = DateFormat('d/M/y H:m:s');

    DateTime dataConvertida = DateTime.parse(data);

    // ignore: non_constant_identifier_names
    String DataFormatada = formatador.format(dataConvertida);

    return DataFormatada;
  }

  void share(BuildContext context, Anotacao anotacao) {
    final String text =
        "${anotacao.data} - \n${anotacao.titulo} - \n${anotacao.descricao} - \n${anotacao.valor}";
    Share.share(
      text,
      subject: anotacao.descricao,
    );
  }

  List<bool> _selection = [false, false, false];

  void upadateButton(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selection.length; i++) {
        _selection[i] = selectedIndex == i;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meus Recibos",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff0a0e21),
        elevation: 0,
      ),
      drawer: DrawerScreen(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context, index) {
                final anotacao = _anotacoes[index];
                return Container(
                  margin: EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * .30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xff0a0e21),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Text(
                              '${anotacao.id} - ${_formatarData(anotacao.data)}'
                              '\n'
                              '\n${anotacao.titulo}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${anotacao.descricao} \n'
                              'R\$ ${anotacao.valor}',
                              style: TextStyle(
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => share(context, anotacao),
                                    child: Icon(
                                      Icons.share_sharp,
                                      size: 30,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 28,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _exibirTelaCadastro(anotacao: anotacao);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 28,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            insetPadding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  10.0,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              "Excluir Recebimento",
                                            ),
                                            content: Builder(
                                              builder: (context) {
                                                return Container(
                                                  width: double.infinity,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        'Confirmar Exclusão?',
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                            height: 50,
                                                            child: TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                primary: Colors
                                                                    .white,
                                                              ),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text(
                                                                "Cancelar",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            height: 50,
                                                            child: TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff009933),
                                                                primary: Colors
                                                                    .white,
                                                              ),
                                                              onPressed: () {
                                                                _removerAnotacao(
                                                                    anotacao
                                                                        .id);

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                'Confirmar',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.remove_circle,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffff0040),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
