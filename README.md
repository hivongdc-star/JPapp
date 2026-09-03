# Nihongo Quest

Game-mode Japanese learning UI prototype focused on serious JLPT progression and four-skill mastery.

## Current scope

- 5 top-level scenes: Main, Roadmap, Ability, World, Settings.
- Roadmap rendered as a journey path with chapter/test/boss nodes and the player character on the current node.
- Ability dashboard for Listening, Speaking, Reading, Writing.
- World scene with league, ranking, challenge, chat-room modules.
- Focus-mode learning session sample.
- Mock data only. No backend/database/API integration yet.

## Run

```bash
flutter pub get
flutter run
```

## Architecture note

This repository intentionally keeps UI state and mock data local. Curriculum, progress, social, and account APIs should be connected later without changing the scene hierarchy.
