# GitHub Actions for Flutter - Automated CI/CD
**Solving the Compilation Problem for Claude Code Web Agents**  
**Last Updated:** November 15, 2025

---

## 🎯 THE PROBLEM

**Claude Code web agents cannot:**
- Run `flutter build` to test compilation
- Execute `flutter test` to verify tests pass
- Check if the app actually runs
- Detect build errors until YOU compile locally

**This means:**
- Agent writes code → No way to verify it compiles
- You discover errors later → Wastes time
- Agents can't self-correct → Manual fixes needed

---

## ✅ THE SOLUTION: GITHUB ACTIONS

**GitHub Actions is:**
- Free CI/CD automation (built into GitHub)
- Runs workflows on GitHub's servers
- Triggers automatically on every push/PR
- Gives agents immediate feedback

**How it helps:**
1. Agent pushes code → GitHub Actions runs automatically
2. Actions compiles Flutter project
3. Actions runs all tests
4. Results appear in GitHub (pass/fail)
5. Agent sees results → Fixes if needed
6. You only test locally at checkpoints

---

## 🔧 HOW IT WORKS

### Workflow Triggers

```yaml
# Runs on every push to any branch
on: [push]

# Or runs on pull requests
on: [pull_request]

# Or runs on both
on: [push, pull_request]

# Or runs on schedule (every hour)
on:
  schedule:
    - cron: '0 * * * *'
```

### What Actions Can Do

✅ **Compile Flutter apps** (iOS, Android, Web)  
✅ **Run all tests** (unit, widget, integration)  
✅ **Check code quality** (linting, formatting)  
✅ **Measure test coverage** (and fail if <80%)  
✅ **Build artifacts** (APK, IPA files)  
✅ **Deploy to stores** (future feature)

### Cost

**Free tier includes:**
- 2,000 minutes/month for private repos
- Unlimited for public repos
- macOS runners: 10 mins = 100 billable mins
- Linux runners: 1:1 ratio

**For your project:**
- ~5 minute workflow
- Run after each commit (~10-20 per day)
- = 50-100 minutes/day
- = ~2,000 minutes/month
- **Fits in free tier!**

---

## 📝 SETUP GUIDE

### Step 1: Create Workflow File

In your repo, create:
```
.github/
└── workflows/
    └── flutter-ci.yml
```

### Step 2: Basic Flutter Workflow

```yaml
# .github/workflows/flutter-ci.yml
name: Flutter CI

on:
  push:
    branches: [ main, dev ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest  # Linux is fastest and cheapest
    
    steps:
      # Step 1: Checkout code
      - name: Checkout repository
        uses: actions/checkout@v4
      
      # Step 2: Install Flutter
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'  # Latest stable
          channel: 'stable'
      
      # Step 3: Get dependencies
      - name: Install dependencies
        run: flutter pub get
      
      # Step 4: Verify code quality
      - name: Analyze code
        run: flutter analyze
      
      # Step 5: Run tests
      - name: Run tests
        run: flutter test --coverage
      
      # Step 6: Check test coverage
      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep 'lines' | awk '{print $2}' | sed 's/%//')
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage is $COVERAGE%, below 80% threshold"
            exit 1
          fi
          echo "Coverage is $COVERAGE%, meets 80% threshold"
      
      # Step 7: Build Android APK
      - name: Build Android
        run: flutter build apk --debug
      
      # Step 8: Build iOS (if on macOS runner)
      # - name: Build iOS
      #   run: flutter build ios --no-codesign
```

### Step 3: Commit and Push

```bash
git add .github/workflows/flutter-ci.yml
git commit -m "Add GitHub Actions CI workflow"
git push origin main
```

### Step 4: Check Results

1. Go to GitHub repository
2. Click "Actions" tab
3. See workflow running!
4. Click on run to see details
5. Green checkmark = pass, red X = fail

---

## 🎨 ENHANCED WORKFLOW (RECOMMENDED)

