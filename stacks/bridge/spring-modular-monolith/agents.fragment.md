# Spring–Modular Monolith Bridge Fragment

## 목적

Spring의 bean·application service·transaction 경계를 Modular Monolith의 module 공개 API, 의존 방향과 데이터 소유권에 연결하는 조합 규칙을 정의한다. Spring 단독 규칙과 Modular Monolith 일반 원칙은 반복하지 않는다.

## 적용 대상

- Bridge 식별자: `bridge-spring-modular-monolith`
- 필수 stack: `framework-spring`, `architecture-modular-monolith`
- 제외 조건: Spring 또는 Modular Monolith 중 하나만 선택되거나 module 경계를 적용하지 않는 구성

## 핵심 규칙

- Spring bean은 소유 module 안에서 구성하고 다른 module은 공개 application API를 통해서만 협력한다. Container 등록 가능성이 module 내부 접근 허용을 의미하지 않는다.
- Module 간 의존 방향은 business capability와 공개 계약을 기준으로 단방향으로 유지하고 내부 bean·type을 직접 주입해 우회하지 않는다.
- Module 내부 layer는 transport, application, domain과 persistence 책임을 구분하되 모든 module에 동일한 계층 수를 기계적으로 강제하지 않는다.
- Transaction boundary는 operation과 데이터를 소유한 module의 application service에 둔다. 여러 module을 묶는 transaction은 일관성 요구와 결합 비용을 명시한 경우로 제한한다.
- 즉시 결과와 강한 일관성이 필요하면 공개 application service 호출을 우선 검토하고, 결합 완화·후속 처리가 목적이면 event를 사용하되 전달·실패·중복 의미를 정의한다.
- Package boundary는 module 공개 API와 내부 구현을 구분해야 하며 component scan이나 자동 wiring이 내부 경계를 무효화하지 않게 한다.
- 공유 database를 사용해도 table과 write 책임은 module별로 소유하고 다른 module의 table을 직접 변경하지 않는다.
- 단일 배포·process의 장점을 유지하고 독립 service처럼 network, 복제 model과 분산 실패 abstraction을 근거 없이 추가하지 않는다.

## 권장 패턴

- Module별 공개 application API를 작게 유지하고 다른 module이 필요한 operation과 결과만 노출한다.
- Module 간 호출과 event마다 source, consumer, transaction 시점과 실패 책임을 기록한다.
- Cross-module read는 소유 module의 공개 query 또는 명시된 read model을 통해 수행하고 데이터 최신성 요구를 함께 검토한다.
- Module test는 내부 business rule, 공개 계약과 Spring wiring 경계를 구분해 검증한다.

## 금지 패턴

- 다른 module의 내부 service, repository, entity와 table을 직접 참조하지 않는다.
- 모든 bean을 공통 package나 shared module에 모아 module ownership을 잃지 않는다.
- Transaction 편의를 위해 여러 module의 write 책임을 하나의 범용 service에 집중시키지 않는다.
- In-process module 통신을 원격 호출처럼 포장하거나 불필요한 serialization·retry·분산 tracing 계층을 추가하지 않는다.
- Event를 호출 순서와 오류 처리를 숨기는 수단으로 사용하지 않는다.

## 검증 기준

- Bean과 configuration의 module 소유자, 공개 API와 내부 경계가 식별된다.
- Module dependency가 비순환이며 내부 package·bean에 대한 우회 접근이 없다.
- Transaction과 data/table ownership이 같은 module 책임에 맞고 cross-module write가 통제된다.
- Application service와 event 선택이 일관성, 시점과 실패 요구로 설명된다.
- Module test가 공개 계약, wiring과 금지 dependency를 검증한다.
- Network/service abstraction 없이 단일 배포 모델의 단순성이 유지된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Module boundary, service layer 또는 transaction 검토 skill을 해당 작업 조건에서 참조한다.

## Bridge 필요 조건

- `framework-spring`과 `architecture-modular-monolith`가 모두 선택되고 Spring bean·transaction이 module 경계 안에서 동작할 때 적용한다.
- 독립 배포, 장애 격리와 service별 운영 책임이 실제 요구가 되면 이 bridge를 확장하지 않고 MSA profile·fragment 전환을 검토한다.
