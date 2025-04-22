import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pessoa {
  String id;
  String nome;
  String cpf;
  String email;
  String telefone;
  String endereco;
  String cidade;
  String descricaoPets;

  Pessoa(
    this.id,
    this.nome,
    this.cpf,
    this.email,
    this.telefone,
    this.endereco,
    this.cidade,
    this.descricaoPets,
  );
}

class Cadastro extends StatefulWidget {
  final List<Pessoa> pessoas;

  const Cadastro({super.key, required this.pessoas});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final nomeControle = TextEditingController();
  final cpfControle = TextEditingController();
  final emailControle = TextEditingController();
  final telefoneControle = TextEditingController();
  final enderecoControle = TextEditingController();
  final cidadeControle = TextEditingController();
  final descricaoPets = TextEditingController();

  @override
  void dispose() {
    nomeControle.dispose();
    cpfControle.dispose();
    emailControle.dispose();
    telefoneControle.dispose();
    enderecoControle.dispose();
    cidadeControle.dispose();
    descricaoPets.dispose();
    super.dispose();
  }

  void limparCampos() {
    nomeControle.clear();
    cpfControle.clear();
    emailControle.clear();
    telefoneControle.clear();
    enderecoControle.clear();
    cidadeControle.clear();
    descricaoPets.clear();
  }

  Future<void> cadastrarPessoa(Pessoa pessoa) async {
    final url = Uri.parse('https://senac-a42c7-default-rtdb.firebaseio.com/pessoa.json');

    final resposta = await http.post(
      url,
      body: jsonEncode({
        'nome': pessoa.nome,
        'CPF': pessoa.cpf,
        'email': pessoa.email,
        'telefone': pessoa.telefone,
        'endereco': pessoa.endereco,
        'cidade': pessoa.cidade,
        'descricaoPets': pessoa.descricaoPets
      }),
    );

    if (resposta.statusCode == 200) {
      final idGerado = jsonDecode(resposta.body)['name'];

      setState(() {
        widget.pessoas.add(Pessoa(
          idGerado,
          pessoa.nome,
          pessoa.cpf,
          pessoa.email,
          pessoa.telefone,
          pessoa.endereco,
          pessoa.cidade,
          pessoa.descricaoPets,
        ));
      });

      limparCampos();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pessoas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nomeControle, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: cpfControle, decoration: const InputDecoration(labelText: 'cpf')),
            TextField(
              controller: emailControle,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: telefoneControle,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(controller: enderecoControle, decoration: const InputDecoration(labelText: 'Endereço')),
            TextField(controller: cidadeControle, decoration: const InputDecoration(labelText: 'Cidade')),
            TextField(controller: descricaoPets, decoration: const InputDecoration(labelText: 'Descrição de Pets')),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if ([
                      nomeControle.text,
                      cpfControle.text,
                      emailControle.text,
                      telefoneControle.text,
                      enderecoControle.text,
                      cidadeControle.text,
                      descricaoPets.text,
                    ].every((campo) => campo.isNotEmpty)) {
                  final novaPessoa = Pessoa(
                    "",
                    nomeControle.text,
                    cpfControle.text,
                    emailControle.text,
                    telefoneControle.text,
                    enderecoControle.text,
                    cidadeControle.text,
                    descricaoPets.text,
                  );
                  cadastrarPessoa(novaPessoa);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos!')),
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text("Salvar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade300,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