```yaml
# .github/workflows/flutter-ci.yml
name: Flutter CI/CD

on:
  push:
    branches: [ main, dev, feature/* ]
  pull_request:
    branches: [ main, dev ]

env:
  FLUTTER_VERSION: '3.16.0'

jobs:
  # Job 1: Lint and analyze
  analyze:
    name: Code Analysis
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
          cache: true  # Cache Flutter SDK for faster runs
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Verify formatting
        run: dart format --set-exit-if-changed .
      
      - name: Analyze code
        run: flutter analyze --fatal-infos --fatal-warnings
  
  # Job 2: Run tests
  test:
    name: Unit & Widget Tests
    runs-on: ubuntu-latest
    needs: analyze  # Only run if analyze passes
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
          cache: true
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests with coverage
        run: flutter test --coverage --reporter expanded
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
          fail_ci_if_error: false
      
      - name: Check coverage threshold
        run: |
          # Install lcov
          sudo apt-get update
          sudo apt-get install -y lcov
          
          # Calculate coverage
          COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep 'lines' | awk '{print $2}' | sed 's/%//')
          echo "Code coverage: $COVERAGE%"
          
          # Fail if below 80%
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "❌ Coverage $COVERAGE% is below 80% threshold"
            exit 1
          fi
          
          echo "✅ Coverage $COVERAGE% meets 80% threshold"
  
  # Job 3: Build Android
  build-android:
    name: Build Android APK
    runs-on: ubuntu-latest
    needs: test  # Only build if tests pass
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
          cache: true
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build debug APK
        run: flutter build apk --debug
      
      - name: Upload APK artifact
        uses: actions/upload-artifact@v3
        with:
          name: app-debug.apk
          path: build/app/outputs/flutter-apk/app-debug.apk
  
  # Job 4: Build iOS (only on macOS)
  build-ios:
    name: Build iOS
    runs-on: macos-latest  # macOS for iOS builds
    needs: test
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
          cache: true
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build iOS (no signing)
        run: flutter build ios --no-codesign --debug
  
  # Job 5: Integration tests (if you have them)
  integration-test:
    name: Integration Tests
    runs-on: macos-latest
    needs: test
    if: false  # Disabled for now, enable when you have integration tests
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run integration tests
        uses: reactivecircus/android-emulator-runner@v2
        with:
          api-level: 29
          script: flutter test integration_test
```

---

## 🚀 AGENT WORKFLOW WITH GITHUB ACTIONS

### Without GitHub Actions (Current):
```
1. Agent writes code
2. Agent commits & pushes
3. ❌ No way to verify
4. You test locally hours later
5. Find compilation error
6. Tell agent to fix
7. Agent fixes
8. Repeat...
```

### With GitHub Actions (Better):
```
1. Agent writes code
2. Agent commits & pushes
3. ✅ GitHub Actions runs automatically
4. Actions compiles code
5. Actions runs tests
6. Results appear in GitHub
7. Agent sees: ❌ Build failed
8. Agent reads error message
9. Agent fixes immediately
10. Agent pushes fix
11. Actions runs again
12. ✅ Build passed!
13. You review at checkpoint (code already works)
```

---

## 📊 WHAT AGENTS SEE

### Pass Example:
```
✅ Code Analysis - passed
✅ Unit & Widget Tests - passed (coverage: 87%)
✅ Build Android APK - passed
✅ Build iOS - passed

All checks passed!
```

### Fail Example:
```
✅ Code Analysis - passed
❌ Unit & Widget Tests - failed
   Error: Expected <true> but got <false>
   File: test/services/problem_generator_test.dart:45
   
Build Android APK - skipped (previous job failed)
Build iOS - skipped (previous job failed)
```

**Agent can click on failed job to see full error log!**

---

## 🔐 HANDLING SECRETS

Your `.env` file has Supabase credentials. Don't commit these!

### Solution: GitHub Secrets

1. **Go to repo settings → Secrets and variables → Actions**
2. **Add secrets:**
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_KEY`

3. **Use in workflow:**
```yaml
- name: Create .env file
  run: |
    echo "SUPABASE_URL=${{ secrets.SUPABASE_URL }}" >> .env
    echo "SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}" >> .env
    echo "SUPABASE_SERVICE_KEY=${{ secrets.SUPABASE_SERVICE_KEY }}" >> .env

- name: Run tests
  run: flutter test
