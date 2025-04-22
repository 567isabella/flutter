import 'package:flutter/material.dart';

class Tela3 extends StatefulWidget {
  @override
  State<Tela3> createState() => _Tela3State();
}

class _Tela3State extends State<Tela3> {
  final tituloController = TextEditingController();
  final conteudoController = TextEditingController();

  @override
  void dispose() {
    tituloController.dispose();
    conteudoController.dispose();
    super.dispose();
  }

  void salvarPostagem() {
    final titulo = tituloController.text.trim();
    final conteudo = conteudoController.text.trim();

    if (titulo.isEmpty || conteudo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    // Aqui você poderia salvar a postagem no Firebase ou localmente
    print("Postagem salva: $titulo - $conteudo");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Postagem criada com sucesso!')),
    );

    tituloController.clear();
    conteudoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Postagem', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título da postagem'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: conteudoController,
              decoration: InputDecoration(labelText: 'Conteúdo'),
              maxLines: 5,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: salvarPostagem,
              icon: Icon(Icons.send),
              label: Text("Publicar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade300,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
