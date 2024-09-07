
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';

class CallLogScreen extends StatefulWidget {
  const CallLogScreen({super.key});

  @override
  _CallLogScreenState createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> with SingleTickerProviderStateMixin {
  List<CallLogEntry> callLogsList = [];
  List<Map<String, dynamic>> uploadedCallLogs = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCallLogs();
    fetchAndDisplayCallLogs(); // Fetch Firebase logs when initializing
  }

  Future<void> getCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();
    setState(() {
      callLogsList = entries.toList();
    });
    print("List OF Calls : ${callLogsList.length}");
    if (callLogsList.isNotEmpty) {
      print("Last Call Number : ${callLogsList.last.number}");
    }
  }

  Future<void> uploadCallLogsToFirebase(List<CallLogEntry> callLogsList) async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> callLogsData = callLogsList.map((entry) {
        return {
          'name': entry.name ?? 'Unknown',
          'number': entry.number,
          'callType': _mapCallType(entry.callType!),
          'duration': entry.duration ?? 0,
          'timestamp': entry.timestamp != null
              ? DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)
              : DateTime.now(),
        };
      }).toList();

      CollectionReference callLogsCollection = FirebaseFirestore.instance.collection('call_logs');
      DocumentReference document = callLogsCollection.doc(DateTime.now().millisecondsSinceEpoch.toString());

      await document.set({
        'call_data': callLogsData,
        'uploaded_at': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Call Logs Uploaded Successfully")),
      );
      print("Call logs successfully uploaded to Firebase!");
    } catch (e) {
      print("Failed to upload call logs: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload call logs: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAndDisplayCallLogs() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('call_logs')
          .orderBy('uploaded_at', descending: true)
          .get();

      print("Documents fetched from Firebase: ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic>? data = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        print("Fetched Data: $data");
        List<dynamic>? callLogsData = data?['call_data'];

        if (callLogsData != null) {
          setState(() {
            uploadedCallLogs = callLogsData.asMap().map((index, entry) {
              return MapEntry(index, {
                'name': entry['name'],
                'number': entry['number'],
                'callType': _mapStringToCallType(entry['callType']),
                'duration': entry['duration'],
                'timestamp': (entry['timestamp'] as Timestamp).millisecondsSinceEpoch,
                'id': querySnapshot.docs.first.id,
                'index': index, // Add index to each entry
              });
            }).values.toList();
          });
        } else {
          print("No call_data found in the document.");
          setState(() {
            uploadedCallLogs = [];
          });
        }
      } else {
        print("No documents found in the collection.");
        setState(() {
          uploadedCallLogs = [];
        });
      }
    } catch (e) {
      print("Failed to fetch call logs: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch call logs: $e")),
      );
    }
  }

  CallType _mapStringToCallType(String type) {
    switch (type) {
      case 'Incoming':
        return CallType.incoming;
      case 'Outgoing':
        return CallType.outgoing;
      case 'Missed':
        return CallType.missed;
      case 'Rejected':
        return CallType.rejected;
      case 'Blocked':
        return CallType.blocked;
      default:
        return CallType.unknown;
    }
  }

  String _mapCallType(CallType type) {
    switch (type) {
      case CallType.incoming:
        return 'Incoming';
      case CallType.outgoing:
        return 'Outgoing';
      case CallType.missed:
        return 'Missed';
      case CallType.rejected:
        return 'Rejected';
      case CallType.blocked:
        return 'Blocked';
      default:
        return 'Unknown';
    }
  }

  Future<void> deleteCallLog(String docId, int index) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('call_logs')
          .where(FieldPath.documentId, isEqualTo: docId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference document = querySnapshot.docs.first.reference;

        Map<String, dynamic>? data = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        List<dynamic>? callLogsData = data?['call_data'];

        if (callLogsData != null && index < callLogsData.length) {
          callLogsData.removeAt(index);

          await document.update({
            'call_data': callLogsData,
          });

          setState(() {
            // Refresh the call logs after deletion
            fetchAndDisplayCallLogs();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Call Log Deleted Successfully")),
          );
        } else {
          print("No call_data found or index out of bounds.");
        }
      } else {
        print("Document not found.");
      }
    } catch (e) {
      print("Failed to delete call log: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete call log: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade300,
          title: const Text('Call Logs', style: TextStyle(fontWeight: FontWeight.w500)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Device Logs'),
              Tab(text: 'Firebase Logs'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                uploadCallLogsToFirebase(callLogsList);
              },
              icon: Icon(Icons.upload, color: Colors.white),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildDeviceCallLogList(),
            _buildFirebaseCallLogList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCallLogList() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: callLogsList.length,
      itemBuilder: (context, index) {
        var entry = callLogsList[index];
        return ListTile(
          title: Text('${entry.number}', style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${entry.name}'),
              Text('Type: ${_mapCallType(entry.callType!)}'),
            ],
          ),
          trailing: Text('Duration: ${entry.duration ?? 0} seconds'),
        );
      },
    );
  }

  Widget _buildFirebaseCallLogList() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : uploadedCallLogs.isEmpty
        ? Center(child: Text('No call logs available from Firebase.'))
        : ListView.builder(
      itemCount: uploadedCallLogs.length,
      itemBuilder: (context, index) {
        var entry = uploadedCallLogs[index];
        return ListTile(
          title: Text('${entry['number']}', style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${entry['name']}'),
              Text('Type: ${entry['callType']}'),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Duration: ${entry['duration']} seconds'),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    print("Deleting call log with name: ${entry['name']}, index: $index");
                    deleteCallLog(entry['id'], entry['index']);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
