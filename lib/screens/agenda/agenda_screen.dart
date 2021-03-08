import 'package:flutter/material.dart';
import 'package:recibo/screens/agenda/helpers/agenda_helper.dart';
import 'package:recibo/drawer/drawer_navigation.dart';
import 'package:recibo/screens/agenda/models/agenda.dart';
import 'package:share/share.dart';

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
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Agenda"),
          content: Builder(
            builder: (context) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _calendarioController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Calendario",
                        hintText: "01/01/2021 12:00",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        labelText: "Nome",
                        hintText: "Digite o nome...",
                      ),
                    ),
                    TextField(
                      controller: _descricaoController,
                      decoration: InputDecoration(
                          labelText: "Descrição",
                          hintText: "Digite descrição..."),
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
                              _salvarAtualizarAgenda(agendaSelecionada: agenda);
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
      ),
      drawer: DrawerScreen(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _agendas.length,
              itemBuilder: (context, index) {
                final agenda = _agendas[index];
                return Container(
                  margin: EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * .20,
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
                              'Data Evento: ${agenda.calendario}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${agenda.titulo}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${agenda.descricao} \n',
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
                                    onTap: () => share(context, agenda),
                                    child: Icon(
                                      Icons.share_sharp,
                                      size: 30,
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 28,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _exibirTelaCadastro(agenda: agenda);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: Colors.greenAccent,
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
                                                                _removerAgenda(
                                                                    agenda.id);

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
                                      color: Colors.redAccent,
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
