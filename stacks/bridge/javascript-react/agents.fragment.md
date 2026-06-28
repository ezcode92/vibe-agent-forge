# JavaScript–React Bridge Fragment

## 목적

JavaScript의 object·module·async 특성을 React의 props, state, effect와 rendering lifecycle에 연결하는 조합 규칙을 정의한다. JavaScript와 React의 단독 규칙은 반복하지 않는다.

## 적용 대상

- Bridge 식별자: `bridge-javascript-react`
- 필수 stack: `language-javascript`, `frontend-react`
- 제외 조건: JavaScript 또는 React 중 하나만 선택된 구성

## 핵심 규칙

- Props와 state의 object/array는 소유 component 밖에서 mutation하지 않고, React가 변경을 감지할 수 있는 새 참조와 명시적 update 경로를 사용한다.
- Async 작업은 effect lifecycle에 맞춰 시작·정리하고 늦게 도착한 결과가 더 최신 state 또는 unmounted component를 덮어쓰지 않게 한다.
- Promise rejection과 API 오류를 UI state로 변환하는 경계를 두고 rendering 중 throw·side effect를 임의로 발생시키지 않는다.
- Component module은 UI 조합과 hook 사용을 소유하고 framework 독립적인 변환·검증·계산은 utility/domain module로 분리한다.
- Module singleton의 mutable state를 component state 대용으로 사용하지 않으며 test 간 상태가 누출되지 않게 한다.

## 권장 패턴

- State update는 이전 값에 의존하는지 명시하고 nested object 변경 시 필요한 경로만 복사한다.
- Effect마다 외부 동기화 책임을 하나로 제한하고 요청 취소 또는 stale result 무시 정책을 둔다.
- React에 의존하지 않는 함수는 독립 module에서 순수하게 유지해 component test와 별도로 검증한다.
- Event handler와 async callback이 캡처하는 state가 최신이어야 하는지 lifecycle 기준으로 확인한다.

## 금지 패턴

- Props나 state object를 직접 변경한 뒤 동일 참조로 update하지 않는다.
- `async` effect callback 자체를 cleanup 계약 대신 사용하거나 완료 순서를 확인하지 않은 요청 결과를 반영하지 않는다.
- 모든 utility를 component file에 두거나 hook을 framework 독립 module로 누출하지 않는다.
- Dependency 누락과 stale closure 문제를 lint 억제로 숨기지 않는다.

## 검증 기준

- Object mutation 없이 state transition과 rendering 결과가 일관되게 관찰된다.
- Async 완료 순서, 취소, unmount와 오류 경로가 UI lifecycle test에 포함된다.
- Component와 utility/module의 dependency direction이 분명하고 순수 로직은 독립 test 가능하다.
- Effect dependency와 callback closure가 실제 읽는 state/props와 일치한다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: JavaScript–React mutation, async 또는 effect 진단 skill이 registry에 등록된 이후 해당 조건에서만 참조한다.

## Bridge 필요 조건

- `language-javascript`와 `frontend-react`가 모두 선택될 때만 적용한다.
- Backend API contract까지 연결하면 `react-spring-api` 등 해당 API bridge를 추가로 선택한다.
