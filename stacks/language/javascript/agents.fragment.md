# JavaScript Language Fragment

## 목적

JavaScript의 module, 비동기 흐름, 오류 처리, 데이터 변경과 type 안정성에 공통으로 적용할 언어 수준의 판단 기준을 정의한다. UI framework, server framework와 runtime 제품별 API 규칙은 다루지 않는다.

## 적용 대상

- Stack 식별자: `language-javascript`
- 적용 조건: JavaScript module을 작성, 수정 또는 검토하는 프로젝트
- 제외 조건: 특정 framework의 component, rendering, routing 또는 lifecycle 규칙

## 핵심 규칙

- 프로젝트가 선택한 module 체계를 일관되게 사용하고 한 경계에서 서로 다른 module 방식을 암묵적으로 혼용하지 않는다.
- Promise 기반 흐름은 `async`/`await`로 성공, 실패와 순서를 읽을 수 있게 표현한다. 병렬 실행은 작업 간 의존성이 없고 실패 정책이 정의된 경우에만 사용한다.
- Error는 의미 있는 context와 원인을 보존해 전달하고, 처리할 수 있는 경계에서만 catch한다. Rejection을 방치하지 않는다.
- 객체와 collection을 갱신할 때 기존 참조의 공유 여부를 확인하고, 관찰 가능한 상태는 immutable update로 변경 이력을 명확히 한다.
- 외부 입력과 동적 데이터는 runtime 경계에서 검증하며, 함수의 입력·출력 shape가 바뀌지 않도록 명시적인 계약을 유지한다.
- `undefined`, `null`, property 부재를 서로 다른 의미로 사용한다면 API 계약에서 구분한다.

## 권장 패턴

- Named export와 module별 좁은 공개 surface를 사용하고 순환 의존을 피한다.
- 독립 작업의 병렬 처리는 결과 순서, 부분 실패와 취소 가능성을 먼저 정한 뒤 구성한다.
- 작은 순수 함수와 새로운 객체·배열 반환을 우선해 상태 변경 범위를 제한한다.
- 프로젝트가 채택한 정적 분석 또는 문서화 방식으로 parameter, 반환값과 객체 shape를 검증 가능하게 표현한다.

## 금지 패턴

- Module load 시점에 예측하기 어려운 I/O나 전역 상태 변경을 수행하지 않는다.
- Promise chain과 `async`/`await`를 불필요하게 섞거나 await 누락으로 오류와 종료 시점을 잃지 않는다.
- 빈 `catch`, 문자열만 throw하는 방식 또는 원인을 제거하는 재throw를 사용하지 않는다.
- 공유 객체나 배열을 호출자가 모르게 직접 변경하지 않는다.
- Truthy/falsy 검사만으로 유효한 `0`, 빈 문자열과 실제 값 부재를 혼동하지 않는다.

## 검증 기준

- Module 경계와 export가 일관되고 순환 의존 및 import 부작용이 없다.
- 모든 비동기 작업의 완료, 실패와 병렬 실행 정책을 호출자가 관찰할 수 있다.
- Error의 유형, context와 원인이 보존되며 처리되지 않은 rejection이 없다.
- 상태 갱신이 참조 공유를 고려하고 외부 데이터가 사용 전에 검증된다.
- 프로젝트가 선언한 runtime, 정적 분석, lint와 관련 test가 통과하거나 미실행 사유가 보고된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: JavaScript module, async 또는 type 안정성 전용 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- JavaScript module, 상태, 비동기 또는 error 모델을 framework/platform lifecycle과 연결해야 할 때 bridge가 필요하다.
- Component, rendering과 framework state 규칙은 이 fragment에 추가하지 않는다.
