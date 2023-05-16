import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Marteau.dart';
import 'dart:async';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

// Score courant
int scoreJ1 =0;
// Variable pour la communication entre Wifi et Marteau
int scoreJ1toJ2 = 0;
_WifiPageState? _wifiPageState;

class WifiPage extends StatefulWidget {
  const WifiPage({Key? key}) : super(key: key);

  @override
  State<WifiPage> createState() => _WifiPageState();
  
  //Réception du score envoyé depuis Marteau
  static Future<void> receiveScore(int score) async {
    print('Received count from CounterPage: $score');
    scoreJ1 = score;
    print('_wifiPageState: $_wifiPageState');
    _wifiPageState?.sendScore();
  }

  //permet d'avoir accès à sendScore dans notre classe
  static _WifiPageState? of(BuildContext context){
    final state = context.findAncestorStateOfType<_WifiPageState>();
    _wifiPageState = state;
    print('WifiPage State: $state');
    return state;
  }
}

class _WifiPageState extends State<WifiPage> with WidgetsBindingObserver {

  final TextEditingController msgText = TextEditingController();
  final _flutterP2pConnectionPlugin = FlutterP2pConnection();
  List<DiscoveredPeers> peers = [];
  WifiP2PInfo? wifiP2PInfo;
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;
  // Permet de gérer la connexion 
  bool areConnected = false;
  bool isSocketOpen = false;

  @override
  void initState() {
    super.initState();
    // Reset les informatons de connexion
    _flutterP2pConnectionPlugin.unregister();
    _flutterP2pConnectionPlugin.removeGroup();
    _flutterP2pConnectionPlugin.closeSocket();
    wifiP2PInfo = null;
    peers.clear();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
 
  //Permet de directement mettre les appareils en recherche d'autre appareils
  Future<bool> research() async {
    bool? discovering = await _flutterP2pConnectionPlugin.discover();
    snack("discovering $discovering");
    return discovering;
  }

  //Envoi du score 
  Future sendScore() async {
    sendMessageParam("ScoreJ1 : $scoreJ1");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _flutterP2pConnectionPlugin.unregister();
    } else if (state == AppLifecycleState.resumed) {
      _flutterP2pConnectionPlugin.register();
    }
  }

