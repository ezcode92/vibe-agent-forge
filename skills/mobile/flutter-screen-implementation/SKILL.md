---
name: flutter-screen-implementation
description: Flutter screen의 widget tree, navigation, async UI와 platform-specific 경계를 분석해 작은 단계로 구현·검증한다. 신규 화면 또는 기존 화면 흐름을 변경할 때 사용한다.
---

# Flutter Screen Implementation

## 목적

Screen의 표현, interaction, state와 navigation 책임을 분리하고 lifecycle에 안전한 Flutter UI 구현 절차를 제공한다. Dart 문법과 특정 state/navigation library 사용법은 다루지 않는다.

## 사용 조건

- Flutter screen, route 또는 주요 UI flow를 추가·변경할 때 적용한다.
- 요구사항, navigation 계약과 지원 platform을 먼저 확인한다.
- 설계 요청이면 실제 widget 코드를 만들지 않고 책임 구조와 검증 기준만 제시한다.

## 입력 Context

- 사용자 flow, 화면 상태와 접근성 요구
- 기존 widget tree, state owner와 navigation 구조
- API/async dependency 및 platform-specific 기능
- 관련 widget, integration test와 project convention

## 작업 절차

1. Screen의 입력, 결과, interaction과 loading·empty·error·success 상태를 정의한다.
2. Widget tree를 화면 조합, 재사용 표현과 interaction 책임으로 나눈다.
3. Widget-local state와 외부 state owner의 경계를 정한다.
4. Route 입력·결과, 접근 조건, back/deep-link 흐름을 확인한다.
5. Async 작업의 시작·취소·stale result와 dispose 이후 동작을 설계한다.
6. Platform-specific 호출은 공통 interface 뒤로 분리하고 미지원 동작을 정의한다.
7. 작은 UI 단위부터 구현하고 widget·navigation·lifecycle 검증을 확장한다.

## 검증 기준

- Widget별 책임과 rebuild 범위가 명확하다.
- Screen state와 navigation 입력·결과를 예측할 수 있다.
- Async 완료·오류·취소 및 dispose 경로가 안전하다.
- Platform-specific 코드가 공통 widget tree에 흩어지지 않는다.
- Interaction, 접근성과 주요 platform 차이가 test된다.

## 금지 패턴

- Build 중 network, navigation 또는 state side effect를 실행하지 않는다.
- 한 widget이 API parsing, business rule과 platform 호출을 모두 소유하게 하지 않는다.
- Dispose 이후 callback과 controller를 방치하지 않는다.
- Dart null·async 문법 일반 규칙을 이 skill에 복제하지 않는다.

## 완료 기준

- Widget tree, state, navigation과 platform 경계가 구현 또는 설계된다.
- 주요 async UI와 lifecycle 검증이 통과한다.
- Screen 요구와 접근성 결과가 확인된다.
- Platform별 미검증 사항과 후속 작업이 보고된다.

## 참고 문서

- `stacks/mobile/flutter/agents.fragment.md`
- `stacks/bridge/dart-flutter/agents.fragment.md`
- `skills/common/incremental-implementation/SKILL.md`
