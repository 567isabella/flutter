import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:navegacao/Tela1.dart';
import 'package:navegacao/detalhes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class TabelaPai extends StatefulWidget {
  const TabelaPai({super.key});

  @override
  State<TabelaPai> createState() => Tabela();
}

class Tabela extends State<TabelaPai> {
  final List<Pessoa> pessoas = [];

  @override
  void initState() {
    super.initState();
    buscarPessoas();
  }

  Future<void> buscarPessoas() async {
    final url = Uri.parse('https://senac-a42c7-default-rtdb.firebaseio.com/pessoa.json');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final Map<String, dynamic>? dados = jsonDecode(resposta.body);

      if (dados != null) {
        setState(() {
          pessoas.clear(); // Evita duplicações
          dados.forEach((id, dadosPessoa) {
            pessoas.add(Pessoa(
              id,
              dadosPessoa['nome'] ?? '',
              dadosPessoa['CPF'] ?? '',
              dadosPessoa['email'] ?? '',
              dadosPessoa['telefone'] ?? '',
              dadosPessoa['endereco'] ?? '',
              dadosPessoa['cidade'] ?? '',
              dadosPessoa['descricaoPets'] ?? '',
            ));
          });
        });
      }
    } else {
      debugPrint("Erro ao buscar dados: ${resposta.statusCode}");
    }
  }

  Future<void> excluir(String id) async {
    final url = Uri.parse("https://senac-a42c7-default-rtdb.firebaseio.com/pessoa/$id.json");
    final resposta = await http.delete(url);

    if (resposta.statusCode == 200) {
      setState(() {
        pessoas.removeWhere((p) => p.id == id);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir contato')),
      );
    }
  }

  void abrirWhats(String telefone) async {
    final uri = Uri.parse("https://wa.me/$telefone");
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de contatos", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pessoas.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: pessoas.length,
                itemBuilder: (context, index) {
                  final pessoa = pessoas[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: Icon(Icons.person, color: Colors.pink.shade300),
                      title: Text(pessoa.nome),
                      subtitle: Text("Email: ${pessoa.email}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => abrirWhats(pessoa.telefone),
                            icon: Icon(Icons.message, color: Colors.pink.shade300),
                            tooltip: "Enviar mensagem no WhatsApp",
                          ),
                          IconButton(
                            onPressed: () => excluir(pessoa.id),
                            icon: Icon(Icons.delete_rounded, color: Colors.pink.shade300),
                            tooltip: "Excluir contato",
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Detalhes(pessoa: pessoa)),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
