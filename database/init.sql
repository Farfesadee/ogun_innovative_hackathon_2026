-- MathGenius Database Initialization Script
-- Run this in your Nobus PostgreSQL instance (or Supabase SQL Editor)
-- This creates all necessary tables for MathGenius

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- USER PROFILES (extends Supabase auth.users)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT,
    school TEXT,
    bio TEXT,
    exam_target TEXT DEFAULT 'WAEC',
    exam_date DATE,
    avatar_color TEXT DEFAULT 'teal',
    role TEXT DEFAULT 'student' CHECK (role IN ('student', 'teacher', 'parent')),
    parent_email TEXT,
    email_alerts_enabled BOOLEAN DEFAULT true,
    alert_threshold INTEGER DEFAULT 50,
    referral_code TEXT UNIQUE,
    referred_by UUID REFERENCES public.profiles(id),
    onboarded BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Users can view and update their own profile
CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- Admins can view all profiles (handled by admin endpoints with service key)

-- ============================================================
-- USER STATS (XP, Streaks, Level)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.user_stats (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    xp INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    streak_days INTEGER DEFAULT 0,
    streak_current INTEGER DEFAULT 0,
    streak_longest INTEGER DEFAULT 0,
    last_activity_date DATE,
    total_questions INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    accuracy NUMERIC(5,2) DEFAULT 0,
    last_updated TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.user_stats ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own stats" ON public.user_stats
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own stats" ON public.user_stats
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- TOPIC MASTERY (per-topic progress)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.user_topic_mastery (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    topic TEXT NOT NULL,
    level TEXT NOT NULL,
    correct INTEGER DEFAULT 0,
    attempted INTEGER DEFAULT 0,
    mastery INTEGER DEFAULT 0,
    last_practiced TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, topic, level)
);

ALTER TABLE public.user_topic_mastery ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own mastery" ON public.user_topic_mastery
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own mastery" ON public.user_topic_mastery
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own mastery" ON public.user_topic_mastery
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- QUESTION FLAGS (User-reported issues)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.question_flags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    user_email TEXT,
    username TEXT,
    question_text TEXT NOT NULL,
    topic TEXT,
    exam_type TEXT,
    source TEXT,
    level TEXT,
    reason TEXT,
    note TEXT,
    status TEXT DEFAULT 'open' CHECK (status IN ('open', 'reviewing', 'fixed', 'dismissed')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.question_flags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own flags" ON public.question_flags
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert flags" ON public.question_flags
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Admin access via service key (bypasses RLS)

-- ============================================================
-- ROOM SOLUTIONS (Community shared solutions)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.room_solutions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT,
    question_text TEXT NOT NULL,
    solution_text TEXT NOT NULL,
    topic TEXT DEFAULT '',
    exam_type TEXT DEFAULT '',
    source TEXT DEFAULT '',
    likes_count INTEGER DEFAULT 0,
    status TEXT DEFAULT 'open' CHECK (status IN ('open', 'hidden', 'flagged')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.room_solutions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view solutions" ON public.room_solutions
    FOR SELECT USING (status = 'open');

CREATE POLICY "Users can insert own solutions" ON public.room_solutions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own solutions" ON public.room_solutions
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own solutions" ON public.room_solutions
    FOR DELETE USING (auth.uid() = user_id);

-- Room Likes
CREATE TABLE IF NOT EXISTS public.room_likes (
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    solution_id UUID NOT NULL REFERENCES public.room_solutions(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, solution_id)
);

ALTER TABLE public.room_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view likes" ON public.room_likes
    FOR SELECT USING (true);

CREATE POLICY "Users can like" ON public.room_likes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike" ON public.room_likes
    FOR DELETE USING (auth.uid() = user_id);

-- ============================================================
-- BOOKMARKS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.bookmarks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('explanation', 'question', 'solution', 'note')),
    title TEXT,
    content TEXT,
    expression TEXT,
    result TEXT,
    topic TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own bookmarks" ON public.bookmarks
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own bookmarks" ON public.bookmarks
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own bookmarks" ON public.bookmarks
    FOR DELETE USING (auth.uid() = user_id);

-- ============================================================
-- NEWSLETTER SUBSCRIBERS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.newsletter_subscribers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.newsletter_subscribers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can subscribe" ON public.newsletter_subscribers
    FOR INSERT WITH CHECK (true);

-- ============================================================
-- ONBOARDING FLAG
-- ============================================================
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS onboarded BOOLEAN DEFAULT false;

-- ============================================================
-- TEACH FEEDBACK & SESSIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.teach_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    message_id TEXT,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    topic TEXT,
    level TEXT,
    question TEXT,
    response_preview TEXT,
    rating TEXT CHECK (rating IN ('up', 'down')),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.teach_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    topic TEXT,
    question TEXT,
    response_length INTEGER,
    level TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- SPACED REPETITION
-- ============================================================
CREATE TABLE IF NOT EXISTS public.spaced_repetition (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    topic TEXT NOT NULL,
    level TEXT NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    interval_days INTEGER DEFAULT 1,
    next_review TIMESTAMPTZ NOT NULL,
    ease_factor NUMERIC(3,2) DEFAULT 2.5,
    reviews_count INTEGER DEFAULT 0,
    last_reviewed TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, topic, level, question)
);

