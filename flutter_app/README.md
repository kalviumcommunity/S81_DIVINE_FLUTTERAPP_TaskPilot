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

### How do ListView and GridView improve UI efficiency?

- They provide built-in scrolling + layout behavior with efficient viewport rendering.
- They’re designed to handle large collections without manually laying out every item at once.

### Why are builder constructors recommended for large data sets?

- `ListView.builder` / `GridView.builder` build only what’s visible (and a small cache extent), which reduces memory usage and speeds up first render.
- They scale better because item creation is lazy and incremental.

### Common performance pitfalls to avoid

- Nesting multiple scrollables without constraints (causes layout exceptions or jank).
- Using `ListView(children: [...])` with very large lists (builds everything eagerly).
- Overusing `shrinkWrap: true` on large lists/grids (forces extra layout work) unless required.
- Putting expensive work in `itemBuilder` (heavy images, synchronous computations) without caching/optimization.
