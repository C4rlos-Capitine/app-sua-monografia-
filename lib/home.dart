import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'Trabalho.dart';
import 'estudante.dart' as globals;

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _State();
}

class _State extends State<home> {
  late Map <String, dynamic> estudante;
  Color colorFaseUm = Colors.red;
  Color colorFaseDois =  Colors.red;
  Color colorFaseTrez =  Colors.red;
  Color colorFaseQuatro =  Colors.red;
  List<dynamic> trabalhos = []; // Update the type of trabalhos
  var nome = "";
  var apelido = "";
  var curso = "";
  var minor = "";
  var tema = "";
  var estado = "";
  var id_minor ="";
  var est_tema = "";
  var est_pre = "";
  var est_monografia="";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async{
      await getData();
      trabalhos = await getTemas(id_minor); // Await the completion of getTemas()
      print(trabalhos);
    });
  }

  Future<void> getData() async{
    //var map = ModalRoute.of(context)?.settings as Map<String, String>;
    var routeSettings = ModalRoute.of(context)?.settings;
    if (routeSettings != null && routeSettings.arguments != null) {
      estudante = routeSettings.arguments as Map<String, dynamic>;
      print(estudante);
      // Use the arguments map here
    }
    setState(() {
      nome = estudante['nome_estudante'];
      apelido = estudante['apelido'];
      curso = estudante['designacao'];
      minor = estudante['designacao_minor'];
      id_minor = estudante['id_minor'];
      if(estudante['tema'] != null){
        tema = estudante["tema"];
      }
      //
      print(id_minor);
      globals.est = new globals.Estudante(nome: estudante['nome_estudante'], apelido: estudante['apelido'], estado: estudante['estado'], id_minor: estudante['id_minor'], codigo_est: estudante["codigo_estudante"]);
    });
    if(globals.est.estado == "2"){
      setState(() {
        est_tema= "aprovado";
        colorFaseUm = Colors.green[500]!;
        estado = "25%";
      });

    }if(globals.est.estado == "-1"){
      setState(() {
        est_tema = "tema reprovado 0%";
        estado = "0%";
      });
    }

    if(globals.est.estado == "0"){
      setState(() {
        est_tema = "sem tema 0%";
        estado = "0%";
      });
    }
    if(globals.est.estado == "3"){
      setState(() {
        est_pre = "em avaliacao";
        colorFaseUm = Colors.green[500]!;
        estado = "0%";
      });

    }
    if(globals.est.estado == "4"){
      setState(() {
        est_pre = "aprovado";
        est_tema = " aprovado";
        colorFaseUm = Colors.green[500]!;
        colorFaseDois = Colors.green[500]!;
        estado = "50%";
      });

    }
    if(globals.est.estado == "5"){
      setState(() {
        est_monografia = "em avaliacao";
        est_pre = "aprovado";
        est_tema = " aprovado";
        colorFaseUm = Colors.green[500]!;
        colorFaseDois = Colors.green[500]!;
        estado = "75%";
      });
    }
    if(globals.est.estado == "6"){
      setState(() {
        est_monografia = "aprovada";
        est_pre = "aprovado";
        est_tema = " aprovado";
        colorFaseUm = Colors.green[500]!;
        colorFaseDois = Colors.green[500]!;
        estado= "100%";
        });
    }
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Sist. Gest. TCC"),
            backgroundColor: Colors.blueAccent,
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.home),
                child: Text("home"),
              ),
              Tab(
                  icon: Icon(Icons.task),
                  child: Text("temas defendidos")),
              Tab(
                icon: Icon(Icons.task),
                child: Text("meu trabalho"),
              ),
            ]),
          ),
          body: TabBarView(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,//space between components
                    //crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("nome: $nome", style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                            padding: EdgeInsets.all(20.0),
                          )

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Curso: $curso", style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                            padding: EdgeInsets.all(20.0),
                          )

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Minor: $minor", style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                            padding: EdgeInsets.all(20.0),
                          )

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("tema: $tema", style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                            color: Colors.white,
                            margin: EdgeInsets.all(10.0),
                            padding: EdgeInsets.all(20.0),
                          )

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: (){
                                if(globals.est.estado == "0" || globals.est.estado == "-1") {
                                  Navigator.pushNamed(context, '/reg_trabalho',
                                      arguments: estudante);
                                }else{
                                  Fluttertoast.showToast(
                                      msg: "Nao pode regitar o tema neste momento",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.deepOrangeAccent,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }

                            },
                            label: Text("Registar trabalho"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent
                            ), icon: Icon(Icons.app_registration),
                          ),

                          ElevatedButton.icon(
                            onPressed: (){
                              if(globals.est.estado == "-1") {
                                Navigator.pushNamed(context, '/editar_tema', arguments: estudante);
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Nao pode editar o tema neste momento",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.deepOrangeAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            },
                            label: Text("Editar tema"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent
                            ), icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              if(globals.est.estado == "2") {
                                Navigator.pushNamed(
                                    context, '/submeter_trabalho',
                                    arguments: estudante);
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Nao pode submeter o tema neste momento",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.deepOrangeAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }

                            },
                            child: Text("Submeter pre-projecto"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent
                            ),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              if(globals.est.estado == "4") {
                                Navigator.pushNamed(
                                    context, '/submeter_monografia',
                                    arguments: estudante);
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Nao pode submeter o tema neste momento",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.deepOrangeAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            },
                            child: Text("Submeter Monografia"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
//trabalhos
               //ABA DOS TEMAS
                Scaffold(
                  body: Container(
                    child: ListView.builder(
                        itemCount: trabalhos.length,
                        itemBuilder: (context, index) {
                          //trabalho = trabalhos[index];
                          return Card(
                            child: ListTile(
                              title: Text(trabalhos[index]['tema']),
                              subtitle: Text(trabalhos[index]['descricao']),
                              trailing: Icon(Icons.arrow_forward_ios_outlined),
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDatailsScreen(movie)));
                              },
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  //mainAxisSize: MainAxisSize.min,
                  //children: [Text("ola3"), Text("Mundo3"), Text("2023")],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,//space between components
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:  [

                      Card(
                        child: Text("Estado do trabalho: $estado", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Card(
                        child: Text("Tema: $est_tema", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        color: colorFaseUm,
                      ),
                      Card(
                        child: Text("Pre-projecto: $est_pre", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        color: colorFaseDois,
                      ),
                      Card(
                        child: Text("Monografia: $est_monografia ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),

                    color: colorFaseTrez,
                      ),
                      Card(
                        child: Text("Monografia: $est_monografia", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),

                        color: colorFaseQuatro,
                      ),
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
