# Java–Spring Bridge Fragment

## 목적

Java의 객체·타입·exception 계약을 Spring의 layer, bean, validation과 transaction 흐름에 연결하는 조합 규칙을 정의한다. Java와 Spring 각각의 일반 원칙은 반복하지 않는다.

## 적용 대상

- Bridge 식별자: `bridge-java-spring`
- 필수 stack: `language-java`, `framework-spring`
- 제외 조건: Java 또는 Spring 중 하나만 선택된 구성

## 핵심 규칙

- Java 객체의 불변식과 Spring layer 책임을 일치시키고 controller/service/component가 domain 상태를 우회 변경하지 않게 한다.
- Spring bean은 명시적인 생성자 계약으로 필수 dependency를 받고, container 밖에서 생성할 값 객체와 구분한다.
- Record는 값 중심 DTO 또는 configuration 경계에 적합한지 검토하고, proxy 대상이나 identity·mutable lifecycle이 필요한 component로 사용하지 않는다.
- Sealed hierarchy는 닫힌 request/result 또는 상태 집합이 Spring의 serialization, validation과 확장 요구에 부합할 때만 경계에 사용한다.
- Validation 실패, business exception, transaction rollback과 외부 오류 변환의 순서를 구분하고 exception type별 책임을 유지한다.

## 권장 패턴

- Transport DTO, application input과 domain object 사이의 변환 위치를 정해 framework annotation의 확산을 제한한다.
- Service method의 exception 계약과 transaction 결과를 함께 검토해 호출자가 실패 후 상태를 예측하게 한다.
- Record/sealed type을 도입할 때 Spring이 사용하는 생성·변환 방식과 프로젝트 Java 버전의 지원을 확인한다.
- Layer test는 Java 객체 규칙과 Spring container·validation·transaction 결합 동작을 구분한다.

## 금지 패턴

- Spring layer 이름만 붙인 class에 unrelated Java domain 책임을 모으지 않는다.
- Record를 bean lifecycle이나 proxy가 필요한 service/component의 대체물로 사용하지 않는다.
- Checked/unchecked exception 선택과 무관하게 모든 실패를 하나의 전역 handler 또는 rollback 규칙으로 평탄화하지 않는다.
- Validation annotation이 객체의 모든 business invariant와 transaction 전제까지 보장한다고 가정하지 않는다.

## 검증 기준

- Java 객체 경계와 Spring component/layer 책임이 중복되거나 우회되지 않는다.
- Record와 sealed type 사용이 binding·validation·serialization 및 확장 요구와 호환된다.
- Exception 분류, 외부 변환과 transaction rollback 결과가 일관된다.
- Container를 포함한 test가 생성자 주입, validation과 transaction 결합을 필요한 범위에서 검증한다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Java–Spring type, validation 또는 transaction 진단 skill이 registry에 등록된 이후 해당 조건에서만 참조한다.

## Bridge 필요 조건

- `language-java`와 `framework-spring`이 모두 선택될 때만 적용한다.
- Persistence 또는 API 계약까지 연결하면 `spring-rdb` 등 해당 영역 bridge를 추가로 선택한다.
