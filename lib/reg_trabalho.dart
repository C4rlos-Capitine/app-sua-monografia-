
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'estudante.dart' as globals;

class reg_trabalho extends StatefulWidget {
  const reg_trabalho({Key? key}) : super(key: key);

  @override
  State<reg_trabalho> createState() => _State();
}

class _State extends State<reg_trabalho> {
  late Map <String, dynamic> estudante;
  final temaController = TextEditingController();
  final descController = TextEditingController();
  String success = "";
  void mensagem_confirmacao(){
    Fluttertoast.showToast(
        msg: "Registado com Sucesso",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void mensagem_erro(){
    Fluttertoast.showToast(
        msg: "Erro",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getData();
      print("data from estudante file: ${globals.est.nome}");
    });
  }

  Future<void> getData() async{
    //var map = ModalRoute.of(context)?.settings as Map<String, String>;
    var routeSettings = ModalRoute.of(context)?.settings;
    if (routeSettings != null && routeSettings.arguments != null) {
      estudante = routeSettings.arguments as Map<String, dynamic>;
      // Use the arguments map here
      print(estudante['codigo_estudante']);
      print(estudante['id_minor']);
    }

  }
  
  Future<bool> registarTrab() async{
    bool resp = false;
    try {
      var res = await http.post(
          Uri.parse("http://192.168.18.183/DS-2023/api_reg_tema.php"),
          body: {
            'codigo_estudante': estudante['codigo_estudante'],
            'id_minor': estudante['id_minor'],
            'tema': temaController.text,
            'descricao': descController.text
          }
      );

      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        //print(response.body);
        if (response['success'] == 'true') {
          print("tema registado com sucesso sucedido");
          //mensagem_confirmacao();
          setState(() {
            globals.est.estado = "1";
          });
          resp = true;
        } else {
          print("registo falhou");
          //mensagem_erro();
        }
      } else {
        print("Server returned status code: ${res.statusCode}");
      }
    }catch(e){
      print(e);
    }
  return resp;
  }

  @override
  Widget build(BuildContext context) {return Scaffold(
      appBar: AppBar(
        title: Text("Sist. Gest. TCC"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,//space between components
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("registar trabalho $success"),

          Container(
            margin: const EdgeInsets.all(5),
            child: TextFormField(
              controller: temaController,
              decoration: InputDecoration(border: OutlineInputBorder(), label: Text("tema")),
            ),
          ),


          Container(
            margin: const EdgeInsets.all(5),
            child: TextFormField(
              controller: descController,
              decoration: InputDecoration(border: OutlineInputBorder(), label: Text("descricao")),
            ),
          ),
          Container(
              margin: const EdgeInsets.all(5),
              child:  ElevatedButton(
                  onPressed: () async{

                    bool resposta = await registarTrab();
                    if(resposta){
                      //mensagem_confirmacao();
                      Fluttertoast.showToast(
                          msg: "Registado com Sucesso",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.lightGreenAccent,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else{
                      Fluttertoast.showToast(
                          msg: "Erro no registo",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    }, child: Text("registar trabalho"))
          ),

        ],
      ),
    );
  }
}
