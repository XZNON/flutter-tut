import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bucket_location_provider.dart';
import 'location_picker.dart';

class BucketListScreen extends StatelessWidget {
  const BucketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BucketLocationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Bucket List Locations")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final provider = context.read<BucketLocationProvider>();
          final messenger = ScaffoldMessenger.of(context);
          final navigator = Navigator.of(context);
          final result = await navigator.push(
            MaterialPageRoute(builder: (_) => const LocationPicker()),
          );

          if (result != null) {
            try {
              await provider.add(
                result["name"],
                result["lat"],
                result["lng"],
                result["address"],
              );
            } catch (e) {
              messenger.showSnackBar(
                const SnackBar(content: Text("failed to add location: ")),
              );
              throw Exception(e);
            }
          }
        },
        child: const Icon(Icons.add_location),
      ),
      body: ListView.builder(
        itemCount: provider.locations.length,
        itemBuilder: (_, i) {
          final loc = provider.locations[i];

          return ListTile(
            title: Text(loc.name),
            subtitle: Text(loc.address ?? ""),
            trailing: IconButton(
              onPressed: () => context.read<BucketLocationProvider>(),
              icon: const Icon(Icons.delete),
            ),
          );
        },
      ),
    );
  }
}
