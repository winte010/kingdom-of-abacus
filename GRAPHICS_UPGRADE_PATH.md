# Kingdom of Abacus - Graphics Upgrade Path
**Zero Code Changes Required**  
**Last Updated:** November 15, 2025

---

## 🎯 PHILOSOPHY

**Key Principle:** Config-driven graphics mean you can upgrade from simple shapes to professional animations without changing a single line of code.

**How:** Character and asset configurations point to file paths. Swap the files, update the config type, done.

---

## 📊 UPGRADE PHASES

### Phase 1: Development Placeholders (Week 1 - Sprint 1)
**Goal:** Functional app, zero artistic requirements  
**Duration:** During development  
**Cost:** $0

### Phase 2: Static Illustrations (Week 2-3)
**Goal:** Professional look, still images  
**Duration:** 1-2 weeks  
**Cost:** $500-2000

### Phase 3: Lottie Animations (Week 4-6)
**Goal:** Smooth, lightweight animations  
**Duration:** 2-3 weeks  
**Cost:** $1000-3000

### Phase 4: Rive Interactive (Week 7+)
**Goal:** Premium, interactive character animations  
**Duration:** 3-4 weeks  
**Cost:** $2000-5000

---

## 🔄 PHASE 1: DEVELOPMENT PLACEHOLDERS

### What You Get
- Colored shapes (circles, squares, rectangles)
- Text labels identifying each character/asset
- Distinct colors for each character state
- Functional but not pretty

### Assets Needed

**Characters (15 placeholder images):**
```
assets/placeholders/characters/
├── pearl_keeper_idle.png          # Blue circle with "Pearl Keeper (Idle)"
├── pearl_keeper_happy.png         # Green circle with "Pearl Keeper (Happy)"
├── pearl_keeper_worried.png       # Orange circle with "Pearl Keeper (Worried)"
├── chaos_kraken_idle.png          # Purple/pink swirl with "Chaos Kraken"
├── chaos_kraken_attacking.png     # Red swirl with "Attacking!"
└── ...
```

**Backgrounds (6 placeholder images):**
```
assets/placeholders/backgrounds/
├── coastal_cove_beach.png         # Blue gradient with "Coastal Cove - Beach"
├── coastal_cove_tide_pools.png    # Blue-green gradient with "Tide Pools"
├── coastal_cove_cave.png          # Dark blue gradient with "Cave"
└── ...
```

### Configuration (Phase 1)

```json
// assets/config/characters/pearl_keeper.json
{
  "id": "pearl_keeper",
  "name": "Pearl Keeper",
  "type": "character",
  "states": {
    "idle": {
      "type": "static_image",
      "asset": "assets/placeholders/characters/pearl_keeper_idle.png"
    },
    "happy": {
      "type": "static_image",
      "asset": "assets/placeholders/characters/pearl_keeper_happy.png"
    },
    "worried": {
      "type": "static_image",
      "asset": "assets/placeholders/characters/pearl_keeper_worried.png"
    }
  }
}
```

### How to Create Placeholders

**Option 1: Use Provided Dart Script**
```dart
// tools/create_placeholders.dart
import 'dart:ui' as ui;
import 'dart:io';

void main() async {
  createCharacterPlaceholder(
    name: 'Pearl Keeper (Idle)',
    color: Colors.blue,
    outputPath: 'assets/placeholders/characters/pearl_keeper_idle.png',
  );
  
  createCharacterPlaceholder(
    name: 'Pearl Keeper (Happy)',
    color: Colors.green,
    outputPath: 'assets/placeholders/characters/pearl_keeper_happy.png',
  );
  
  // ... more characters
}

void createCharacterPlaceholder({
  required String name,
  required Color color,
  required String outputPath,
}) {
  // 1. Create canvas (400x400)
  // 2. Draw colored circle
  // 3. Add text label
  // 4. Save as PNG
}
```

**Option 2: Use Image Editor (Faster)**
- Open Figma/Canva/Photoshop
- Create 400x400 canvas
- Draw colored circle
- Add text label
- Export as PNG

