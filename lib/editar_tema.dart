import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'estudante.dart' as globals;
class editar_tema extends StatefulWidget {
  const editar_tema({Key? key}) : super(key: key);

  @override
  State<editar_tema> createState() => _State();
}

class _State extends State<editar_tema> {
  final temaController = TextEditingController();
  final descController = TextEditingController();
  late Map <String, dynamic> estudante;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getData();
    });
  }
  Future<void> getData() async{
    //var map = ModalRoute.of(context)?.settings as Map<String, String>;
    var routeSettings = ModalRoute.of(this.context)?.settings;
    if (routeSettings != null && routeSettings.arguments != null) {
      estudante = routeSettings.arguments as Map<String, dynamic>;
      // Use the arguments map here
      print(estudante['codigo_estudante']);
      print(estudante['id_minor']);
    }

  }
  Future<bool> editar() async{
    bool success = false;

    try {
      var res = await http.post(
          Uri.parse("http://192.168.90.54/DS-2023/api_editar_tema.php"),
          body: {
            'codigo_estudante': estudante['codigo_estudante'],
            //'id_minor': estudante['id_minor'],
            'tema': temaController.text,
            'descricao': descController.text
          }
      );

      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        //print(response.body);
        if (response['success'] == 'true') {
          print("tema registado com sucesso sucedido");
          setState(() {
            globals.est.estado = "1";
          });
          success = true;
        } else {
          print("registo falhou");
          //mensagem_erro();
          success = false;
        }
      } else {
        print("Server returned status code: ${res.statusCode}");
      }
    }catch(e){
      print(e);
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar tema"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,//space between components
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Editar tema"),

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
                    bool resp = await editar();
                    if(resp){
                      Fluttertoast.showToast(
                          msg: "Tema Editado com Sucesso",
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

