---
name: state-management-review
description: Frontend state를 local, shared/global, server와 cache로 분류하고 소유 위치, derived state와 async UI 상태를 검토한다. State 구조 변경이나 상태관리 방식 도입·확장을 review할 때 사용한다.
---

# State Management Review

## 목적

State를 실제 소유권과 lifecycle에 맞는 최소 범위에 배치하고 중복, 동기화 오류와 불필요한 전역 결합을 방지한다. 특정 상태관리 library의 store·hook API는 다루지 않는다.

## 사용 조건

- State 위치, 공유 범위 또는 비동기 상태 표현이 변경될 때 적용한다.
- UI 입력인지 server 원본인지 cache인지 먼저 구분한다.
- Library 선택보다 데이터 소유권과 상태 전이를 우선 검토한다.

## 입력 Context

- 상태별 source of truth, reader, writer와 lifecycle
- Component tree, navigation과 공유 범위
- Server request, cache freshness와 invalidation 조건
- Loading, empty, error, success 및 optimistic update 요구

## 작업 절차

1. 각 값을 local UI, shared/global, server, cache 또는 derived state로 분류한다.
2. Reader와 writer의 가장 가까운 공통 경계에 state 소유자를 배치한다.
3. 다른 state에서 계산 가능한 값은 저장하지 않고 계산 비용과 일관성 요구를 확인한다.
4. Server/cache state의 freshness, invalidation, refetch와 중복 요청 정책을 정의한다.
5. Async 상태에서 loading, empty, error, stale와 success를 구분한다.
6. State transition, concurrency, optimistic update와 rollback 결과를 검토한다.
7. Finding을 소유권, 중복, lifecycle과 UI 상태 누락으로 정리한다.

## 검증 기준

- 각 state의 source of truth와 변경 권한이 하나로 식별된다.
- Local state가 필요 없이 global로 승격되지 않는다.
- Derived state가 중복 저장되지 않거나 저장 근거와 동기화 방식이 있다.
- Server/cache freshness와 invalidation 결과를 예측할 수 있다.
- Loading, empty, error, stale와 success 흐름이 검증된다.

## 금지 패턴

- Props 전달이 있다는 이유만으로 모든 상태를 global store로 이동하지 않는다.
- Server response, cache와 편집 중 local 값을 하나의 state로 혼합하지 않는다.
- Effect로 derived state를 반복 동기화하지 않는다.
- Library 기능을 state ownership 결정의 근거로 사용하지 않는다.

## 완료 기준

- State 분류, 소유자와 transition이 문서화된다.
- 중복·stale·동시성 위험과 개선 방향이 정리된다.
- Async UI 상태와 cache 정책 검증이 정의되거나 실행된다.
- Library-specific 후속 결정은 일반 review 결과와 구분된다.

## 참고 문서

- `stacks/frontend/react/agents.fragment.md`
- `skills/frontend/component-design/SKILL.md`
- 프로젝트의 data fetching 및 cache 정책
