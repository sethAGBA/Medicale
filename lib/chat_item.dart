import 'package:flutter/material.dart';
import 'package:medical/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medical/config.dart';
import 'dart:io';

class ChatItem extends StatelessWidget {
  final UserModel user;
  final bool isLast;

  const ChatItem({Key? key, required this.user, this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5),
              ),
      ),
      child: ListTile(
        leading: _buildAvatar(user),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          user.lastMessage ?? "Dites Bonjour 👋",
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          user.lastMessageTime ?? "",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        onTap: () {
          // Naviguer vers l'écran de chat
          Navigator.pushNamed(context, '/chatRoom', arguments: user);
        },
      ),
    );
  }

  Widget _buildAvatar(UserModel user) {
    final photo = user.profilePhoto;
    if (photo == null || photo.isEmpty) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/images/nurse1.jpeg'),
      );
    }
    if (photo.startsWith('/')) {
      // Local file path
      return CircleAvatar(
        backgroundImage: FileImage(File(photo)),
      );
    }
    final isValidUrl = photo.startsWith('http://') || photo.startsWith('https://');
    final imageUrl = isValidUrl ? photo : Config.baseUrl + photo;
    return CircleAvatar(
      backgroundColor: Colors.white,
      backgroundImage: null,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.account_circle, color: Colors.grey, size: 40),
        ),
      ),
    );
  }
}