# DRY-RUN PREVIEW: Dart Flutter App 작업 지침

> **Preview example — 실제 `AGENTS.md`가 아닙니다.** `flutter-app` profile과 Codex adapter의 수동 조합 검증용 문서이며 그대로 복사·적용·export하지 않습니다.

## Project Overview (프로젝트 개요)

이 preview는 Dart, Flutter와 RESTful API client를 사용하는 가상의 mobile app을 전제로 한다. 실제 화면, 지원 platform, app lifecycle 요구, directory 구조와 release 정책은 입력되지 않았다.

## Tech Stack (기술 스택)

- Language: Dart
- Framework/Platform: Flutter
- Database/API/Architecture: RESTful API client, backend 미지정
- Variant: 없음
- State management/Build flavor/HTTP client: `<실제 프로젝트에서 확인 필요>`
- Required bridges: Dart–Flutter, Flutter–REST API
- Adapter target: Codex project instructions preview

## Included Fragments (포함 Fragment)

- Base: `core/global/agents.fragment.md`, `core/project/agents.fragment.md`
- Quality: `core/quality/agents.fragment.md`
- Language: `stacks/language/dart/agents.fragment.md`
- Mobile/API: `stacks/mobile/flutter/agents.fragment.md`, `stacks/api/restful-api/agents.fragment.md`
- Bridge: `stacks/bridge/dart-flutter/agents.fragment.md`, `stacks/bridge/flutter-rest-api/agents.fragment.md`

Fragment 전문은 포함하지 않는다. 아래에는 상시 필요한 조합 판단만 요약한다.

## Included Skills (포함 Skill)

### 기본 작업 Gate

- `incremental-implementation`: 화면과 lifecycle 변경을 검증 가능한 단계로 나눈다.
- `test-first`: 상태 전이, widget 결과와 실패 경로를 먼저 정한다.
- `security-review`: Remote 입력, token, local storage와 platform 권한을 검토한다.
- `test-scope-selection`: Model, widget, integration과 platform 검증 범위를 선택한다.

### 필요 시 참조

- Common: `debugging`, `code-review`, `refactoring`
- Mobile: `flutter-screen-implementation`, `flutter-state-management`, `flutter-api-integration`, `flutter-build-debug`

Skill 본문은 inline하지 않는다. 작업 trigger와 일치하는 `SKILL.md`만 참조한다.

## Working Rules (작업 규칙)

### Dart와 Flutter

- Null, loading, empty, failure와 success 상태를 하나의 nullable 값으로 합치지 않는다.
- Future 결과와 Stream subscription을 widget lifecycle, 요청 세대와 dispose 책임에 맞춘다.
- Widget은 화면 조합과 상호작용을 소유하고 serialization과 model 변환을 직접 처리하지 않는다.
- Controller, subscription과 observer의 생성·해제 책임을 같은 소유자에 둔다.
- Domain/API model과 mutable UI state를 분리하고 강제 unwrap과 `late` 사용에는 lifecycle 근거를 둔다.

### REST API와 Mobile 경계

- API client가 remote 호출, DTO mapping과 오류 정규화를 담당하고 widget이 endpoint와 wire format을 직접 처리하지 않게 한다.
- Network 단절, timeout, 중복, 순서 변경과 app lifecycle 중단을 정상적인 실패 경계로 취급한다.
- Retry는 HTTP method의 멱등성, 최대 횟수와 backoff를 고려한다.
- Auth token의 획득·저장·전송·갱신·폐기 책임을 집중시키고 widget에 노출하지 않는다.
- App/API version 공존, offline freshness와 재동기화 결과를 명시한다.

### Project 선택 경계

- State management library, build flavor와 HTTP client는 실제 project 설정을 확인한 뒤 따른다.
- 특정 backend framework를 암묵적으로 선택하지 않는다.
- Platform별 권한과 build 차이는 지원 target이 확인된 뒤 검토한다.

## Validation Commands (검증 명령)

- Build: `<실제 Flutter target/flavor build 명령 확인 필요>`
- Test: `<실제 Dart/Flutter unit·widget·integration test 명령 확인 필요>`
- Analyze/Format: `<실제 analyzer·format 명령 확인 필요>`
- Additional: `<API contract, offline/auth 및 지원 platform 검증 명령 확인 필요>`

명령과 도구를 확인하지 않은 상태에서는 검증 성공으로 보고하지 않는다.

## Done Definition (완료 기준)

- Widget 책임, state 소유권과 lifecycle 종료 처리가 명확하다.
- DTO/model/UI 경계와 network·offline·auth 실패 결과가 검증 가능하다.
- 적용 가능한 build, test, analyze와 추가 검증이 통과하거나 미실행 사유가 기록된다.
- State library, flavor, HTTP client와 backend를 근거 없이 확정하지 않는다.
- 남은 위험과 실제 project에서 확인할 항목을 보고한다.

## Scope Boundary (범위 경계)

- Allowed: `<실제 프로젝트가 허용한 mobile app 변경 범위>`
- Excluded: 특정 backend framework와 확인되지 않은 state/build/network 제품 규칙
- Pending: 지원 platform, release policy와 실제 project architecture 확인
- Automation: Repository가 git-auto Stop hook을 사용하면 직접 commit·push하지 않고 `.gitauto/`를 staging하지 않는다. 기존 `.codex/hooks`는 명시 요청 없이 수정하지 않는다.
- Preview limitation: 이 문서는 dry-run example이며 실제 project metadata와 validation command가 확정되지 않았다.