**Option 3: Use Online Tool**
- https://placeholder.com
- Generate solid color rectangles with text

### Delivery Checklist
- [ ] All character states created (15 images)
- [ ] All backgrounds created (6 images)
- [ ] All placeholders properly labeled
- [ ] Config files point to placeholders
- [ ] App runs and shows placeholders

---

## 🎨 PHASE 2: STATIC ILLUSTRATIONS

### What You Get
- Hand-drawn or AI-generated character art
- Beautiful background scenes
- Multiple character expressions
- Professional color palettes
- Still images (no animation yet)

### Asset Specifications

**Character Illustrations:**
- **Size:** 1000x1000px (square)
- **Format:** PNG with transparency
- **Background:** Transparent
- **DPI:** 144 (for retina displays)
- **Color Space:** sRGB
- **File Size:** <500KB each

**Background Illustrations:**
- **Size:** 1920x1080px (landscape) or 1080x1920px (portrait)
- **Format:** PNG or JPEG
- **DPI:** 144
- **File Size:** <1MB each

### Characters to Commission

**Pearl Keeper (Sea Otter):**
- idle.png - Floating calmly, paws together
- happy.png - Big smile, spinning motion blur
- worried.png - Wide eyes, paws on cheeks
- encouraging.png - Pointing excitedly
- celebrating.png - Arms up, confetti around

**Chaos Kraken:**
- idle.png - Tentacles swirling lazily
- attacking.png - Tentacle reaching forward
- damaged.png - Some tentacles drooping
- defeated.png - All tentacles limp, sad eyes

### Backgrounds to Commission

**Coastal Cove:**
- beach.png - Sandy shore, ocean waves
- tide_pools.png - Rocky pools with water
- cave_entrance.png - Dark cave opening
- cave_interior.png - Glowing cave walls
- deep_tide_pool.png - Large pool in cave

### Art Direction Brief

```markdown
# Pearl Keeper Character Brief

**Species:** Sea Otter
**Age:** Young adult
**Personality:** Aloof but encouraging, silly, enthusiastic

**Physical Description:**
- Small crown made of woven seaweed and tiny pearls
- Shimmering fur (even in chaos fog)
- Large, expressive eyes
- Often holds paws together

**Color Palette:**
- Primary: Rich brown fur (#8B6B47)
- Secondary: Pearl white accents (#FFF8DC)
- Tertiary: Seafoam green crown (#9FE2BF)

**Expression Guide:**
- Idle: Neutral, slightly curious
- Happy: Big genuine smile, sparkle in eyes
- Worried: Wide eyes, tense posture
- Encouraging: Warm smile, forward lean

**Style:**
- Whimsical but not overly cartoonish
- Appealing to ages 5-12
- Readable silhouette
- Works at small and large sizes
```

### Finding Artists

**Option 1: Commission from Artist**
- Fiverr: $50-200 per character
- Upwork: $100-500 per character
- ArtStation: $200-1000 per character
- Local art student: $50-100 per character

**Option 2: AI Generation**
- Midjourney: $30/month subscription
- DALL-E 3: $15-40 total
- Stable Diffusion: Free (self-hosted)

**Prompt for AI:**
```
A cute sea otter character wearing a tiny crown made of seaweed and 
pearls, floating in water, paws held together, large expressive eyes, 
shimmering brown fur, children's book illustration style, whimsical, 
appealing to kids ages 5-12, simple background, PNG transparent
```

### Configuration (Phase 2)

```json
// assets/config/characters/pearl_keeper.json
{
  "id": "pearl_keeper",
  "name": "Pearl Keeper",
  "type": "character",
  "states": {
    "idle": {
      "type": "static_image",  // ← Still static_image
      "asset": "assets/characters/pearl_keeper_idle.png"  // ← New path!
    },
    "happy": {
      "type": "static_image",
      "asset": "assets/characters/pearl_keeper_happy.png"
    },
    "worried": {
      "type": "static_image",
      "asset": "assets/characters/pearl_keeper_worried.png"
    }
  }
}
```

