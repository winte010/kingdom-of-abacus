# Interactive Math Objects

This document describes the interactive math objects feature for Kingdom of Abacus.

## Overview

Interactive math objects provide tactile, visual alternatives to the traditional number pad for answering math problems. They are designed to make math learning more engaging and intuitive for young learners (ages 5-12).

## Features

### Math Object Types

1. **Shells (`shells`)** - Shell grouping for addition and counting
   - Visual: Colorful shells that can be grouped
   - Best for: Addition, counting, grouping activities
   - Interaction: Tap to select/deselect, drag to group

2. **Treasures (`treasures`)** - Treasure collection
   - Visual: Gems and treasures that can be collected into a chest
   - Best for: Addition, collection-based problems
   - Interaction: Drag items into chest

3. **Rocks (`rocks`)** - Rock stacking for counting
   - Visual: Stackable rocks that build vertically
   - Best for: Counting, sequential addition
   - Interaction: Tap or drag to add to stack

4. **Number Pad (`numberpad`)** - Traditional number input
   - Visual: Standard 0-9 number pad
   - Best for: All problem types, older children
   - Interaction: Tap to input numbers

### Interaction Styles

- **`tap`** - Touch/click objects to interact
- **`drag`** - Drag and drop objects
- **`both`** - Supports both tap and drag interactions

## Configuration

Add to segment JSON:

```json
{
  "id": "practice_segment_1",
  "type": "practice",
  "problemCount": 5,
  "problemConfig": {
    "type": "addition",
    "min": 1,
    "max": 10,
    "difficulty": "easy"
  },
  "mathObjectType": "shells",
  "interactionStyle": "tap"
}
```

### Fields

- `mathObjectType` (optional): `"shells"` | `"treasures"` | `"rocks"` | `"numberpad"`
  - Default: `"numberpad"` if not specified

- `interactionStyle` (optional): `"tap"` | `"drag"` | `"both"`
  - Default: `"tap"` if not specified

## Usage in Screens

The `PracticeUnlockScreen` automatically handles interactive math objects based on segment configuration:

```dart
import 'package:kingdom_of_abacus/screens/chapter/practice_unlock_screen.dart';

// In your navigation:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PracticeUnlockScreen(segment: segment),
  ),
);
```

The screen will automatically:
- Display the appropriate math object widget based on `mathObjectType`
- Configure interaction based on `interactionStyle`
- Fall back to number pad if assets are missing
- Track answers and provide feedback

## Widget Components

### InteractiveMathObject

Base widget providing common functionality:
- Scale/bounce animations on interaction
- Haptic feedback
- Visual glow effects
- Particle effects
- Sound effect hooks (for future audio implementation)

### ShellCounter

Groups shells for counting:
- Displays grid of shells
- Tap to select/deselect
- Shows current count
- Supports up to 20 shells

### TreasureChest

Collect treasures into a chest:
- Drag treasures into chest
- Visual feedback on hover
- Animated chest opening
- Progress indicator

### RockStack

Stack rocks vertically:
- Tap or drag to add rocks to stack
- Visual stacking animation
- Tap top rock to remove
- Shows stack height

## Assets

Place PNG images in `assets/images/math_objects/`:

- `shell.png` - Shell sprite (200x200px recommended)
- `treasure.png` - Treasure sprite (200x200px recommended)
- `rock.png` - Rock sprite (200x200px recommended)
- `chest.png` - Chest sprite (200x200px recommended)

**Fallback**: If assets are missing, Material Icons are used as fallbacks.

## Performance Considerations

- Tested with 10+ objects on screen simultaneously
- Animations use `SingleTickerProviderStateMixin` for efficiency
- Images should be optimized PNGs (< 50KB each)
- Widget rebuilds are minimized using keys and selective setState

## Accessibility

- All interactive objects support tap interaction (even in drag mode)
- Haptic feedback provides tactile response
- Clear visual feedback for all interactions
- Semantic labels for screen readers

## Future Enhancements

- [ ] Sound effects integration (hooks already in place)
- [ ] Additional math object types (coins, flowers, stars)
- [ ] Customizable object colors/themes
- [ ] Accessibility improvements (voice feedback)
- [ ] Advanced animations (confetti on correct answer)
- [ ] Multiplayer support (shared object interaction)

## Example Configurations

### Beginner Addition (Ages 5-7)
```json
{
  "mathObjectType": "shells",
  "interactionStyle": "tap"
}
```

### Visual Collection (Ages 6-8)
```json
{
  "mathObjectType": "treasures",
  "interactionStyle": "drag"
}
```

### Sequential Counting (Ages 7-9)
```json
{
  "mathObjectType": "rocks",
  "interactionStyle": "both"
}
```

### Advanced Practice (Ages 9-12)
```json
{
  "mathObjectType": "numberpad",
  "interactionStyle": "tap"
}
```

## Testing

To test interactive math objects:

1. Create a segment with desired configuration
2. Navigate to `PracticeUnlockScreen` with that segment
3. Verify interactions work smoothly
4. Check animations and feedback
5. Confirm correct answer detection

## Troubleshooting

### Objects don't appear
- Check `pubspec.yaml` includes `assets/images/math_objects/`
- Verify assets exist in correct directory
- Run `flutter pub get`
- Fallback icons should appear if assets are missing

### Interactions not working
- Check `enabled` prop is true
- Verify `interactionStyle` is set correctly
- Ensure no overlapping gesture detectors

### Performance issues
- Reduce number of simultaneous objects
- Optimize asset file sizes
- Check for unnecessary widget rebuilds

## Related Files

- `lib/widgets/math/interactive_math_object.dart` - Base widget
- `lib/widgets/math/shell_counter.dart` - Shell implementation
- `lib/widgets/math/treasure_chest.dart` - Treasure implementation
- `lib/widgets/math/rock_stack.dart` - Rock implementation
- `lib/screens/chapter/practice_unlock_screen.dart` - Practice screen
- `lib/models/segment.dart` - Segment configuration model
