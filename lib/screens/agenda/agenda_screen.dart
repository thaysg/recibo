import 'package:flutter/material.dart';
import 'package:recibo/components/buttons.dart';
import 'package:recibo/components/components.dart';
import 'package:recibo/components/constants.dart';
import 'package:recibo/components/dados_tile.dart';
import 'package:recibo/components/delete_data.dart';
import 'package:recibo/components/list_tile_button.dart';
import 'package:recibo/components/my_container.dart';
import 'package:recibo/screens/agenda/helpers/agenda_helper.dart';
import 'package:recibo/screens/agenda/models/agenda.dart';
import 'package:share/share.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _calendarioController = TextEditingController();

  var _db = AgendaHelper();
  // ignore: deprecated_member_use
  List<Agenda> _agendas = List<Agenda>();

  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/## ##:##', filter: {"#": RegExp(r'[0-9]')});

  _exibirTelaCadastro({Agenda agenda}) {
    String textoSalvarAtualizar = '';
    if (agenda == null) {
      _tituloController.text;
      _descricaoController.text;
      _calendarioController.text;
      textoSalvarAtualizar = 'Salvar';
    } else {
      _tituloController.text = agenda.titulo;
      _descricaoController.text = agenda.descricao;
      _calendarioController.text = agenda.calendario;
      textoSalvarAtualizar = 'Atualizar';
    }
    showDialog(
      context: context,
      builder: (context) {
        return DialogScreen(
          alertTitle: 'Agenda',
          myWidget: Column(
            children: [
              TextField(
                inputFormatters: [maskFormatter],
                style: kTextFieldColor,
                controller: _calendarioController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Calendario",
                  labelStyle: kTextFieldColor,
                  hintStyle: kTextFieldColor,
                  hintText: "01/01/21 12:00",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                style: kTextFieldColor,
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: "Nome",
                  labelStyle: kTextFieldColor,
                  hintStyle: kTextFieldColor,
                  hintText: "Digite o nome...",
                ),
              ),
              TextField(
                style: kTextFieldColor,
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  labelStyle: kTextFieldColor,
                  hintStyle: kTextFieldColor,
                  hintText: "Digite descrição...",
                ),
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
                          _salvarAtualizarAgenda(agendaSelecionada: agenda);
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

  _removerAgenda(int id) async {
    await _db.removerAgenda(id);
    _recuperarAgenda();
  }

  _salvarAtualizarAgenda({Agenda agendaSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    String calendario = _calendarioController.text;

    print('data atual: ' + DateTime.now().toString());
    print(titulo);
    print(descricao);
    print(calendario);

    if (agendaSelecionada == null) {
      Agenda agenda =
          Agenda(titulo, descricao, calendario, DateTime.now().toString());

      int resultado = await _db.salvarAgenda(agenda);
      print('salvar anotacao ' + resultado.toString());
    } else {
      agendaSelecionada.titulo = titulo;
      agendaSelecionada.descricao = descricao;
      agendaSelecionada.calendario = calendario;
      agendaSelecionada.data = DateTime.now().toString();
      // ignore: unused_local_variable
      int resultado = await _db.atualizarAgenda(agendaSelecionada);
    }

    _tituloController.clear();
    _descricaoController.clear();
    _calendarioController.clear();

    _recuperarAgenda();
  }

  _recuperarAgenda() async {
    List agendaRecuperadas = await _db.recuperarAgenda();

    // ignore: deprecated_member_use
    List<Agenda> listTemporaria = List<Agenda>();
    for (var item in agendaRecuperadas) {
      Agenda agenda = Agenda.fromMap(item);
      listTemporaria.add(agenda);
    }

    setState(() {
      _agendas = listTemporaria;
    });
    listTemporaria = null;

    print('Lista anotaçõe: ' + agendaRecuperadas.toString());
  }

  void share(BuildContext context, Agenda agenda) {
    final String text =
        "${agenda.data} - \n${agenda.titulo} - \n${agenda.descricao} - \n${agenda.calendario}";
    Share.share(
      text,
      subject: agenda.descricao,
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
    _recuperarAgenda();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agenda",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff0a0e21),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_alert,
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
              itemCount: _agendas.length,
              itemBuilder: (context, index) {
                final agenda = _agendas[index];
                return MyContainer(
                    myChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: DadosTile(
                        dadosText: 'Data Evento: ${agenda.calendario}',
                      ),
                    ),
                    Expanded(
                      child: DadosTile(
                        dadosText: '${agenda.titulo} \n'
                            '${agenda.descricao} \n',
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ListTileButton(
                              onPress: () => share(context, agenda),
                              myIcon: Icon(
                                Icons.share_sharp,
                                size: 30,
                                color: Colors.indigo[900],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTileButton(
                              onPress: () {
                                _exibirTelaCadastro(agenda: agenda);
                              },
                              myIcon: Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.green[900],
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
                                        alertTitle: 'Excluir Evento',
                                        onTap: () {
                                          _removerAgenda(agenda.id);

                                          Navigator.pop(context);
                                        },
                                      );
                                    });
                              },
                              myIcon: Icon(
                                Icons.remove_circle,
                                size: 30,
                                color: Colors.red[900],
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