  void _init() async {
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamWifiInfo =
        _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      setState(() {
        wifiP2PInfo = event;
      });
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      setState(() {
        peers = event;
      });
    });

    await research(); //on attend que notre fonction soit utilisée
  }

  Future startSocket() async {
    if (wifiP2PInfo != null) {
      bool started = await _flutterP2pConnectionPlugin.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (name, address) {
          snack("$name connected to socket with address: $address");
          setState(() {
            areConnected = true; //cela nous permet de bien savoir si 2 appareils sont bien connectés entre eux
          });
        },
        transferUpdate: (transfer) {
        //   if (transfer.completed) {
        //     snack(
        //         "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
        //   }
        //   print(
        //       "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
         },
        receiveString: (req) async {
           if(req.startsWith('ScoreJ1 :')){ //si le message reçu commence par ScoreJ1 alors on le parse et on l'envoi
            int scoreJ1toJ2= int.parse(req.substring(10));
            Marteau.recScore(scoreJ1toJ2);
          }
        },
      );
      snack("open socket: $started");
      setState(() {
        isSocketOpen = true; //permet de savoir si l'hôte à ouvert le socket
      });
    }
  }

  Future connectToSocket() async {
    if (wifiP2PInfo != null) {
      await _flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 3,
        deleteOnError: true,
        onConnect: (address) {
          snack("connected to socket: $address");
        },
        transferUpdate: (transfer) {
          // if (transfer.count == 0) transfer.cancelToken?.cancel();
        //   if (transfer.completed) {
        //     snack(
        //         "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
        //   }
        //   print(
        //       "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
         },
        receiveString: (req) async {
          if(req == "START"){ // si la réponse est START alors on lance notre jeu (Marteau)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Marteau()) //Lance la partie du client
            );
          }
          if(req == "true"){
            isSocketOpen = true;
          }
          if(req.startsWith('ScoreJ1 :')){ //comme au dessus
            int scoreJ1toJ2= int.parse(req.substring(10));
            Marteau.recScore(scoreJ1toJ2);
          }
        },
      );
    }
  }

  Future closeSocketConnection() async {
    bool closed = _flutterP2pConnectionPlugin.closeSocket();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "closed: $closed",
        ),
      ),
    );
  }

  Future sendMessage() async {
    _flutterP2pConnectionPlugin.sendStringToSocket(msgText.text);
  }

  //fonction permettant d'avoir un param en entrée de send msg
  Future sendMessageParam(String msg) async {
    _flutterP2pConnectionPlugin.sendStringToSocket(msg);
  }
  
  void snack(String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          msg,
        ),
      ),
    );
  }
   
  @override
  Widget build(BuildContext context) {
    _wifiPageState = this;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //     "IP: ${wifiP2PInfo == null ? "null" : wifiP2PInfo?.groupOwnerAddress}"),
            // wifiP2PInfo != null
            //     ? Text(
            //         "connected: ${wifiP2PInfo?.isConnected}, isGroupOwner: ${wifiP2PInfo?.isGroupOwner}, groupFormed: ${wifiP2PInfo?.groupFormed}, groupOwnerAddress: ${wifiP2PInfo?.groupOwnerAddress}, clients: ${wifiP2PInfo?.clients}")
            //     : const SizedBox.shrink(),
            // const SizedBox(height: 10),
            const Text("Joueurs en ligne:"),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: peers.length,
                itemBuilder: (context, index) => Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Center(
                          child: AlertDialog(
                            content: SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("name: ${peers[index].deviceName}"),
                                  Text(
                                      "address: ${peers[index].deviceAddress}"),
                                  Text(
                                      "isGroupOwner: ${peers[index].isGroupOwner}"),
                                  Text(
                                      "isServiceDiscoveryCapable: ${peers[index].isServiceDiscoveryCapable}"),
                                  Text(
                                      "primaryDeviceType: ${peers[index].primaryDeviceType}"),
                                  Text(
                                      "secondaryDeviceType: ${peers[index].secondaryDeviceType}"),
                                  Text("status: ${peers[index].status}"),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  bool? bo = await _flutterP2pConnectionPlugin
                                      .connect(peers[index].deviceAddress);
                                  snack("connected: $bo");
                                },
                                child: const Text("connect"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          peers[index]
                              .deviceName
                              .toString()
                              .characters
                              .first
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if( wifiP2PInfo !=null && wifiP2PInfo!.isGroupOwner && !areConnected) //si les deux téléphones se sont connectés l'un à l'autre alors uniquement l'hote peut créer une partie (un socket)
            ElevatedButton(
              onPressed: () async {
                startSocket();
                await _flutterP2pConnectionPlugin.stopDiscovery();
              },
              child: const Text("Créer une partie"),
            ),
            if( wifiP2PInfo !=null && !wifiP2PInfo!.isGroupOwner && !areConnected && wifiP2PInfo?.isConnected==true) //si les deux téléphones se sont connectés l'un à l'autre alors uniquement le client peut rejoindre une partie (un socket)
            ElevatedButton(
              onPressed: () async {
                connectToSocket();
                await _flutterP2pConnectionPlugin.stopDiscovery();
              },
              child: const Text("Rejoindre une partie"),
            ),
            if (areConnected && wifiP2PInfo!.isGroupOwner)
              ElevatedButton(
                onPressed: () async {
                  _flutterP2pConnectionPlugin.sendStringToSocket('START');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Marteau()), //Lance la partie sur les téléphones
                  );
                },
                child: const Text("Lancer une partie"),
              )
          ],
        ),
      ),
    );
  }
}