**NO CODE CHANGES NEEDED!** Just swap files and update config paths.

### Delivery Checklist
- [ ] All character states illustrated (20+ images)
- [ ] All backgrounds illustrated (10+ images)
- [ ] Files meet size/format specs
- [ ] Config files updated with new paths
- [ ] Images optimized for performance
- [ ] App looks professional

---

## 🎬 PHASE 3: LOTTIE ANIMATIONS

### What You Get
- Smooth, lightweight animations
- Small file sizes (<100KB each)
- Vector-based (scales perfectly)
- Interactive states
- Frame-by-frame control

### What is Lottie?
- JSON-based animation format
- Created by Airbnb
- Exports from After Effects
- Renders natively in Flutter
- Used by Uber, Netflix, Google

### Asset Specifications

**Lottie Animations:**
- **Format:** JSON
- **File Size:** <100KB per animation
- **Duration:** 1-3 seconds typical
- **Frame Rate:** 30-60 fps
- **Dimensions:** 1000x1000px

### Animations to Create

**Pearl Keeper:**
- idle.json - Gentle bobbing/floating
- happy.json - Excited spin
- worried.json - Nervous fidget
- encouraging.json - Pointing gesture
- celebrating.json - Victory dance

**Effects:**
- correct_answer.json - Green sparkles
- wrong_answer.json - Gentle shake
- page_turn.json - Book page flip
- unlock.json - Fog clearing away
- victory.json - Confetti burst

### Creating Lottie Animations

**Option 1: Adobe After Effects + Bodymovin**
1. Create animation in After Effects
2. Install Bodymovin plugin
3. Export as JSON
4. Test in LottieFiles preview

**Option 2: LottieFiles Creator (Web-Based)**
1. Visit create.lottiefiles.com
2. Use built-in animation tools
3. Or edit pre-made templates
4. Export JSON directly

**Option 3: Use Pre-Made Animations**
1. Browse LottieFiles.com library
2. Find similar animations
3. Customize colors/timing
4. Download JSON

**Free Lottie Resources:**
- https://lottiefiles.com (thousands of free animations)
- https://www.lottielab.com (web editor)
- https://rive.app (alternative format, more powerful)

### Configuration (Phase 3)

```json
// assets/config/characters/pearl_keeper.json
{
  "id": "pearl_keeper",
  "name": "Pearl Keeper",
  "type": "character",
  "states": {
    "idle": {
      "type": "lottie",  // ← Changed from static_image!
      "asset": "assets/animations/pearl_keeper_idle.json",
      "loop": true,
      "speed": 1.0
    },
    "happy": {
      "type": "lottie",
      "asset": "assets/animations/pearl_keeper_happy.json",
      "loop": false,  // Play once
      "speed": 1.2  // 20% faster
    },
    "worried": {
      "type": "lottie",
      "asset": "assets/animations/pearl_keeper_worried.json",
      "loop": true,
      "speed": 0.8  // 20% slower
    }
  }
}
```

### Widget Handles It (Already Built!)

```dart
// lib/widgets/characters/character_display.dart
Widget build(BuildContext context) {
  final config = characterConfig.states[currentState];
  
  switch (config.type) {
    case 'static_image':
      return Image.asset(config.asset);
      
    case 'lottie':  // ← This case handles Lottie!
      return Lottie.asset(
        config.asset,
        repeat: config.loop,
        animate: true,
      );
      
    case 'rive':
      return RiveAnimation.asset(config.asset);
  }
}
```

### Delivery Checklist
- [ ] All character animations created (15 JSON files)
- [ ] All effect animations created (10 JSON files)
- [ ] Files optimized (<100KB each)
- [ ] Config files updated with type: "lottie"
- [ ] Animations tested in app
- [ ] Frame rate is smooth (60fps)

---

## 🎮 PHASE 4: RIVE INTERACTIVE

