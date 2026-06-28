---
name: component-design
description: Frontend component의 UI 책임, props·state·data flow, 재사용 경계와 rendering 영향을 분석해 설계·구현한다. React 화면 또는 component를 새로 만들거나 책임을 재구성할 때 사용한다.
---

# Component Design

## 목적

Component가 명확한 UI 책임과 입력·출력 계약을 가지면서 필요한 수준으로 재사용되고 예측 가능한 rendering 범위를 유지하게 한다. 특정 UI library와 styling 도구의 API는 다루지 않는다.

## 사용 조건

- 화면, component 또는 component hierarchy를 추가·변경할 때 적용한다.
- 단순 markup 변경이면 불필요한 abstraction을 만들지 않는다.
- 구현 권한이 없는 설계 요청에서는 책임과 경계만 제시한다.

## 입력 Context

- 사용자 interaction, 화면 상태와 접근성 요구
- 기존 component tree, props, state와 event flow
- 재사용 후보, 변형 요구와 rendering 성능 증거
- 관련 test, design contract와 project convention

## 작업 절차

1. 화면을 사용자에게 보이는 책임과 변경 이유로 나눈다.
2. 각 component의 props, event, child composition과 소유 state를 정의한다.
3. Data가 상위에서 하위로 흐르고 변경 의도가 명시적 callback으로 돌아오는지 확인한다.
4. 둘 이상의 실제 사용처와 안정된 차이가 있을 때만 재사용 경계를 추출한다.
5. State 소비 범위, key 안정성, 큰 계산과 불필요한 rerender 후보를 검토한다.
6. 최소 component 구조로 구현하고 styling·data fetching·domain 계산 책임을 필요한 경계로 분리한다.
7. Interaction, 상태 전이, 접근성과 rendering 영향에 맞는 test를 실행한다.

## 검증 기준

- Component마다 하나의 설명 가능한 UI 책임이 있다.
- Props와 event 계약이 명시적이고 state 소유자가 하나로 식별된다.
- 재사용 abstraction이 실제 variation을 단순화하고 호출자를 더 복잡하게 만들지 않는다.
- State 변경이 필요한 subtree만 갱신하며 성능 변경은 측정 근거가 있다.
- 주요 interaction과 접근성 의미가 관련 test로 검증된다.

## 금지 패턴

- 파일 크기만을 기준으로 component를 분리하지 않는다.
- 단일 사용처의 가상 요구를 위해 범용 props와 mode flag를 늘리지 않는다.
- Props를 state로 복제하거나 child가 부모 소유 데이터를 직접 변경하게 하지 않는다.
- 근거 없이 모든 component와 callback을 memoize하지 않는다.

## 완료 기준

- Component hierarchy, props/state와 event 흐름이 설명된다.
- 재사용과 단순성의 선택 근거가 있다.
- Interaction, 접근성과 필요한 rendering 검증이 통과한다.
- 미확정 UI 요구와 남은 성능 위험이 보고된다.

## 참고 문서

- `stacks/frontend/react/agents.fragment.md`
- `skills/common/incremental-implementation/SKILL.md`
- 프로젝트의 UI 및 접근성 지침
