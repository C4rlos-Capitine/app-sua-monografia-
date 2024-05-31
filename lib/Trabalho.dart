import 'package:http/http.dart' as http;
import 'dart:convert';

class Trabalho{
  String tema;
  String nome_est;
  Trabalho({
    required this.tema,
    required this.nome_est
});
}
Future<List> getTemas(id_minor) async{
  String uri = "http://192.168.18.183/DS-2023/api_get_temas_curso.php?id_minor=$id_minor";
  List trabalhos = [];
  try{
    var response = await http.get(Uri.parse(uri));

    trabalhos = jsonDecode(response.body);
    print('data $trabalhos');

  }catch(e){
    print(e);
  }
  return trabalhos;
}
