# React Frontend Fragment

## 목적

React component, state, 단방향 data flow, side effect, API client 경계와 rendering 비용에 공통으로 적용할 framework 수준의 판단 기준을 정의한다. 기반 언어의 module·비동기 문법, backend API 계약과 전체 architecture는 다루지 않는다.

## 적용 대상

- Stack 식별자: `frontend-react`
- 적용 조건: React로 UI와 상호작용을 구성하는 frontend 프로젝트
- 제외 조건: 기반 언어만 사용하는 module 또는 특정 backend·전송 protocol의 세부 설계

## 핵심 규칙

- Component는 하나의 UI 책임과 변경 이유를 가지게 하고, 화면 조합과 재사용 가능한 표현 책임을 필요에 따라 분리한다.
- State는 이를 읽고 변경하는 가장 가까운 공통 소유자에 둔다. 다른 값에서 계산 가능한 값은 별도 state로 중복 저장하지 않는다.
- Props는 명시적인 입력 계약으로 사용하고 자식 component가 부모 소유 데이터를 직접 변경하지 않게 한다.
- Data flow는 상위에서 하위로 전달하고, 상태 변경 의도는 callback 또는 합의된 상태 경계를 통해 위임한다.
- Side effect는 외부 시스템과 동기화할 때만 사용한다. Rendering 중 effect를 발생시키거나 effect로 순수 계산을 대체하지 않는다.
- API client는 transport 호출, serialization과 오류 정규화의 경계를 제공하고 component가 endpoint와 wire format 세부사항을 직접 소유하지 않게 한다.
- Rendering 최적화는 측정된 비용이나 안정된 참조가 필요한 경계에만 적용하며 memoization을 기본값으로 사용하지 않는다.

## 권장 패턴

- 작은 component를 만들되 데이터와 동작이 항상 함께 바뀌면 하나의 응집된 책임으로 유지한다.
- 상태 전이는 가능한 한 명시적인 event와 단일 갱신 경로로 표현한다.
- Effect의 dependency는 실제 읽는 값과 일치시키고 cleanup에서 subscription, timer와 진행 중 작업을 정리한다.
- Loading, empty, failure와 success 상태를 구분해 UI 결과가 비동기 상태를 명확히 반영하게 한다.
- Rendering 병목은 profiler와 재현 가능한 측정을 근거로 component 경계, state 위치와 계산 비용부터 조정한다.

## 금지 패턴

- 모든 값을 전역 state로 올리거나 서로 독립적인 책임을 하나의 거대 component에 모으지 않는다.
- Props를 여러 계층에 전달한다는 이유만으로 새로운 전역 상태 도구를 도입하지 않는다.
- Effect 안에서 무조건 state를 복제·동기화하거나 dependency 경고를 억제해 lifecycle 문제를 숨기지 않는다.
- Component에서 API URL, transport response shape와 인증 세부사항을 직접 처리하지 않는다.
- 근거 없이 모든 callback, 계산과 component를 memoize하거나 key를 불안정하게 생성하지 않는다.
- Rendering 결과를 외부 mutable 상태나 호출 순서에 의존하게 하지 않는다.

## 검증 기준

- Component별 UI 책임, props 계약과 state 소유자가 명확하다.
- Derived data가 중복 state로 저장되지 않고 상태 변경 흐름을 추적할 수 있다.
- Effect가 실제 외부 동기화만 담당하며 dependency와 cleanup이 정확하다.
- API client와 UI 사이에 loading·failure·data 상태의 명시적인 경계가 있다.
- 성능 변경은 측정 근거가 있고 동작·접근성 회귀를 만들지 않는다.
- 프로젝트가 선언한 React test, lint와 build가 통과하거나 미실행 사유가 보고된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: React rendering, state 또는 effect 진단 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- 기반 언어의 module·비동기·데이터 변경 규칙을 React lifecycle에 연결할 때 language–React bridge가 필요하다.
- Backend 계약, 오류 형식과 인증 흐름을 API client에 연결할 때 API 또는 backend bridge가 필요하다.
- 해당 조합의 세부 규칙은 이 fragment에 추가하지 않는다.
