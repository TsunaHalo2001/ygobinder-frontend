# Update `receive_sharing_intent` API usage

The `receive_sharing_intent` package has been updated from version 1.6.3 to 1.9.0 (as specified by `^1.6.3` in `pubspec.yaml` and resolved in `pubspec.lock`). The new version uses a singleton `instance` for its methods, and static methods like `getMediaStream()` and `getInitialMedia()` have been removed.

## User Review Required

> [!IMPORTANT]
> This change updates the API calls to match version 1.9.0 of the `receive_sharing_intent` package. If you are using an older version of the package in a different environment, this code might not be compatible there.

## Proposed Changes

### Decks Feature

#### [MODIFY] [deck_file_provider.dart](file:///TsunaDomain/Proyectos/ygobinder-revamped/ygobinder-frontend/lib/features/decks/presentation/providers/deck_file_provider.dart)

- Update `ReceiveSharingIntent.getMediaStream()` to `ReceiveSharingIntent.instance.getMediaStream()`.
- Update `ReceiveSharingIntent.getInitialMedia()` to `ReceiveSharingIntent.instance.getInitialMedia()`.
- Update `ReceiveSharingIntent.reset()` to `ReceiveSharingIntent.instance.reset()`.

## Verification Plan

### Automated Tests
- I will attempt to run `flutter pub get` and then check if the file compiles (or if the IDE stops reporting errors). Since I cannot easily run a full build, I will rely on the fact that the error reported was specifically about these missing members.

### Manual Verification
- The user should verify that sharing files to the app still works as expected on both Android and iOS.
