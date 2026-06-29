# Flutter App Codex Dry-run

> 이 디렉터리는 수동 dry-run을 위한 preview example입니다. 실제 Codex 설정이나 export 결과가 아니며 root `AGENTS.md`, 전역 `~/.codex/AGENTS.md`와 `.codex/hooks.json`을 생성하거나 변경하지 않습니다.

## 목적

Generator 구현 없이 `flutter-app` profile의 Dart, Flutter, RESTful API client 구성이 Codex preview로 조합 가능한지 검증한다. Dart–Flutter와 Flutter–REST API bridge, mobile skill routing과 미확정 제품 선택을 확인한다.

## Dry-run 대상

- Profile: `profiles/flutter-app/profile.yml`
- Adapter: `adapters/codex/adapter.md`
- Template: `templates/codex/AGENTS.md.template`
- Preview 상태: `ready`

## 검토 포인트

- Dart null safety·Future·Stream과 Flutter widget lifecycle 연결
- Mobile network, DTO, offline, auth와 API version 경계
- Flutter/REST fragment와 두 bridge의 책임 중복 여부
- 실제 state management library, build flavor와 HTTP client를 추정하지 않는 정책

## 산출물과 범위

`AGENTS.preview.md`, `merge-trace.md`, `skill-selection.md`, `validation-report.md`는 모두 설계 검증 example이다. Generator, validator, CLI, file writer, skill 설치와 실제 export는 수행하지 않았다.
