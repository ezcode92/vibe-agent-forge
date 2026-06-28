# Kotlin Language Fragment

## 목적

Kotlin의 null safety, 값 타입, 확장 함수와 coroutine을 일관되게 사용하는 언어 수준의 판단 기준을 정의한다. Framework 설정, component lifecycle과 제품별 library 규칙은 다루지 않는다.

## 적용 대상

- Stack 식별자: `language-kotlin`
- 적용 조건: Kotlin source를 작성, 수정 또는 검토하는 프로젝트
- 제외 조건: 특정 framework 또는 platform이 소유하는 실행·상태 관리 규칙

## 핵심 규칙

- Null 가능성은 타입으로 표현하고, `?.`, `?:`, `let` 등은 값 부재의 의미와 제어 흐름이 분명할 때 사용한다. `!!`는 외부에서 보장된 불변식을 즉시 검증하는 제한된 경계 외에는 사용하지 않는다.
- `data class`는 구조적 동등성과 값 복사가 의미 있는 데이터에 사용하며, identity와 복잡한 lifecycle을 가진 객체에 기계적으로 적용하지 않는다.
- Sealed class/interface는 유한한 상태나 결과 집합을 표현하고 모든 경우를 명시적으로 처리할 필요가 있을 때 사용한다.
- Extension function은 대상 타입의 자연스러운 보조 연산에 사용하고, 숨은 I/O나 광범위한 상태 변경을 감추지 않는다.
- Coroutine은 호출자의 scope와 취소를 따르는 structured concurrency로 구성한다. 취소를 삼키지 않고 blocking 작업과 suspending 작업의 경계를 명확히 한다.
- Java 상호운용 경계에서는 platform type, nullability annotation, exception과 collection mutability 차이를 확인한다.

## 권장 패턴

- 불변 `val`, expression과 작은 순수 함수를 기본으로 하고 실제 상태 변경이 필요한 범위만 제한한다.
- 상태와 실패 집합이 닫혀 있으면 sealed type과 exhaustive `when`으로 누락을 드러낸다.
- Extension의 package와 이름을 좁게 유지해 호출 위치에서 동작과 출처를 예측할 수 있게 한다.
- Coroutine dispatcher, scope와 timeout의 소유자는 호출 관계에서 명시하고 test에서 대체 가능한 경계를 둔다.

## 금지 패턴

- Null 가능성을 숨기기 위해 `!!` 또는 의미 없는 기본값을 반복 사용하지 않는다.
- 모든 class를 `data class`로 만들거나 mutable property를 가진 data class를 값 객체처럼 취급하지 않는다.
- 기존 member와 혼동되는 extension, 과도하게 일반적인 extension 또는 부작용을 숨기는 extension을 만들지 않는다.
- 소유자와 종료 조건이 없는 독립 coroutine을 시작하거나 취소 exception을 일반 실패로 소비하지 않는다.
- Java 스타일을 그대로 옮긴 불필요한 boilerplate와 nullable collection/element 의미의 혼용을 피한다.

## 검증 기준

- Public API의 nullability와 collection mutability가 명시적이고 강제 unwrap의 근거를 확인할 수 있다.
- `data class`와 sealed type의 선택이 각각 값 의미와 닫힌 상태 집합에 부합한다.
- Extension이 명시적 책임을 가지며 숨은 부작용이나 이름 충돌을 만들지 않는다.
- Coroutine의 scope, 취소 전파, blocking 경계와 실패 처리가 검토 가능하다.
- 프로젝트가 선언한 compiler, 정적 분석과 관련 test가 통과하거나 미실행 사유가 보고된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Kotlin 또는 coroutine 전용 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Kotlin nullability, coroutine 또는 type 표현을 framework/platform lifecycle과 연결해야 할 때 bridge가 필요하다.
- Framework annotation, component 생성 규칙과 실행 context는 이 fragment에 추가하지 않는다.
