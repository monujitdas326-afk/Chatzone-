// lib/features/status/screens/status_screen.dart
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // My Status
        ListTile(
          leading: Stack(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          title: const Text(
            'My status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Tap to add status update'),
          onTap: () => _createNewStatus(context),
        ),
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent updates',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('status')
                .where('expiresAt', isGreaterThan: DateTime.now())
                .orderBy('expiresAt')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final statuses = snapshot.data!.docs;
              
              return ListView.builder(
                itemCount: statuses.length,
                itemBuilder: (context, index) {
                  final status = StatusModel.fromMap(
                    statuses[index].data() as Map<String, dynamic>,
                  );
                  return StatusListItem(
                    status: status,
                    onTap: () => _viewStatus(context, status),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _createNewStatus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CreateStatusBottomSheet(
        onTextStatus: () => _createTextStatus(context),
        onPhotoStatus: () => _createPhotoStatus(context),
        onVideoStatus: () => _createVideoStatus(context),
      ),
    );
  }

  void _viewStatus(BuildContext context, StatusModel status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewScreen(
          status: status,
          onStatusViewed: _markStatusAsViewed,
        ),
      ),
    );
  }

  void _createTextStatus(BuildContext context) {}
  void _createPhotoStatus(BuildContext context) {}
  void _createVideoStatus(BuildContext context) {}
  void _markStatus