```

---

## 📈 MONITORING & NOTIFICATIONS

### Status Badges

Add to your README.md:
```markdown
![Flutter CI](https://github.com/YOUR_USERNAME/kingdom-of-abacus/workflows/Flutter%20CI/badge.svg)
```

Shows build status: ![Passing](https://img.shields.io/badge/build-passing-brightgreen)

### Email Notifications

GitHub sends emails automatically when:
- Workflow fails
- Workflow is fixed after failing
- Your commit breaks the build

### Slack/Discord Integration

Can send notifications to Slack/Discord:
```yaml
- name: Notify Slack
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## 🎯 RECOMMENDED SETUP FOR YOUR PROJECT

### Minimal (Start Here):
```yaml
# Runs on every push
# Checks: Format, Analyze, Test, Coverage
# Takes: ~3 minutes
# Cost: 3 minutes per run
```

### Standard (Recommended):
```yaml
# Runs on PR and main branch
# Checks: Format, Analyze, Test, Coverage, Build Android
# Takes: ~5 minutes
# Cost: 5 minutes per run
```

### Full (Optional):
```yaml
# Runs on PR and main branch
# Checks: Format, Analyze, Test, Coverage, Build Android, Build iOS, Integration Tests
# Takes: ~15 minutes
# Cost: 150 minutes per run (macOS multiplier)
```

**Start with Minimal, upgrade to Standard once stable.**

---

## 📋 SETUP CHECKLIST

### Initial Setup (30 minutes):
- [ ] Create `.github/workflows/` directory
- [ ] Create `flutter-ci.yml` file
- [ ] Copy minimal workflow (above)
- [ ] Add Supabase secrets to GitHub
- [ ] Commit and push
- [ ] Watch first workflow run
- [ ] Fix any issues
- [ ] Celebrate green checkmarks!

### Maintenance:
- [ ] Review failed workflows daily
- [ ] Update Flutter version as needed
- [ ] Add new test types to workflow
- [ ] Monitor free tier usage

---

## 🐛 TROUBLESHOOTING

### "Workflow not running"
- Check `.github/workflows/` path is correct
- Check YAML syntax (use yamllint.com)
- Check triggers match your branch name

### "Flutter not found"
- Ensure `flutter-action` step runs first
- Check Flutter version is valid

### "Tests fail in Actions but pass locally"
- Check environment differences
- Add debug output: `flutter doctor -v`
- Ensure .env secrets configured

### "Build takes too long"
- Enable caching: `cache: true`
- Use `ubuntu-latest` (not macOS) when possible
- Run only on main branch, not all branches

---

## 💡 PRO TIPS

### 1. Matrix Testing
Test multiple Flutter versions:
```yaml
strategy:
  matrix:
    flutter-version: ['3.16.0', '3.13.0']
runs-on: ${{ matrix.flutter-version }}
```

### 2. Skip CI
Add `[skip ci]` to commit message to skip workflow:
```bash
git commit -m "Update README [skip ci]"
```

### 3. Required Checks
In repo settings, make workflows required before merge:
- Settings → Branches → Branch protection
- Require status checks to pass

### 4. Parallel Jobs
Jobs run in parallel by default (faster!):
```yaml
jobs:
  analyze:  # Runs immediately
  test:     # Runs immediately
  build:    # Runs after test passes
    needs: test
```

---

## ✅ BENEFITS SUMMARY

### For You:
- ✅ Less manual testing
- ✅ Catch errors earlier
- ✅ Confidence code works
- ✅ Automated quality gates

### For Agents:
- ✅ Immediate feedback
- ✅ Self-correction possible
- ✅ Learn from errors
- ✅ Work more independently

### For Project:
- ✅ Higher code quality
- ✅ Fewer bugs
- ✅ Faster development
- ✅ Professional workflow

---

## 🎬 NEXT STEPS

1. **Set up minimal workflow** (30 minutes)
2. **Test with a simple commit** (5 minutes)
3. **Review results** (5 minutes)
4. **Add to sprint plan** (integrate with checkpoints)
5. **Train agents** (show them where to see results)

**Ready to set up GitHub Actions?**

Let me know and I can provide:
- Step-by-step setup guide
- Complete workflow file
- Troubleshooting help
- Integration with agent prompts
