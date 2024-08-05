import 'package:flutter/material.dart';
import 'merma_componentes.dart';
import 'merma_lamparas.dart';
// import 'merma_componentes_usuario.dart';
// import 'merma_lamparas_usuario.dart';

class MermaPage extends StatelessWidget {
  final Function(Widget) onSelectPage;

  MermaPage({required this.onSelectPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFC99838),
        title: const Text(
          'Merma',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  onSelectPage(MermaComponentesPage());
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Mermas Componentes'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  onSelectPage(MermaLamparasPage());
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Mermas Lámparas'),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: TextButton(
            //     onPressed: () {
            //       onSelectPage(MermaComponentesUsuarioPage());
            //     },
            //     style: TextButton.styleFrom(
            //       backgroundColor: Colors.yellow,
            //       foregroundColor: Colors.black,
            //       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            //       textStyle:
            //           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: Text('Componentes Usuario'),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: TextButton(
            //     onPressed: () {
            //       onSelectPage(MermaLamparasUsuarioPage());
            //     },
            //     style: TextButton.styleFrom(
            //       backgroundColor: Colors.yellow,
            //       foregroundColor: Colors.black,
            //       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            //       textStyle:
            //           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: Text('Lámparas Usuario'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
