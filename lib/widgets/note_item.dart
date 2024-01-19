import 'package:flutter/material.dart';

import '../model/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final Function onEdit, onDelete;

  const NoteItem(
      {required this.onDelete,
      required this.onEdit,
      required this.note,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  note.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  note.content,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '~ ${note.author}',
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          Positioned(
            top: -4,
            right: 0,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}
