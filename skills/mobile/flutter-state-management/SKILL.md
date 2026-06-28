---
name: flutter-state-management
description: Flutter의 widget-local·shared app state와 Future·Stream 상태를 lifecycle, rebuild와 dispose 관점에서 검토한다. State 소유권 변경 또는 상태관리 구조 도입·확장 시 사용한다.
---

# Flutter State Management

## 목적

Flutter state를 실제 소유자와 lifecycle에 배치하고 비동기 source, UI 상태와 resource 정리를 일관되게 관리한다. 특정 상태관리 library의 등록·저장소와 code generation API는 다루지 않는다.

## 사용 조건

- Widget-local state와 app-level state 경계를 결정할 때 적용한다.
- Future·Stream, controller 또는 subscription이 UI state에 연결될 때 적용한다.
- Library 선택 전에 state source, reader, writer와 lifetime을 확인한다.

## 입력 Context

- State별 source, reader, writer와 공유 범위
- Widget tree, route와 app lifecycle
- Future·Stream, controller와 subscription 소유권
- Loading, empty, error, stale와 success 요구

## 작업 절차

1. State를 widget-local, route/shared, app-level, remote/cache와 derived 값으로 분류한다.
2. State를 읽고 변경하는 가장 가까운 lifecycle owner를 정한다.
3. Future의 실행·중복·stale result와 Stream의 구독·오류·종료 정책을 정의한다.
4. Controller, listener와 subscription의 생성·교체·dispose 책임을 연결한다.
5. State 변경이 rebuild하는 범위와 selector/분리 필요성을 측정 근거로 검토한다.
6. Loading, empty, error와 success transition 및 일회성 UI event를 구분한다.
7. Lifecycle, navigation, background/restore와 실패 경로를 test한다.

## 검증 기준

- State source와 lifecycle owner가 하나로 식별된다.
- Local state가 필요 없이 app-level로 승격되지 않는다.
- Future·Stream의 중복, stale, 오류와 종료 결과가 정의된다.
- 모든 controller/subscription에 명확한 dispose 책임이 있다.
- Rebuild와 async UI 상태가 관련 widget test로 검증된다.

## 금지 패턴

- 모든 state를 하나의 global object에 모으지 않는다.
- Build마다 Future·Stream과 subscription을 무조건 새로 만들지 않는다.
- Dispose 누락이나 stale callback을 library가 자동 해결한다고 가정하지 않는다.
- 특정 상태관리 library의 기능을 소유권 판단 근거로 삼지 않는다.

## 완료 기준

- Local/app/remote state와 소유 경계가 정리된다.
- Async source, lifecycle과 dispose 정책이 명시된다.
- State transition 및 rebuild 검증이 통과한다.
- Library-specific 결정과 미검증 platform lifecycle이 보고된다.

## 참고 문서

- `stacks/mobile/flutter/agents.fragment.md`
- `stacks/bridge/dart-flutter/agents.fragment.md`
- `skills/frontend/state-management-review/SKILL.md`
