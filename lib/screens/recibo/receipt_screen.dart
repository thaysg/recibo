import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recibo/components/buttons.dart';
import 'package:recibo/components/components.dart';
import 'package:recibo/components/constants.dart';
import 'package:recibo/components/dados_tile.dart';
import 'package:recibo/components/delete_data.dart';
import 'package:recibo/components/list_tile_button.dart';
import 'package:recibo/components/my_container.dart';
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
        return DialogScreen(
          alertTitle: 'Recebimento',
          myWidget: Column(
            children: [
              TextField(
                style: kTextFieldColor,
                controller: _tituloController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Nome",
                  labelStyle: kTextFieldColor,
                  hintText: "Digite o nome...",
                  hintStyle: kTextFieldColor,
                ),
              ),
              TextField(
                style: kTextFieldColor,
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  labelStyle: kTextFieldColor,
                  hintText: "Digite descrição...",
                  hintStyle: kTextFieldColor,
                ),
              ),
              TextField(
                style: kTextFieldColor,
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: "Valor",
                  labelStyle: kTextFieldColor,
                  prefixText: 'R\$ ',
                  prefixStyle: kTextFieldColor,
                ),
                keyboardType: TextInputType.number,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyButtons(
                        bgColour: Colors.redAccent,
                        textColour: Colors.white,
                        title: 'Cancelar',
                        onPress: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: MyButtons(
                        bgColour: Color(0xff009933),
                        textColour: Colors.white,
                        title: textoSalvarAtualizar,
                        onPress: () {
                          //salvar
                          _salvarAtualizarAnotacao(
                              anotacaoSelecionada: anotacao);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
        backgroundColor: kdefaultColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle,
              size: 32,
            ),
            onPressed: () {
              _exibirTelaCadastro();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context, index) {
                final anotacao = _anotacoes[index];
                return MyContainer(
                    myChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: DadosTile(
                        dadosText:
                            '${anotacao.id} - ${_formatarData(anotacao.data)}'
                            '\n'
                            '\n${anotacao.titulo}',
                      ),
                    ),
                    Expanded(
                      child: DadosTile(
                        dadosText: '${anotacao.descricao} \n'
                            'R\$ ${anotacao.valor}',
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ListTileButton(
                              onPress: () => share(context, anotacao),
                              myIcon: Icon(
                                Icons.share_sharp,
                                size: 30,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTileButton(
                              onPress: () {
                                _exibirTelaCadastro(anotacao: anotacao);
                              },
                              myIcon: Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTileButton(
                              onPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DeleteData(
                                        alertTitle: 'Excluir Recebimento',
                                        onTap: () {
                                          _removerAnotacao(anotacao.id);

                                          Navigator.pop(context);
                                        },
                                      );
                                    });
                              },
                              myIcon: Icon(
                                Icons.remove_circle,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
