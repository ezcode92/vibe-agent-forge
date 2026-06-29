# Fragment Merge Trace

> `flutter-app` + Codex 수동 dry-run의 source 추적 문서다. 실제 merge engine 실행 결과가 아니다.

## 선택된 Fragment

| Profile 구분 | Catalog ID | Path | Priority |
| --- | --- | --- | --- |
| Base | `core-global` | `core/global/agents.fragment.md` | 10 |
| Base/project | `core-project` | `core/project/agents.fragment.md` | 70 |
| Quality | `core-quality` | `core/quality/agents.fragment.md` | 10 |
| Language | `language-dart` | `stacks/language/dart/agents.fragment.md` | 20 |
| API | `api-restful-api` | `stacks/api/restful-api/agents.fragment.md` | 30 |
| Mobile | `mobile-flutter` | `stacks/mobile/flutter/agents.fragment.md` | 40 |
| Bridge | `bridge-dart-flutter` | `stacks/bridge/dart-flutter/agents.fragment.md` | 50 |
| Bridge | `bridge-flutter-rest-api` | `stacks/bridge/flutter-rest-api/agents.fragment.md` | 50 |

Profile 참조 8개와 catalog path가 모두 일치했다.

## Preview 구성 및 Authority

표시 순서는 Core → Dart → Flutter/REST API → Dart–Flutter/Flutter–REST API bridge → project placeholder다. Conflict authority는 priority 10, 20, 30, 40, 50, 70과 사용자 현재 요청 순으로 검토한다.

## Dependency와 Compatibility

- `core-project`, `core-quality` → `core-global`: 충족
- Dart와 RESTful API → `core-quality`: 충족
- Flutter → Dart + core quality: 충족
- Dart + Flutter → `requires-bridge`; `bridge-dart-flutter` 선택됨
- Flutter + RESTful API → `requires-bridge`; `bridge-flutter-rest-api` 선택됨

두 required bridge가 모두 profile에 포함되어 있다.

## Mobile/API Fragment 관계

`mobile-flutter`는 widget, state, navigation, API client와 platform 책임을 정의하고 `api-restful-api`는 HTTP resource와 외부 contract를 정의한다. `flutter-rest-api` bridge만 mobile network, DTO, offline, auth와 release/version 차이를 두 책임 사이에 연결한다. `dart-flutter` bridge는 Dart null/async/model을 widget lifecycle에 연결하므로 REST contract를 반복하지 않는다.

## 중복과 충돌

- Dart Future/Stream과 Flutter async UI는 언어 원칙과 lifecycle 연결로 구분했다.
- Flutter API client, REST contract와 Flutter–REST bridge는 client 책임, protocol 계약, mobile 상호작용으로 분리했다.
- Core 보안과 bridge token 규칙은 일반 secret 원칙과 mobile auth lifecycle로 구체화했다.
- 특정 backend, state library, flavor와 HTTP client를 선택하지 않아 profile exclude와 충돌하지 않는다.

## 결과

두 required bridge와 dependency가 해소되고 blocking conflict가 없다. Preview 결과는 `ready`이며 실제 export 대상이 아니다.
