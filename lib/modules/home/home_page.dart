import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/routing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _products = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading data
    Future.delayed(const Duration(seconds: 2)).then((_) {
      setState(() {
        _isLoading = false;
        _products.addAll(List.generate(
            20, (index) => "Product ${_products.length + index + 1}"));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Nome do Usuário"),
              accountEmail: Text("email@usuario.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://picsum.photos/200"),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              onTap: () {
                // Ir para a tela de perfil
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Meus produtos"),
              onTap: () {
                // Ir para a tela de meus produtos
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Configurações"),
              onTap: () {
                // Ir para a tela de configurações
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                // Ir para a tela de login
                await FirebaseAuth.instance.signOut().whenComplete(
                    () => context.pushReplacementNamed(AppRoutes.login.name));
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                if (index == _products.length) {
                  return _buildProgressIndicator();
                } else {
                  return _buildProductCard(context, _products[index]);
                }
              },
            ),
    );
  }

  Widget _buildProductCard(BuildContext context, String product) {
    return InkWell(
      onTap: () {
        context.pushNamed(AppRoutes.product.name, queryParams: {
          'productName': product,
          'description': "That's my product"
        });
      },
      child: Card(
        child: Row(
          children: [
            Image.network(
              "https://picsum.photos/200",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),
            Text(product),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
