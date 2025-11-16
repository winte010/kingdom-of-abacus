# Kingdom of Abacus 🏰

A story-driven educational math game for ages 5-12, where children discover their secret talent for mathematics through an engaging adventure across 18 chapters and 6 magical lands.

## 🎯 Project Overview

**Kingdom of Abacus** combines storytelling with adaptive math practice, featuring:
- 18 progressive chapters across 6 themed lands
- Adaptive difficulty based on performance
- Offline-first design with cloud sync
- Side quests for topics needing extra practice
- Story unlocks as rewards for completing problems

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.16.0 or later
- Dart 3.0+
- iOS 12+ / Android 6+ development environment
- Supabase account
- GitHub account (for CI/CD)

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd kingdom-of-abacus
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serialization code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure environment variables**
   ```bash
   # Copy the example environment file
   cp .env.example .env

   # Edit .env with your Supabase credentials
   # Get these from: https://app.supabase.com/project/_/settings/api
   ```

5. **Set up Supabase database**

   See the [Supabase Setup](#supabase-setup) section below.

6. **Run the app**
   ```bash
   # iOS
   flutter run -d ios

   # Android
   flutter run -d android
   ```

## 🗄️ Supabase Setup

### Option 1: Using Supabase CLI (Recommended)

1. **Install Supabase CLI**
   ```bash
   brew install supabase/tap/supabase
   ```

2. **Login to Supabase**
   ```bash
   supabase login
   ```

3. **Link to your project**
   ```bash
   supabase link --project-ref your-project-ref
   ```

4. **Run migrations**
   ```bash
   supabase db push
   ```

### Option 2: Manual Setup via Supabase Dashboard

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Copy and paste the contents of `supabase/migrations/001_initial_schema.sql`
4. Execute the SQL

### Enable Anonymous Authentication

1. In Supabase dashboard, go to **Authentication** → **Providers**
2. Enable **Anonymous sign-ins**
3. Save changes

### Get Your API Credentials

1. Navigate to **Project Settings** → **API**
2. Copy the following values:
   - **Project URL** → Add to `.env` as `SUPABASE_URL`
   - **anon public key** → Add to `.env` as `SUPABASE_ANON_KEY`
   - **service_role key** → Add to `.env` as `SUPABASE_SERVICE_KEY` (keep secret!)

## 🔧 GitHub Actions CI/CD

The project includes automated CI/CD workflows that run on every push to `main`, `dev`, or `develop` branches.

### Workflow Features

- ✅ Code analysis (`flutter analyze`)
- ✅ Code formatting verification
- ✅ Automated testing with coverage (80% minimum threshold)
- ✅ Android APK build
- ✅ iOS build (macOS runner)
- ✅ Build artifacts uploaded for download

### Setting Up GitHub Secrets

The CI/CD workflow requires the following secrets to be added to your GitHub repository:

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add the following repository secrets:

   ```
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   SUPABASE_SERVICE_KEY=your-service-role-key
   ```

### Using GitHub CLI to Add Secrets

```bash
# Set repository secrets using gh CLI
gh secret set SUPABASE_URL -b "https://your-project-id.supabase.co"
gh secret set SUPABASE_ANON_KEY -b "your-anon-key"
gh secret set SUPABASE_SERVICE_KEY -b "your-service-role-key"
```

## 📁 Project Structure

```
kingdom-of-abacus/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── config/                      # Configuration and constants
│   │   ├── constants.dart
│   │   └── chapters/               # Chapter JSON configs
│   ├── models/                      # Data models
│   │   ├── chapter.dart
│   │   ├── problem.dart
│   │   └── progress.dart
│   ├── services/                    # Business logic layer
│   │   ├── config_service.dart
│   │   ├── problem_generator.dart
│   │   ├── progress_service.dart
│   │   ├── sync_service.dart
│   │   ├── auth_service.dart
│   │   └── adaptive_difficulty.dart
│   ├── providers/                   # Riverpod providers
│   ├── widgets/                     # Reusable UI components
│   │   ├── book/
│   │   ├── problems/
│   │   ├── input/
│   │   ├── gameplay/
│   │   ├── characters/
│   │   ├── effects/
│   │   └── common/
│   ├── screens/                     # App screens
│   │   ├── home_screen.dart
│   │   ├── chapter/
│   │   ├── gameplay/
│   │   └── settings_screen.dart
│   └── utils/                       # Utility functions
├── assets/
│   ├── config/chapters/            # Chapter configuration JSONs
│   ├── placeholders/               # Placeholder graphics
│   ├── chapters/                   # Chapter assets (images, audio)
│   └── audio/                      # Sound effects and music
├── test/                           # Unit and widget tests
├── supabase/
│   └── migrations/                 # Database migrations
├── .github/
│   └── workflows/
│       └── flutter-ci.yml          # CI/CD workflow
├── .env.example                    # Environment variables template
├── .gitignore
├── pubspec.yaml
└── README.md
```

## 🧪 Testing

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
flutter test --coverage
```

### View coverage report
```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

### Quality Standards

- Minimum test coverage: **80%**
- All services must have unit tests
- All widgets must have widget tests
- Critical user flows must have integration tests

## 🏗️ Architecture

### State Management: Riverpod

The app uses **flutter_riverpod** for state management:
- No `setState` in business logic
- Provider-based architecture
- `ConsumerWidget` pattern for reactive UI
- Dependency injection through providers

### Offline-First Architecture

1. All gameplay works without internet
2. Progress saves locally first (SharedPreferences)
3. Cloud sync when connection available
4. Queue-based sync with retry logic

### Config-Driven Design

- Chapter content defined in JSON files
- No hardcoded story text or problem definitions
- Easy to add new chapters without code changes
- Graphics upgrade path built-in

## 📊 Database Schema

The app uses Supabase (PostgreSQL) with the following tables:

- **users** - User profiles and metadata
- **progress** - Chapter and segment progress tracking
- **performance** - Performance metrics by topic
- **problem_history** - Individual problem attempt history
- **side_quest_triggers** - Topics needing additional practice

All tables have Row Level Security (RLS) enabled to ensure users can only access their own data.

## 🎨 Graphics Strategy

The project follows a **progressive graphics upgrade path**:

1. **Phase 1: Placeholders** (Sprint 1) - Simple colored shapes
2. **Phase 2: Static Illustrations** (Week 2-3) - Commissioned or AI art
3. **Phase 3: Lottie Animations** (Week 4-6) - JSON-based animations
4. **Phase 4: Rive Interactive** (Week 7+) - Interactive state machines

All upgrades are config-driven - no code changes required, just update asset paths in chapter JSON files.

## 📖 Development Roadmap

### Sprint 1 (Days 1-3) - MVP
- ✅ Complete Chapter 1: Coastal Cove
- ✅ Foundational architecture
- ✅ Offline-first with cloud sync
- ✅ Placeholder graphics
- ✅ 80%+ test coverage

### Phase 2 (Week 2-3)
- Chapters 2-6
- Static graphics upgrade
- Performance optimization
- User feedback implementation

### Phase 3 (Week 4-6)
- Chapters 7-12
- Lottie animations
- Side quest system refinement
- Analytics dashboard

### Phase 4 (Week 7+)
- Chapters 13-18
- Rive interactive graphics
- Parental controls
- Multi-device sync

## 🤝 Contributing

See detailed requirements in:
- `REQUIREMENTS.md` - Functional and technical requirements
- `QA_STANDARDS.md` - Quality assurance standards
- `GITHUB_ACTIONS_GUIDE.md` - CI/CD workflow details
- `GRAPHICS_UPGRADE_PATH.md` - Graphics strategy

## 📝 License

[Add your license here]

## 🔗 Links

- [Supabase Dashboard](https://app.supabase.com)
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)

---

**Built for Claude Code Web** - This project is optimized for AI-assisted development with automated CI/CD workflows that provide compilation feedback without local Flutter builds.
