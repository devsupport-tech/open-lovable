# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Open Lovable is a Next.js 15 application that allows users to build React applications instantly through AI-powered conversations. It uses E2B sandboxes to create isolated development environments where AI-generated code runs in real-time.

## Development Commands

```bash
# Start development server with Turbopack
npm run dev

# Build production bundle
npm run build

# Run linter
npm run lint

# Run specific test suites (note: test files not yet implemented)
npm run test:integration  # E2B integration tests
npm run test:api         # API endpoint tests  
npm run test:code        # Code execution tests
npm run test:all         # Run all tests
```

## Architecture Overview

### Core Flow
1. User sends a prompt via the chat interface
2. System analyzes intent and current sandbox state
3. AI generates code with context awareness
4. Code is applied to E2B sandbox in real-time
5. Vite dev server hot-reloads changes
6. Preview updates automatically

### Key Components

- **E2B Sandbox Management**: Creates isolated Node.js environments with Vite dev servers. Sandboxes timeout after 15 minutes (configurable in `config/app.config.ts`)
- **AI Provider Integration**: Supports OpenAI GPT-5, Anthropic Sonnet, and Groq (Kimi K2). Models are configured in `config/app.config.ts`
- **Streaming Architecture**: Uses AI SDK's streaming capabilities for real-time code generation and application
- **Context Selection**: Smart file selection based on edit intent analysis (`lib/context-selector.ts`)
- **Package Detection**: Automatic npm package installation from AI responses using XML tags

### Global State Management

The application maintains several global state objects:
- `global.activeSandbox`: Current E2B sandbox instance
- `global.sandboxState`: File cache and sandbox metadata
- `global.conversationState`: Conversation history and context
- `global.existingFiles`: Track files created in sandbox

### API Routes Structure

All API endpoints are in `app/api/`:
- `create-ai-sandbox`: Initializes new E2B sandbox with Vite + React + Tailwind
- `generate-ai-code-stream`: Streams AI-generated code with context
- `apply-ai-code-stream`: Applies code changes to sandbox files
- `detect-and-install-packages`: Auto-installs missing npm packages
- `monitor-vite-logs`: Tracks Vite server logs for errors
- `scrape-url-enhanced`: Fetches and processes web content for context

## Environment Variables

Required in `.env.local`:
```env
# Required
E2B_API_KEY=           # E2B sandbox provider
FIRECRAWL_API_KEY=     # Web scraping service

# At least one AI provider required
ANTHROPIC_API_KEY=     # Anthropic Claude
OPENAI_API_KEY=        # OpenAI GPT
GROQ_API_KEY=          # Groq inference
```

## Configuration

Main configuration in `config/app.config.ts`:
- E2B sandbox timeouts and Vite settings
- AI model selection and parameters
- File management exclusions
- Package installation settings

## Code Style & Patterns

- TypeScript with strict mode enabled
- React 19 with hooks and functional components
- Tailwind CSS for styling
- Framer Motion for animations
- Radix UI for accessible components
- ESLint configured with relaxed rules for `any` types

## Important Context Files

When making changes, always consider:
- `types/sandbox.ts`: Global type definitions
- `types/conversation.ts`: Conversation state types
- `types/file-manifest.ts`: File structure types
- `lib/context-selector.ts`: File selection logic
- `lib/edit-intent-analyzer.ts`: Intent detection
- `config/app.config.ts`: All configuration values