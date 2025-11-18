# Pearl Keeper Character Animations

This directory contains Rive animation files (.riv) for the Pearl Keeper character.

## Expected File Structure

```
assets/characters/pearl_keeper/
├── README.md (this file)
└── pearl_keeper.riv (main character animation file)
```

## Rive File Requirements

### File Name
- **Primary animation file**: `pearl_keeper.riv`
- Alternative files can be specified via the `characterAnimation` field in segment JSON

### State Machine Configuration

The Rive file should contain a **State Machine** named `"State Machine 1"` (default) with support for emotion states.

#### Option 1: Using Triggers (Recommended)

Create boolean triggers for each emotion:
- `happy` - Trigger for happy emotion
- `excited` - Trigger for excited emotion
- `worried` - Trigger for worried emotion
- `proud` - Trigger for proud emotion
- `surprised` - Trigger for surprised emotion

#### Option 2: Using Number Input

Create a number input named `emotion` that accepts values:
- `0.0` - Happy
- `1.0` - Excited
- `2.0` - Worried
- `3.0` - Proud
- `4.0` - Surprised

### Recommended Animation States

Each emotion should have an associated animation state:
1. **Idle animations** for each emotion (looping)
2. **Transition animations** between emotion states (smooth blending)
3. Optional: **One-shot animations** for special events (celebrations, reactions, etc.)

### Performance Guidelines

- **Target frame rate**: 60fps
- **Recommended artboard size**: 1000x1000 pixels
- **Keep file size under**: 2MB for optimal loading
- **Use vector graphics**: Prefer shapes over raster images
- **Optimize mesh complexity**: Keep bone count reasonable for mobile devices

## Testing Without a Rive File

The app includes a **graceful fallback system**:
- If the .riv file is missing or fails to load, a placeholder character will be shown
- The placeholder displays an icon representing the current emotion
- No crashes will occur - the app continues to function normally

## Using in Segment JSON

To use the Pearl Keeper character in a story segment, add these fields to your segment configuration:

```json
{
  "id": "segment_1",
  "type": "story",
  "storyFile": "story_text.md",
  "problemCount": 0,
  "characterAnimation": "assets/characters/pearl_keeper/pearl_keeper.riv",
  "characterEmotion": "happy"
}
```

### Available Emotions

- `"happy"` - Default, cheerful state
- `"excited"` - Energetic, enthusiastic
- `"worried"` - Concerned, anxious
- `"proud"` - Accomplished, confident
- `"surprised"` - Shocked, amazed

## Creating Your Rive File

### Tools Needed
- [Rive Editor](https://rive.app/) (web or desktop app)
- Basic understanding of animation principles

### Quick Start Guide

1. **Create a new Rive file** in the Rive Editor
2. **Design the Pearl Keeper character** using vector tools
3. **Add a State Machine** named "State Machine 1"
4. **Create emotion states**:
   - Add an animation for each emotion (happy, excited, worried, proud, surprised)
   - Create boolean triggers or a number input for state switching
   - Set up transitions between states with appropriate blend modes
5. **Test the animations** in the Rive preview
6. **Export as .riv file** and place in this directory
7. **Test in the app** to ensure smooth playback

### Example State Machine Structure

```
State Machine 1
├── Inputs
│   ├── happy (Boolean Trigger)
│   ├── excited (Boolean Trigger)
│   ├── worried (Boolean Trigger)
│   ├── proud (Boolean Trigger)
│   └── surprised (Boolean Trigger)
└── States
    ├── Happy (Animation: happy_idle)
    ├── Excited (Animation: excited_bounce)
    ├── Worried (Animation: worried_fidget)
    ├── Proud (Animation: proud_stance)
    └── Surprised (Animation: surprised_reaction)
```

## Debugging

To enable debug output showing available animations and inputs:

```dart
PearlKeeperCharacter(
  emotion: CharacterEmotion.happy,
  showDebugInfo: true, // Enable debug mode
)
```

This will print to console:
- Available animations in the file
- Available state machines
- Available inputs in the state machine
- Error messages if loading fails

## Resources

- [Rive Documentation](https://help.rive.app/)
- [Rive Flutter Package](https://pub.dev/packages/rive)
- [State Machine Tutorial](https://help.rive.app/editor/state-machine)
- [Animation Best Practices](https://help.rive.app/editor/animating)

## Support

For issues or questions about character animations, check:
1. Console logs for detailed error messages
2. Verify file path in segment JSON matches actual file location
3. Ensure .riv file is properly exported from Rive Editor
4. Test with `showDebugInfo: true` to see available inputs/states
