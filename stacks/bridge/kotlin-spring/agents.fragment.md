# Kotlin–Spring Bridge Fragment

## 목적

Kotlin의 nullability, type·class 특성과 coroutine을 Spring의 bean, configuration binding, proxy와 transaction context에 안전하게 연결하는 조합 규칙을 정의한다. Kotlin 또는 Spring 단독 사용 원칙은 반복하지 않는다.

## 적용 대상

- Bridge 식별자: `bridge-kotlin-spring`
- 필수 stack: `language-kotlin`, `framework-spring`
- 제외 조건: Kotlin 또는 Spring 중 하나만 선택된 구성

## 핵심 규칙

- Configuration binding의 필수값, 선택값과 기본값을 Kotlin nullability 및 생성 계약과 일치시키고 누락 값을 강제 unwrap으로 숨기지 않는다.
- Spring이 생성·주입하는 bean의 생성자와 property는 container lifecycle과 Kotlin의 불변성 요구를 함께 만족하게 한다.
- Proxy가 필요한 component는 class/method의 상속·가로채기 가능 여부를 확인한다. Kotlin의 기본 final 특성과 proxy 방식이 충돌하지 않는다고 가정하지 않는다.
- Coroutine 경계에서 transaction, 보안 정보와 진단 context가 suspension 및 dispatcher 전환 뒤에도 보존되는지 지원 방식으로 확인한다.
- Spring convention을 따르기 위해 Kotlin의 명시적 null 계약과 간결한 표현을 약화하거나, Kotlin idiom을 위해 container 경계를 숨기지 않는다.

## 권장 패턴

- Configuration 값은 생성 시 검증 가능한 응집된 타입으로 묶고 binding 실패를 시작 시점에 드러낸다.
- Proxy 적용 대상과 순수 Kotlin domain/value type을 분리해 framework 제약의 확산을 제한한다.
- Coroutine을 사용하는 entry point는 scope, 취소, context와 transaction 지원 여부를 함께 문서화한다.
- Java 기반 Spring API와 만나는 경계에서는 platform type과 null annotation을 확인한 뒤 Kotlin 계약으로 변환한다.

## 금지 패턴

- Binding 실패를 nullable property, `lateinit` 또는 임의 기본값으로 무조건 우회하지 않는다.
- Proxy 적용 여부를 검토하지 않고 모든 Spring component를 final 상태로 두거나 반대로 모든 class를 열지 않는다.
- 일반적인 thread-local transaction이 coroutine suspension을 자동으로 안전하게 통과한다고 가정하지 않는다.
- Framework 호출 규약을 extension이나 DSL 뒤에 숨겨 lifecycle과 side effect를 추적할 수 없게 하지 않는다.

## 검증 기준

- Configuration 누락·잘못된 값과 nullability 불일치가 예측 가능한 시점에 실패한다.
- Proxy가 필요한 component의 호출 경로와 가로채기 조건이 실제 설정과 일치한다.
- Coroutine의 취소, context 전파와 transaction 시작·종료가 suspension 경계를 포함해 검증된다.
- Kotlin–Spring 경계 test가 bean 생성, binding과 proxy 동작을 단독 언어 test와 구분해 확인한다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Kotlin–Spring configuration, proxy 또는 coroutine transaction 진단 skill이 registry에 등록된 이후 해당 조건에서만 참조한다.

## Bridge 필요 조건

- `language-kotlin`과 `framework-spring`이 모두 선택될 때만 적용한다.
- Persistence 또는 API 계약까지 연결하면 `spring-rdb` 등 해당 영역 bridge를 추가로 선택한다.
