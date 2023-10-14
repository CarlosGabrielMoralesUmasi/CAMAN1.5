// inicial snippet code for login.dart
import 'package:flutter/material.dart';
import 'package:empresas_cliente/screens/history_list.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


//! Stados de los servicios
//! 0: pending
//! 1: accepted
//! 3: finished
//! 4: cancelled

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

// Widget _buildHistoryItem(String userId, int type) {
//   String status = '';

//   switch (type) {
//     case 0:
//       status = 'pending';
//       break;
//     case 1:
//       status = 'accepted';
//       break;
//     case 2:
//       status = 'rejected';
//       break;
//     case 3:
//       status = 'finished';
//       break;
//     default:
//       status = 'Pendiente';
//   }

//   final db = FirebaseFirestore.instance;
//   final Stream<QuerySnapshot> servicesStream = db
//       .collection('clients')
//       .doc(userId)
//       .collection('services')
//       .where('status', isEqualTo: status)
//       .snapshots();

//   return StreamBuilder<QuerySnapshot>(
//     stream: servicesStream,
//     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//       if (snapshot.hasError) {
//         return const Text('Something went wrong');
//       }

//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Text("Loading");
//       }

//       return ListView(
//         children: snapshot.data!.docs.map((DocumentSnapshot document) {
//           Future workerName = db
//               .collection('clients')
//               .doc(document['workerId'])
//               .get()
//               .then((DocumentSnapshot document) => document['name']);
//           Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 //linea
//                 const Divider(
//                   height: 20,
//                   thickness: 5,
//                   endIndent: 20,
//                 ),
//                 Row(
//                   children: [
//                     Column(children: [
//                       FutureBuilder(
//                         future: workerName,
//                         builder: (BuildContext context,
//                             AsyncSnapshot<dynamic> snapshot) {
//                           if (snapshot.hasData) {
//                             return Text(
//                               snapshot.data.toString(),
//                               style: const TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold),
//                             );
//                           } else {
//                             return const Text('Loading...');
//                           }
//                         },
//                       ),
//                       Text(
//                         data['date'],
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         data['time'],
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ]),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       );
//     },
//   );
// }

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    //String clientId = context.read<UserProvider>().userId;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(left: 16.0, top: 13, right: 16.0, bottom: 13),
              child: Text(
                'Historial',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context, 
                    screen: const HistoryList(type: 'pending',),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino
                  );
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all<double>(0.0),
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pending_actions,
                      color: Colors.black.withOpacity(0.4),
                      size: 19.0,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Pendientes",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: textScale * 19.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black.withOpacity(0.4),
                      size: 19.0,
                    ),
                  ],
                ),
              ),
            ),
            //* aceptados
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context, 
                    screen: const HistoryList(type: 'accepted',),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino
                  );
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all<double>(0.0),
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.black.withOpacity(0.4),
                      size: 19.0,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Aceptados",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: textScale * 19.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black.withOpacity(0.4),
                      size: 19.0,
                    ),
                  ],
                ),
              ),
            ),
            //* cancelados
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context, 
                    screen: const HistoryList(type: 'cancelled',),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino
                  );
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all<double>(0.0),
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: Colors.black.withOpacity(0.4),
                      size: 19.0,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Cancelados",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: textScale * 19.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black.withOpacity(0.4),
                      size: 19.0,
                    ),
                  ],
                ),
              ),
            ),
            //* finalizados
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context, 
                    screen: const HistoryList(type: 'finished',),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino
                  );
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all<double>(0.0),
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.black.withOpacity(0.4),
                      size: 19.0,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Finalizados",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: textScale * 19.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black.withOpacity(0.4),
                      size: 19.0,
                    ),
                  ],
                ),
              ),
            ),
            // pending
            // const Padding(
            //   padding:
            //       EdgeInsets.only(left: 16.0, top: 13, right: 16.0, bottom: 13),
            //   child: Text(
            //     'Pendientes',
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // SizedBox(height: 300, child: _buildHistoryItem(clientId, 0)),
            // // finished
            // const Padding(
            //   padding:
            //       EdgeInsets.only(left: 16.0, top: 13, right: 16.0, bottom: 13),
            //   child: Text(
            //     'Finalizados',
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
