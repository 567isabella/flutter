import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ======================== CADASTRAR POSTAGEM ========================
class CadastrarPostagem extends StatefulWidget {
  final String username;
  CadastrarPostagem({required this.username});

  @override
  CadastrarPostagemEstado createState() => CadastrarPostagemEstado();
}

class CadastrarPostagemEstado extends State<CadastrarPostagem> {
  final tituloControle = TextEditingController();
  final conteudoControle = TextEditingController();
  final imagemControle = TextEditingController();

  Future<void> cadastrarPostagem() async {
    final titulo = tituloControle.text;
    final conteudo = conteudoControle.text;
    final imagem = imagemControle.text;

    if (titulo.isNotEmpty && conteudo.isNotEmpty) {
      try {
        final url = Uri.parse("https://senac2025-1a776-default-rtdb.firebaseio.com/postagem.json");
        final resposta = await http.post(
          url,
          body: jsonEncode({
            'titulo': titulo,
            'conteudo': conteudo,
            'imagem': imagem,
            'autor': widget.username,
          }),
        );

        if (resposta.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Postagem enviada com sucesso!"),
            backgroundColor: Colors.green,
          ));
          tituloControle.clear();
          conteudoControle.clear();
          imagemControle.clear();
        } else {
          throw Exception("Erro ao enviar");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erro ao postar: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastre seu post!'),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: tituloControle, decoration: InputDecoration(labelText: 'Título da Postagem')),
            SizedBox(height: 16),
            TextField(
              controller: conteudoControle,
              decoration: InputDecoration(labelText: 'Conteúdo da Postagem'),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            TextField(controller: imagemControle, decoration: InputDecoration(labelText: 'Link da imagem')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: cadastrarPostagem, child: Text("Postar")),
          ],
        ),
      ),
    );
  }
}

// ======================== VER TODAS AS POSTAGENS ========================
class VerPostagens extends StatelessWidget {
  Future<List<Map<String, dynamic>>> buscarPostagens() async {
    final url = Uri.parse('https://senac2025-1a776-default-rtdb.firebaseio.com/postagem.json');
    final resposta = await http.get(url);
    final Map<String, dynamic>? dados = jsonDecode(resposta.body);

    final List<Map<String, dynamic>> posts = [];
    dados?.forEach((key, valor) {
      posts.add({
        'titulo': valor['titulo'],
        'conteudo': valor['conteudo'],
        'autor': valor['autor'],
        'imagem': valor['imagem'],
      });
    });
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ver postagens!"),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: buscarPostagens(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Erro ao carregar postagens!"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("Sem postagens para exibir"));

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    if (post['imagem'] != null && post['imagem'].isNotEmpty)
                      Image.network(post['imagem'], width: 400),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(post['titulo'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(post['conteudo']),
                          SizedBox(height: 16),
                          Icon(Icons.person_pin, color: Colors.pink.shade300),
                          Text("Autor: ${post['autor']}", style: TextStyle(fontSize: 14, color: Colors.pink.shade300)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ======================== MINHAS POSTAGENS ========================
class MinhasPostagens extends StatefulWidget {
  final String username;
  MinhasPostagens({required this.username});
  @override
  MinhasPostagensEstado createState() => MinhasPostagensEstado();
}

class MinhasPostagensEstado extends State<MinhasPostagens> {
  late Future<List<Map<String, dynamic>>> futuroPost;

  @override
  void initState() {
    super.initState();
    futuroPost = buscarPostagens();
  }

  Future<void> deletar(String id) async {
    final url = Uri.parse("https://senac2025-1a776-default-rtdb.firebaseio.com/postagem/$id.json");
    await http.delete(url);
    setState(() {
      futuroPost = buscarPostagens();
    });
  }

  Future<List<Map<String, dynamic>>> buscarPostagens() async {
    final url = Uri.parse('https://senac2025-1a776-default-rtdb.firebaseio.com/postagem.json');
    final resposta = await http.get(url);
    final Map<String, dynamic>? dados = jsonDecode(resposta.body);

    final List<Map<String, dynamic>> posts = [];
    dados?.forEach((key, valor) {
      if (valor['autor'] == widget.username) {
        posts.add({
          'id': key,
          'titulo': valor['titulo'],
          'conteudo': valor['conteudo'],
          'autor': valor['autor'],
          'imagem': valor['imagem'],
        });
      }
    });
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas postagens"),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futuroPost,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Erro ao carregar postagens!"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("Você ainda não postou nada 😢"));

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    if (post['imagem'] != null && post['imagem'].isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(post['imagem'], width: 400),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          Text(post['titulo'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(post['conteudo']),
                          SizedBox(height: 16),
                          Icon(Icons.person_pin, color: Colors.pink.shade300),
                          Text("Autor: ${post['autor']}", style: TextStyle(fontSize: 14, color: Colors.pink.shade300)),
                          ElevatedButton(
                            onPressed: () async {
                              await deletar(post['id']);
                            },
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
