import 'package:flutter/material.dart';

class Tela4 extends StatelessWidget {
  final List<Map<String, String>> postagens = [
    {
      'titulo': 'Primeira postagem',
      'conteudo': 'Essa é a primeira postagem incrível da comunidade!',
    },
    {
      'titulo': 'Notícia quente!',
      'conteudo': 'Novo recurso lançado no app hoje mesmo! Confira já!',
    },
    {
      'titulo': 'Dica do dia',
      'conteudo': 'Mantenha seu código limpo e seus bugs longe.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Postagens', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
      ),
      body: postagens.isEmpty
          ? Center(child: Text('Nenhuma postagem disponível.'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: postagens.length,
              itemBuilder: (context, index) {
                final postagem = postagens[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(postagem['titulo'] ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(postagem['conteudo'] ?? ''),
                    ),
                    leading: Icon(Icons.article_outlined,
                        color: Colors.pink.shade300),
                  ),
                );
              },
            ),
    );
  }
}
