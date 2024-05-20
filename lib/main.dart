import 'package:amrapp/cubit/cubit.dart';
import 'package:amrapp/services/service.dart';
import 'package:amrapp/ui/pages/page.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initTCP();
  runApp(const MyApp());

  // Add this code below
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1200, 800);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Automatic Mobile Robotic";
    win.maximize();
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DeviceCubit(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Automatic Mobile Robotic',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Builder(builder: (context) {
          // createTable(
          //   tableName: 'devices2',
          //   column:
          //       'amr_id VARCHAR NULL, pointer_img VARCHAR NULL, status INTEGER NULL',
          // );

          // migrate();
          // exec();
          // get(tableName: 'devices').then((value) => print(value));
          // final db = SqliteDatabase(path: dbName);
          // var data = db.getAll('SELECT * FROM devices');
          // print(data);

          // db.close();
          return DashboardPage();
        }),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xffFFFFFF),
    mouseOver: Color.fromARGB(255, 155, 152, 147),
    mouseDown: Color.fromARGB(255, 68, 67, 64),
    iconMouseOver: Color.fromARGB(255, 163, 161, 157),
    iconMouseDown: Color.fromARGB(255, 143, 143, 143));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: Color.fromARGB(255, 255, 255, 255),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
