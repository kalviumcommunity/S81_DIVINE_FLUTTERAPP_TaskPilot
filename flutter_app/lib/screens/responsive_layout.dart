import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Layout'),
        actions: [
          IconButton(
            tooltip: 'Open Scrollable Views',
            icon: const Icon(Icons.view_list),
            onPressed: () => Navigator.pushNamed(context, '/scrollable-views'),
          ),
          PopupMenuButton<String>(
            tooltip: 'Open Demos',
            onSelected: (routeName) => Navigator.pushNamed(context, routeName),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: '/user-input-form',
                child: Text('User Input Form'),
              ),
              PopupMenuItem(
                value: '/assets-demo',
                child: Text('Assets Demo'),
              ),
              PopupMenuItem(
                value: '/firebase-setup',
                child: Text('Firebase Setup Status'),
              ),
              PopupMenuItem(
                value: '/animations-transitions-demo',
                child: Text('Animations & Transitions'),
              ),
              PopupMenuItem(
                value: '/state-management-demo',
                child: Text('State Management Demo'),
              ),
              PopupMenuItem(
                value: '/responsive-design-demo',
                child: Text('Responsive Design Demo'),
              ),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideLayout();
          } else {
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideLayout() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            color: Colors.lightBlueAccent,
            child: Center(child: Text('Header Section')),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.amber,
                    child: Center(child: Text('Left Panel')),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    color: Colors.greenAccent,
                    child: Center(child: Text('Right Panel')),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.grey,
            child: Center(child: Text('Footer Section')),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            color: Colors.lightBlueAccent,
            child: Center(child: Text('Header Section')),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              color: Colors.amber,
              child: Center(child: Text('Main Content')),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.grey,
            child: Center(child: Text('Footer Section')),
          ),
        ],
      ),
    );
  }
}
