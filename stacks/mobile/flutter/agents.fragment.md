# Flutter Platform Fragment

## 목적

Flutter widget 구조, state 경계, 비동기 UI, navigation, API client와 platform-specific 코드 분리에 공통으로 적용할 platform 수준의 판단 기준을 정의한다. 기반 언어의 null·비동기 문법, remote API 계약과 전체 architecture는 다루지 않는다.

## 적용 대상

- Stack 식별자: `mobile-flutter`
- 적용 조건: Flutter로 여러 platform의 UI와 상호작용을 구성하는 프로젝트
- 제외 조건: 기반 언어만 사용하는 package 또는 특정 backend·native platform API의 세부 구현

## 핵심 규칙

- Widget은 화면 조합, 표현 또는 상호작용 중 명확한 UI 책임을 가지게 하고 build 과정에 외부 부작용을 넣지 않는다.
- State는 lifecycle과 갱신 범위에 맞는 가장 가까운 소유자에 둔다. 계산 가능한 값을 중복 저장하거나 화면 전체를 불필요하게 다시 구성하지 않는다.
- UI는 loading, empty, failure와 success 상태를 명시적으로 표현하고 dispose 이후의 비동기 결과가 state를 변경하지 않게 한다.
- Navigation은 route 식별, 입력, 결과와 접근 조건을 한 경계에서 관리하고 widget 내부에 화면 전환 규칙을 산재시키지 않는다.
- API client는 remote 호출, serialization과 오류 정규화를 담당하며 widget이 endpoint와 wire format을 직접 처리하지 않게 한다.
- Platform-specific 코드는 공통 interface 뒤에 격리하고 지원 platform, 권한, 실패와 대체 동작을 명시한다.
- Controller, subscription과 observer를 소유한 객체가 lifecycle 종료 시 이를 해제한다.

## 권장 패턴

- 변경되지 않는 widget 구성에는 가능한 범위에서 안정된 인스턴스를 사용하고 rebuild 범위를 실제 state 소비자까지 제한한다.
- 화면 상태와 일회성 UI event를 구분해 동일 event가 rebuild에 의해 반복되지 않게 한다.
- 비동기 요청은 현재 화면의 lifecycle, 중복 실행과 취소 또는 stale result 처리 정책을 함께 정의한다.
- Navigation 입력은 화면 진입 전에 검증하고 deep link와 복원 경로에서도 동일한 화면 계약을 유지한다.
- Platform adapter는 공통 동작과 native 구현을 분리해 지원하지 않는 환경에서도 예측 가능한 실패를 반환한다.

## 금지 패턴

- Build 중 network, storage, navigation 또는 state 갱신을 직접 실행하지 않는다.
- 모든 상태를 application 전역에 두거나 단일 state object가 무관한 화면 책임을 함께 소유하게 하지 않는다.
- Widget이 API 응답 구조, 인증 header나 platform channel payload를 직접 해석하지 않는다.
- 비동기 callback에서 lifecycle 확인 없이 state를 변경하거나 subscription과 controller를 해제하지 않은 채 남기지 않는다.
- Platform 분기를 UI 곳곳에 반복하거나 지원하지 않는 platform에서 조용히 다른 동작을 수행하지 않는다.
- 성능 근거 없이 widget tree를 과도하게 분할하거나 cache를 추가하지 않는다.

## 검증 기준

- Widget 책임, state 소유권과 rebuild 범위가 명확하다.
- 비동기 UI의 모든 상태와 stale result·lifecycle 종료 처리가 검증된다.
- Navigation 입력·결과 및 deep link 경계가 일관되고 화면 전환 규칙이 집중되어 있다.
- API client와 UI가 분리되고 platform-specific 구현이 공통 경계 밖으로 누출되지 않는다.
- Controller, subscription과 observer의 생성·해제 책임이 짝을 이룬다.
- 프로젝트가 선언한 Flutter widget/test, analyzer와 build가 통과하거나 미실행 사유가 보고된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Flutter state, navigation, rendering 또는 platform 연동 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- 기반 언어의 async·stream·model 규칙을 Flutter lifecycle과 연결할 때 language–Flutter bridge가 필요하다.
- Remote API 계약과 오류 모델을 API client에 연결하거나 native 기능 계약을 확정할 때 API/platform bridge가 필요하다.
- 해당 조합의 세부 규칙은 이 fragment에 추가하지 않는다.
