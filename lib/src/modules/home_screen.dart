import 'package:flutter/material.dart';
import 'package:share_records/src/shared/widget/appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context, 
        'Share Record',
        IconButton(
          onPressed: () => Navigator.restorablePushNamed(context, '/settingsView'),
          icon: const Icon(Icons.settings)
        )
      ),
      body: bodyView(context),
    );
  }

  Widget bodyView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        children: [
          Wrap(
            spacing: 20.0, // Spacing between items
            runSpacing: 20.0, // Spacing between lines
            children: [
              // gridTileView(context, Icons.check, 'Ipo Result', '/ipoResult'), 
              gridTileView(context, Icons.equalizer, 'Portfolio', '/portfolio'), 
              gridTileView(context, Icons.check, 'My Shares', '/myShares'), 
              gridTileView(context, Icons.history, 'History', '/history') 
            ],
          ),
          const SizedBox(height: 16.0),
        ]
      ),
    );
  }

  gridTileView(BuildContext context, IconData icon, String title, String routeName) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        height: 200.0,
        child: Column(
          children: [
            Icon(
              icon,
              size: 150.0,
            ),
            const SizedBox(height: 8.0),
            Text(title),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

}