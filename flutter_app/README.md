# TaskPilot — Scrollable Views (ListView & GridView)

This sprint lesson implements a dedicated screen that demonstrates scrollable UI patterns using:

- `ListView.builder` for an efficient horizontal list of cards
- `GridView.builder` for a responsive grid of tiles

Implementation file:

- `lib/screens/scrollable_views.dart`

## How to Open

- Run the app: `flutter run`
- From the current home screen, tap the AppBar action (list icon) to open **Scrollable Views**.

## ListView (Builder) — Code Snippet

```dart
SizedBox(
	height: 140,
	child: ListView.builder(
		scrollDirection: Axis.horizontal,
		itemCount: cards.length,
		itemBuilder: (context, index) {
			final card = cards[index];
			return SizedBox(
				width: 220,
				child: RetroCard(
					child: Row(
						children: [
							CircleAvatar(child: Icon(card.icon)),
							const SizedBox(width: 16),
							Expanded(
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(card.title),
										Text(card.subtitle),
									],
								),
							),
						],
					),
				),
			);
		},
	),
)
```

## GridView (Builder) — Code Snippet

```dart
GridView.builder(
	physics: const NeverScrollableScrollPhysics(),
	shrinkWrap: true,
	gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
		crossAxisCount: 2,
		crossAxisSpacing: 16,
		mainAxisSpacing: 16,
		childAspectRatio: 1.2,
	),
	itemCount: tiles.length,
	itemBuilder: (context, index) {
		final tile = tiles[index];
		return RetroCard(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Icon(tile.icon, size: 34),
					const SizedBox(height: 12),
					Text(tile.label),
				],
			),
		);
	},
)
```

## Screenshots

Add screenshots after running the app (save images under `assets/images/`).

- `assets/images/scrollable_listview.png`
- `assets/images/scrollable_gridview.png`

Then update the links below:

![ListView (horizontal)](assets/images/scrollable_listview.png)
![GridView (responsive)](assets/images/scrollable_gridview.png)

## Reflection

### How does ListView differ from GridView in design use cases?

- `ListView` is best for linear content (messages, tasks, notifications) where each item typically spans the width/row.
- `GridView` is best for visual/structured collections (dashboards, galleries, catalogs) where multiple items appear per row.

### Why is ListView.builder() more efficient for large lists?

- Builder constructors create items lazily (only what’s visible + a small cache), which reduces memory usage and improves scroll performance.

### What can you do to prevent lag or overflow errors in scrollable views?

- Avoid nesting multiple scrollables unless you constrain one (e.g., `NeverScrollableScrollPhysics` + `shrinkWrap` when embedding).
- Prefer `ListView.builder` / `GridView.builder` over eager `children: []` for large datasets.
- Keep `itemBuilder` light; cache expensive work (images, formatting) and avoid heavy synchronous computation.
- Use responsive sizing (`LayoutBuilder`, adaptive crossAxisCount) to prevent tight layouts and text overflow.