ALTER TABLE public.spaced_repetition ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own spaced repetition" ON public.spaced_repetition
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own spaced repetition" ON public.spaced_repetition
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own spaced repetition" ON public.spaced_repetition
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- QUESTION FLAGS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.question_flags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    user_email TEXT,
    username TEXT,
    question_text TEXT NOT NULL,
    topic TEXT,
    exam_type TEXT,
    source TEXT,
    level TEXT,
    reason TEXT,
    note TEXT,
    status TEXT DEFAULT 'open' CHECK (status IN ('open', 'reviewing', 'fixed', 'dismissed')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.question_flags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own flags" ON public.question_flags
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert flags" ON public.question_flags
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- ROOM SOLUTIONS & LIKES
-- ============================================================
CREATE TABLE IF NOT EXISTS public.room_solutions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT,
    question_text TEXT NOT NULL,
    solution_text TEXT NOT NULL,
    topic TEXT DEFAULT '',
    exam_type TEXT DEFAULT '',
    source TEXT DEFAULT '',
    likes_count INTEGER DEFAULT 0,
    status TEXT DEFAULT 'open' CHECK (status IN ('open', 'hidden', 'flagged')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.room_solutions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view open solutions" ON public.room_solutions
    FOR SELECT USING (status = 'open');

CREATE POLICY "Users can insert own solutions" ON public.room_solutions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own solutions" ON public.room_solutions
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own solutions" ON public.room_solutions
    FOR DELETE USING (auth.uid() = user_id);

CREATE TABLE IF NOT EXISTS public.room_likes (
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    solution_id UUID NOT NULL REFERENCES public.room_solutions(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, solution_id)
);

ALTER TABLE public.room_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view likes" ON public.room_likes
    FOR SELECT USING (true);

CREATE POLICY "Users can like" ON public.room_likes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike" ON public.room_likes
    FOR DELETE USING (auth.uid() = user_id);

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    message TEXT,
    icon TEXT,
    link TEXT,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- TEACH FEEDBACK & SESSIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.teach_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    message_id TEXT,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    topic TEXT,
    level TEXT,
    question TEXT,
    response_preview TEXT,
    rating TEXT CHECK (rating IN ('up', 'down')),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.teach_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    topic TEXT,
    question TEXT,
    response_length INTEGER,
    level TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- SPACED REPETITION
-- ============================================================
CREATE TABLE IF NOT EXISTS public.spaced_repetition (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    topic TEXT NOT NULL,
    level TEXT NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    interval_days INTEGER DEFAULT 1,
    next_review TIMESTAMPTZ NOT NULL,
    ease_factor NUMERIC(3,2) DEFAULT 2.5,
    reviews_count INTEGER DEFAULT 0,
    last_reviewed TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, topic, level, question)
);

ALTER TABLE public.spaced_repetition ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own spaced repetition" ON public.spaced_repetition
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own spaced repetition" ON public.spaced_repetition
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own spaced repetition" ON public.spaced_repetition
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- PUSH SUBSCRIPTIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.push_subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    endpoint TEXT NOT NULL,
    p256dh TEXT NOT NULL,
    auth_key TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, endpoint)
);

ALTER TABLE public.push_subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own push subscriptions" ON public.push_subscriptions
    FOR ALL USING (auth.uid() = user_id);

-- ============================================================
-- CLASSROOM / TEACHER-PARENT
-- ============================================================
CREATE TABLE IF NOT EXISTS public.classrooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    teacher_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    subject TEXT,
    class_code TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.classroom_students (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    classroom_id UUID NOT NULL REFERENCES public.classrooms(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(classroom_id, student_id)
);

-- ============================================================
-- CHALLENGES / BATTLES
-- ============================================================
CREATE TABLE IF NOT EXISTS public.battle_rooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    creator_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    opponent_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    topic TEXT,
    level TEXT,
    difficulty TEXT,
    status TEXT DEFAULT 'waiting' CHECK (status IN ('waiting', 'active', 'finished')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    finished_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS public.battle_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES public.battle_rooms(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    correct_answer TEXT NOT NULL,
    options JSONB,
    order_index INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS public.battle_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES public.battle_rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES public.battle_questions(id) ON DELETE CASCADE,
    answer TEXT,
    is_correct BOOLEAN,
    time_taken INTEGER,
    submitted_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_user_stats_user_id ON public.user_stats(user_id);
CREATE INDEX IF NOT EXISTS idx_user_topic_mastery_user_id ON public.user_topic_mastery(user_id);
CREATE INDEX IF NOT EXISTS idx_question_flags_user_id ON public.question_flags(user_id);
CREATE INDEX IF NOT EXISTS idx_question_flags_status ON public.question_flags(status);
CREATE INDEX IF NOT EXISTS idx_room_solutions_user_id ON public.room_solutions(user_id);
CREATE INDEX IF NOT EXISTS idx_room_solutions_status ON public.room_solutions(status);
CREATE INDEX IF NOT EXISTS idx_room_solutions_created_at ON public.room_solutions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_bookmarks_user_id ON public.bookmarks(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON public.notifications(read);
CREATE INDEX IF NOT EXISTS idx_teach_feedback_user_id ON public.teach_feedback(user_id);
CREATE INDEX IF NOT EXISTS idx_spaced_repetition_user_id ON public.spaced_repetition(user_id);
CREATE INDEX IF NOT EXISTS idx_spaced_repetition_next_review ON public.spaced_repetition(next_review);
CREATE INDEX IF NOT EXISTS idx_question_flags_status ON public.question_flags(status);
CREATE INDEX IF NOT EXISTS idx_room_solutions_created_at ON public.room_solutions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_battle_rooms_status ON public.battle_rooms(status);
CREATE INDEX IF NOT EXISTS idx_battle_questions_room_id ON public.battle_questions(room_id);