### What You Get
- Skeletal character animation
- Interactive state machines
- Blend between states smoothly
- Eyes follow cursor/finger
- Responsive to user actions
- Premium, game-quality feel

### What is Rive?
- Modern animation tool (successor to Flare)
- Free web-based editor
- Create once, runs everywhere
- State machines for interactivity
- Powerful timeline editor

### Asset Specifications

**Rive Animations:**
- **Format:** .riv
- **File Size:** <200KB per character
- **Artboards:** 1 per character
- **State Machines:** 1-3 per character
- **Bones:** 10-20 per character

### Characters to Rig

**Pearl Keeper (Full Rig):**
- Skeleton with bones for:
  - Body
  - Head
  - Both arms (3 bones each)
  - Tail
  - Crown
- State Machine with states:
  - Idle (breathing, slight movement)
  - Happy (bounce, spin)
  - Worried (shake, shrink)
  - Talking (mouth moves)
  - Celebrating (arms up, confetti)

**Transitions:**
- Idle → Happy (smooth 0.3s blend)
- Idle → Worried (sharp 0.1s blend)
- Any → Talking (immediate)

### Creating Rive Animations

**Step 1: Design Character**
- Export character from Phase 2 as layers
- Separate body parts (head, arms, tail, etc.)

**Step 2: Import to Rive**
1. Visit rive.app (free web editor)
2. Create new project
3. Import image layers
4. Create bones for each part

**Step 3: Create Animations**
1. Create "Idle" animation (2s loop)
   - Gentle breathing
   - Slight float/bob
   - Eyes blink occasionally

2. Create "Happy" animation (1.5s)
   - Bounce up
   - Spin 360°
   - Land back to idle

3. Create "Worried" animation (2s loop)
   - Shake slightly
   - Eyes dart around
   - Shrink inward

**Step 4: State Machine**
```
Idle (default)
 ↓ trigger: "happy"
Happy (plays once)
 → returns to Idle

Idle
 ↓ trigger: "worried"  
Worried (loops)
 ↓ trigger: "calm"
Idle
```

**Step 5: Export**
- Export as .riv file
- Keep file size <200KB

### Configuration (Phase 4)

```json
// assets/config/characters/pearl_keeper.json
{
  "id": "pearl_keeper",
  "name": "Pearl Keeper",
  "type": "character",
  "states": {
    "idle": {
      "type": "rive",  // ← Changed to Rive!
      "asset": "assets/animations/pearl_keeper.riv",
      "artboard": "Pearl Keeper",
      "state_machine": "State Machine 1",
      "input": "idle"
    },
    "happy": {
      "type": "rive",
      "asset": "assets/animations/pearl_keeper.riv",  // Same file
      "artboard": "Pearl Keeper",
      "state_machine": "State Machine 1",
      "input": "happy"  // ← Trigger different state
    },
    "worried": {
      "type": "rive",
      "asset": "assets/animations/pearl_keeper.riv",
      "artboard": "Pearl Keeper",
      "state_machine": "State Machine 1",
      "input": "worried"
    }
  }
}
```

### Widget Handles It (Already Built!)

```dart
// lib/widgets/characters/character_display.dart
Widget build(BuildContext context) {
  final config = characterConfig.states[currentState];
  
  switch (config.type) {
    case 'static_image':
      return Image.asset(config.asset);
      
    case 'lottie':
      return Lottie.asset(
        config.asset,
        repeat: config.loop,
      );
      
    case 'rive':  // ← This case handles Rive!
      return RiveAnimation.asset(
        config.asset,
        artboard: config.artboard,
        stateMachines: [config.stateMachine],
        onInit: (artboard) {
          final controller = StateMachineController.fromArtboard(
            artboard,
            config.stateMachine,
          );
          if (controller != null) {
            artboard.addController(controller);
            final input = controller.findInput<bool>(config.input);
            input?.value = true;
          }
        },
      );
  }
}
```

