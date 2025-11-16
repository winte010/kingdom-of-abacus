-- Kingdom of Abacus - Initial Database Schema
-- This migration creates all tables needed for the application

-- Note: Using gen_random_uuid() which is built-in to PostgreSQL
-- No extension needed

-- ============================================================================
-- USERS TABLE
-- ============================================================================
-- Stores user profiles and metadata
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    age INTEGER CHECK (age >= 0 AND age <= 150),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_played TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster lookups
CREATE INDEX idx_users_last_played ON users(last_played DESC);

-- ============================================================================
-- PROGRESS TABLE
-- ============================================================================
-- Tracks user progress through chapters and segments
CREATE TABLE progress (
    progress_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    chapter_id TEXT NOT NULL,
    current_segment INTEGER DEFAULT 0,
    problems_completed INTEGER DEFAULT 0,
    problems_correct INTEGER DEFAULT 0,
    completed BOOLEAN DEFAULT FALSE,
    last_played TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, chapter_id)
);

-- Indexes for faster queries
CREATE INDEX idx_progress_user_id ON progress(user_id);
CREATE INDEX idx_progress_chapter_id ON progress(chapter_id);
CREATE INDEX idx_progress_last_played ON progress(last_played DESC);

-- ============================================================================
-- PERFORMANCE TABLE
-- ============================================================================
-- Stores performance metrics by topic for adaptive difficulty
CREATE TABLE performance (
    performance_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    chapter_number INTEGER NOT NULL,
    topic TEXT NOT NULL,
    problems_attempted INTEGER DEFAULT 0,
    problems_correct INTEGER DEFAULT 0,
    accuracy_percentage DECIMAL(5,2) CHECK (accuracy_percentage >= 0 AND accuracy_percentage <= 100),
    average_time INTEGER, -- in milliseconds
    difficulty_level TEXT CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for analytics queries
CREATE INDEX idx_performance_user_id ON performance(user_id);
CREATE INDEX idx_performance_topic ON performance(topic);
CREATE INDEX idx_performance_timestamp ON performance(timestamp DESC);

-- ============================================================================
-- PROBLEM_HISTORY TABLE
-- ============================================================================
-- Detailed history of individual problem attempts
CREATE TABLE problem_history (
    history_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    problem_type TEXT NOT NULL,
    problem_text TEXT NOT NULL,
    user_answer INTEGER,
    correct_answer INTEGER NOT NULL,
    time_taken INTEGER, -- in milliseconds
    correct BOOLEAN NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for history queries
CREATE INDEX idx_problem_history_user_id ON problem_history(user_id);
CREATE INDEX idx_problem_history_timestamp ON problem_history(timestamp DESC);
CREATE INDEX idx_problem_history_correct ON problem_history(correct);

-- ============================================================================
-- SIDE_QUEST_TRIGGERS TABLE
-- ============================================================================
-- Tracks topics that need additional practice (side quests)
CREATE TABLE side_quest_triggers (
    trigger_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    topic TEXT NOT NULL,
    trigger_count INTEGER DEFAULT 0,
    completed BOOLEAN DEFAULT FALSE,
    completion_accuracy DECIMAL(5,2) CHECK (completion_accuracy >= 0 AND completion_accuracy <= 100),
    UNIQUE(user_id, topic)
);

-- Indexes for side quest queries
CREATE INDEX idx_side_quest_triggers_user_id ON side_quest_triggers(user_id);
CREATE INDEX idx_side_quest_triggers_completed ON side_quest_triggers(completed);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE performance ENABLE ROW LEVEL SECURITY;
ALTER TABLE problem_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE side_quest_triggers ENABLE ROW LEVEL SECURITY;

-- Users table policies
-- Users can read and update their own profile
CREATE POLICY "Users can view own profile"
    ON users FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile"
    ON users FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile"
    ON users FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Progress table policies
CREATE POLICY "Users can view own progress"
    ON progress FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress"
    ON progress FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress"
    ON progress FOR UPDATE
    USING (auth.uid() = user_id);

-- Performance table policies
CREATE POLICY "Users can view own performance"
    ON performance FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own performance"
    ON performance FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own performance"
    ON performance FOR UPDATE
    USING (auth.uid() = user_id);

-- Problem history table policies
CREATE POLICY "Users can view own problem history"
    ON problem_history FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own problem history"
    ON problem_history FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Side quest triggers table policies
CREATE POLICY "Users can view own side quest triggers"
    ON side_quest_triggers FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own side quest triggers"
    ON side_quest_triggers FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own side quest triggers"
    ON side_quest_triggers FOR UPDATE
    USING (auth.uid() = user_id);

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Function to update last_played timestamp automatically
CREATE OR REPLACE FUNCTION update_last_played()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users SET last_played = NOW() WHERE user_id = NEW.user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers to auto-update last_played
CREATE TRIGGER update_user_last_played_on_progress
    AFTER INSERT OR UPDATE ON progress
    FOR EACH ROW
    EXECUTE FUNCTION update_last_played();

CREATE TRIGGER update_user_last_played_on_problem_history
    AFTER INSERT ON problem_history
    FOR EACH ROW
    EXECUTE FUNCTION update_last_played();
