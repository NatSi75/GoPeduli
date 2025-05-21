import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/features/authentication/general_bindings.dart';
import 'package:gopeduli/dashboard/routes/app_routes.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel GoPeduli',
      theme: ThemeData(fontFamily: 'Poppins'),
      getPages: GoPeduliAppRoutes.pages,
      initialBinding: GeneralBindings(),
      initialRoute: GoPeduliRoutes.dashboard,
      unknownRoute: GetPage(
          name: '/page-not-found',
          page: () => const Scaffold(
                  body: Center(
                child: Text('Page not found'),
              ))),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('First Screen'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Simple Navigation: Default Flutter Navigator VS GetX Navigation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SecondScreen(),
                    ),
                  );
                },
                child: const Text('Default Navigator'),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(const SecondScreen());
                },
                child: const Text('GetX Navigator'),
              ),
            ),
            const SizedBox(height: 50),
            const Divider(),
            const Text('Named Navigation: Flutter Navigator VS GetX Navigator',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/second-screen');
                },
                child: const Text('Default Named Navigation'),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/second-screen');
                },
                child: const Text('GetX Named Navigation'),
              ),
            ),
            const SizedBox(height: 50),
            const Divider(),
            const Text('Pass Data Between - GetX',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/second-screen',
                      arguments: 'GetX is fun with CwT');
                },
                child: const Text('GextX Pass Data'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/second-screen/1234');
                },
                child: const Text('Pass Data in URL'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/second-screen?device=phone&id=354&name=Enzo',
                      arguments: 'GetX is fun with CwT');
                },
                child: const Text('Pass Data in URL + Arguments'),
              ),
            ),
          ],
        )));
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Get.arguments ?? 'No data passed'),
          Text('Device - ${Get.parameters['device'] ?? 'No data passed'}'),
          Text('ID - ${Get.parameters['id'] ?? 'No data passed'}'),
          Text('Name - ${Get.parameters['name'] ?? 'No data passed'}'),
          Text('Name - ${Get.parameters['userId'] ?? 'No data passed'}'),
        ],
      )),
    );
  }
}
