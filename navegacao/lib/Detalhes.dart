import 'package:flutter/material.dart';
import 'package:navegacao/Tela1.dart';
import 'package:url_launcher/url_launcher.dart';

class Detalhes extends StatelessWidget {
  final Pessoa pessoa;

  Detalhes({required this.pessoa});

  void _ligar(String telefone) async {
    final Uri telefoneUrl = Uri(scheme: "tel", path: telefone);
    if (await canLaunchUrl(telefoneUrl)) {
      await launchUrl(telefoneUrl);
    }
  }

  void _enviarEmail(String email) async {
    final Uri emailUrl = Uri(scheme: "mailto", path: email);
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    }
  }

  void _abrirWhats(String telefone) async {
    final Uri whatsUrl = Uri.parse("https://wa.me/$telefone");
    if (await canLaunchUrl(whatsUrl)) {
      await launchUrl(whatsUrl);
    }
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.arrow_right, color: Colors.pink.shade300),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Contato"),
        backgroundColor: Colors.pink.shade300,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.person, size: 100, color: Colors.pink.shade300),
            SizedBox(height: 20),
            Text(
              pessoa.nome,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(height: 30, thickness: 1.5),
            _buildInfo("Nome", pessoa.nome),
            _buildInfo("Email", pessoa.email),
            _buildInfo("cpf", pessoa.cpf),
            _buildInfo("Telefone", pessoa.telefone),
            _buildInfo("Endereço", pessoa.endereco),
            _buildInfo("Cidade", pessoa.cidade),
            _buildInfo("Descrição dos Pets", pessoa.descricaoPets),
            SizedBox(height: 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.phone,
                  label: "Ligar",
                  onPressed: () => _ligar(pessoa.telefone),
                ),
                _buildActionButton(
                  icon: Icons.email,
                  label: "E-mail",
                  onPressed: () => _enviarEmail(pessoa.email),
                ),
                _buildActionButton(
                  icon: Icons.phone_iphone,
                  label: "WhatsApp",
                  onPressed: () => _abrirWhats(pessoa.telefone),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