### Rive Learning Resources
- **Official Tutorial:** rive.app/community/learn-rive
- **State Machines:** rive.app/community/doc/state-machine
- **Flutter Integration:** rive.app/community/doc/flutter
- **Examples:** github.com/rive-app/rive-flutter/tree/main/example

### Delivery Checklist
- [ ] Character rigs created in Rive
- [ ] All animations smooth (60fps)
- [ ] State machines working
- [ ] Transitions blend smoothly
- [ ] File sizes optimized
- [ ] Config files updated
- [ ] Interactive features working
- [ ] Premium feel achieved

---

## 📋 COMPLETE UPGRADE CHECKLIST

### Phase 1 → Phase 2 Transition
- [ ] Commission or generate all static artwork
- [ ] Optimize images (compress, resize)
- [ ] Update config files (change paths only)
- [ ] Replace placeholder files
- [ ] Test app with new artwork
- [ ] No code changes needed!

### Phase 2 → Phase 3 Transition
- [ ] Create Lottie animations
- [ ] Test animations in LottieFiles preview
- [ ] Optimize JSON file sizes
- [ ] Update config files (change type to "lottie")
- [ ] Add animation files to assets
- [ ] Test app with animations
- [ ] Verify 60fps performance
- [ ] No code changes needed!

### Phase 3 → Phase 4 Transition
- [ ] Separate character layers
- [ ] Create Rive rigs
- [ ] Animate in Rive editor
- [ ] Set up state machines
- [ ] Test in Rive runtime
- [ ] Export .riv files
- [ ] Update config files (change type to "rive")
- [ ] Add Rive files to assets
- [ ] Test app with interactive characters
- [ ] No code changes needed!

---

## 💰 BUDGET ESTIMATES

### Phase 1: Placeholders
**Cost:** $0  
**Time:** 2 hours  
**Tools:** Free (Dart script or Figma)

### Phase 2: Static Art
**Option A - Commission Artist:**
- **Cost:** $1,000 - $2,000
- **Time:** 1-2 weeks
- **Quality:** High, custom

**Option B - AI Generation:**
- **Cost:** $50 - $100
- **Time:** 1-2 days
- **Quality:** Medium-high, requires iteration

**Option C - Asset Store:**
- **Cost:** $100 - $500
- **Time:** Immediate
- **Quality:** Good, may need adaptation

### Phase 3: Lottie
**Option A - Hire Animator:**
- **Cost:** $1,500 - $3,000
- **Time:** 2-3 weeks
- **Quality:** High, custom

**Option B - Adapt Templates:**
- **Cost:** $200 - $500
- **Time:** 1 week
- **Quality:** Good

### Phase 4: Rive
**Option A - Hire Rive Specialist:**
- **Cost:** $3,000 - $5,000
- **Time:** 3-4 weeks
- **Quality:** Premium

**Option B - DIY (Learn Rive):**
- **Cost:** $0 (time investment)
- **Time:** 4-6 weeks
- **Quality:** Variable

---

## 🎯 RECOMMENDED TIMELINE

### Sprint 1 (Days 1-3): Phase 1 Only
- Use placeholders
- Focus on functionality
- Zero artistic requirements

### Week 2: Commission Phase 2
- While building Chapters 2-3
- Static art arrives
- Quick upgrade (1 hour)

### Week 3-4: Commission Phase 3
- While building Chapters 4-6
- Lottie animations arrive
- Upgrade (2 hours)

### Week 5-8: Commission Phase 4 (Optional)
- While finishing all 18 chapters
- Rive interactive arrives
- Final upgrade (4 hours)
- Beta test with real kids

---

## ✅ QUALITY CHECKPOINTS

After each phase upgrade:

- [ ] All assets load correctly
- [ ] No broken image links
- [ ] App performance unchanged
- [ ] File sizes acceptable
- [ ] Visual quality improved
- [ ] Kid-tested and approved

---

**The beauty of this system:**  
START ugly, ship fast, upgrade incrementally—all without touching code!
