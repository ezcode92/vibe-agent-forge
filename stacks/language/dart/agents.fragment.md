# Dart Language Fragment

## 목적

Dart의 null safety, 비동기 값과 stream, class·model 및 collection 처리에 공통으로 적용할 언어 수준의 판단 기준을 정의한다. UI toolkit, platform lifecycle과 제품별 package 사용법은 다루지 않는다.

## 적용 대상

- Stack 식별자: `language-dart`
- 적용 조건: Dart source를 작성, 수정 또는 검토하는 프로젝트
- 제외 조건: 특정 platform의 화면, 상태 관리, navigation 또는 lifecycle 규칙

## 핵심 규칙

- Null 가능성은 타입과 생성 계약으로 표현하고, `!`는 해당 시점의 non-null 보장이 명백하고 검증된 경우에만 사용한다.
- `late`는 초기화 시점이 lifecycle상 보장되지만 생성 시 값을 제공할 수 없는 경우로 제한하고 일반적인 nullable 회피 수단으로 사용하지 않는다.
- `Future`는 단일 비동기 결과, `Stream`은 시간에 따른 여러 값에 사용한다. 오류와 완료를 호출자가 관찰할 수 있게 한다.
- Stream subscription을 소유하는 구성 요소가 취소 시점과 resource 정리를 책임진다.
- Class는 유효 상태와 동작을 함께 소유하게 하고, model은 값 의미, 불변성 및 equality 요구를 명확히 한다.
- Collection 변환은 element nullability, lazy/eager 평가와 반환 collection의 수정 가능성을 고려한다.

## 권장 패턴

- 가능한 field에는 `final`을 사용하고 생성자에서 필수 상태와 불변식을 확정한다.
- 비동기 함수의 반환 타입과 실패 가능성을 명시하고 순차·병렬 실행 의도를 코드 구조로 드러낸다.
- 값 중심 model은 변경 대신 새 값을 만드는 방식을 우선 검토하고 equality 의미를 일관되게 유지한다.
- Collection pipeline이 복잡해지면 이름 있는 단계나 명시적 반복으로 분리한다.

## 금지 패턴

- `!`, `late` 또는 임의 기본값으로 잘못된 초기화와 값 부재를 숨기지 않는다.
- `async` 함수에서 반환되지 않거나 관찰되지 않는 비동기 작업을 암묵적으로 시작하지 않는다.
- 종료 조건이 없는 Stream subscription을 만들거나 error event를 무시하지 않는다.
- Mutable collection을 외부에 그대로 노출해 model의 상태가 우회 변경되게 하지 않는다.
- 값 객체와 lifecycle을 가진 service 성격의 class를 같은 model 규칙으로 다루지 않는다.

## 검증 기준

- Public API의 nullability와 초기화 순서가 명시적이며 강제 unwrap과 `late`의 근거가 확인된다.
- Future와 Stream 선택, 오류·완료 처리 및 subscription 정리 책임이 명확하다.
- Class와 model의 불변식, identity 또는 value equality 의미가 일관된다.
- Collection 처리에서 nullability, 평가 방식과 mutation 범위를 검토했다.
- 프로젝트가 선언한 analyzer, formatter와 관련 test가 통과하거나 미실행 사유가 보고된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Dart async, model 또는 package 전용 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Dart async, model 또는 null safety를 platform lifecycle과 상태 관리 경계에 연결해야 할 때 bridge가 필요하다.
- Widget, navigation과 platform 상태 규칙은 이 fragment에 추가하지 않는다.
