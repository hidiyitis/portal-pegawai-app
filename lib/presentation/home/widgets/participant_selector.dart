import 'package:flutter/material.dart';

class Participant {
  final String name;
  final String avatarUrl;
  bool isSelected;

  Participant({
    required this.name,
    required this.avatarUrl,
    this.isSelected = false,
  });
}

class ParticipantSelector extends StatefulWidget {
  final List<Participant> participants;
  final void Function(List<Participant>) onSelected;

  const ParticipantSelector({
    super.key,
    required this.participants,
    required this.onSelected,
  });

  @override
  State<ParticipantSelector> createState() => _ParticipantSelectorState();
}

class _ParticipantSelectorState extends State<ParticipantSelector> {
  List<Participant> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = List.from(widget.participants);
  }

  void _filter(String query) {
    setState(() {
      filteredList =
          widget.participants
              .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Partisipan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Nama',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filter,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final participant = filteredList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(participant.avatarUrl),
                    ),
                    title: Text(participant.name),
                    trailing: Icon(
                      participant.isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: participant.isSelected ? Colors.teal : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        participant.isSelected = !participant.isSelected;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final selected =
                      widget.participants.where((p) => p.isSelected).toList();
                  widget.onSelected(selected);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ADB5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
