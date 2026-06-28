# Spring–Modular Monolith Bridge 가이드

## 목적

Spring application의 container·transaction 경계와 Modular Monolith의 module 공개 API·데이터 소유권을 함께 적용할 때 생기는 조합 책임을 설명한다. 단일 stack fragment에 다른 stack 전제를 넣지 않고 profile이 필요한 bridge를 명시적으로 선택하게 하는 것이 목적이다.

## Bridge가 필요한 이유

Spring은 bean, configuration, application service와 transaction lifecycle을 제공하지만 어떤 business module이 이를 소유하는지는 결정하지 않는다. Modular Monolith는 module 경계, 의존 방향과 데이터 소유권을 정의하지만 Spring container가 경계를 우회하지 않게 하는 방식은 결정하지 않는다.

두 fragment만 선택하면 다음 질문이 조합 수준에 남는다.

- 다른 module의 bean을 직접 주입해도 되는가?
- Module 공개 API와 Spring application service의 경계를 어디에 둘 것인가?
- Transaction이 여러 module을 포함할 때 누가 operation을 소유하는가?
- In-process 호출과 event 중 어느 쪽을 선택할 것인가?
- 공유 database 안에서 table write ownership을 어떻게 지킬 것인가?
- Component scan과 package visibility가 module 내부 경계를 약화하지 않는가?

이 bridge는 위 질문의 판단 기준만 제공하고 실제 package, annotation과 configuration 예시는 제공하지 않는다.

## 기존 Fragment와의 책임 차이

| Source | 독립 책임 | 이 Bridge가 추가하는 연결 책임 |
| --- | --- | --- |
| `framework-spring` | Bean, configuration, transaction, validation과 test context | Bean/application service를 module 공개·내부 경계에 배치 |
| `architecture-modular-monolith` | Module API, dependency direction, data ownership와 단일 배포 | Spring wiring, transaction과 event를 module ownership에 연결 |
| `bridge-spring-rdb` | Spring persistence lifecycle과 RDB 경계 | Module별 table/write ownership과 Spring service 경계 연결 |

각 source의 일반 규칙은 반복하지 않고 동시에 선택될 때만 필요한 상호작용을 bridge에 둔다.

## Profile 포함 조건

다음 조건을 모두 만족하면 bridge를 필수로 포함한다.

- `framework-spring`을 선택했다.
- `architecture-modular-monolith`를 선택했다.
- Spring bean, application service 또는 transaction이 둘 이상의 module 경계와 상호작용한다.

현재 backend Java/Kotlin Spring RDB 및 fullstack Spring React profile은 Spring과 Modular Monolith를 함께 선택하므로 이 bridge를 포함한다.

Spring만 사용하고 명시적 module architecture를 선택하지 않았거나, Modular Monolith가 Spring과 무관한 영역에만 적용되면 이 bridge를 자동 추가하지 않는다.

## Application Service와 Event 선택

- 동기 결과와 같은 transaction의 강한 일관성이 필요하면 소유 module의 공개 application service를 우선 검토한다.
- 후속 처리, 결합 완화 또는 여러 consumer가 필요하면 event를 검토한다.
- Event를 선택하면 발행 시점, transaction 성공과의 관계, 중복·실패 및 consumer 책임을 명시한다.
- 단일 process 안에서 해결할 수 있는 호출에 원격 통신 수준의 복잡성을 기본 적용하지 않는다.

## MSA로 전환할 조건

다음 요구가 반복적이고 측정 가능한 경우 Modular Monolith bridge 확장보다 MSA profile 전환을 검토한다.

- Module별 독립 배포와 release cadence가 필요하다.
- 장애와 resource 사용을 process 수준에서 격리해야 한다.
- 서로 다른 팀이 runtime, 운영 책임과 SLO를 독립 소유해야 한다.
- Data store와 consistency 정책을 service별로 독립 운영해야 한다.
- Network 경계의 latency, timeout, retry와 관측 비용을 감수할 근거가 있다.

Package 분리, bean 수 증가 또는 미래 확장 가능성만으로 MSA로 전환하지 않는다. 전환 시 `architecture-msa`와 필요한 API/database bridge를 새로 검증한다.

## Dry-run Warning과의 관계

Phase 9-1 dry-run에서는 `spring-modular-monolith` compatibility가 `bridge-pending`이어서 warning이 발생했다. 새 fragment와 catalog 관계를 등록하고 관련 profile에 bridge를 포함하면 다음 조건이 충족된다.

- Compatibility relation이 supported `requires-bridge`가 된다.
- Required bridge path와 dependency가 존재한다.
- Merge trace에 priority 50 bridge가 포함된다.
- Spring bean/module, transaction/module과 table ownership의 중복·충돌 판단 근거가 생긴다.

이는 adapter draft, 실제 project metadata와 file export 지원까지 해결한다는 의미가 아니다.

## 검증 기준

- Profile이 Spring과 Modular Monolith를 함께 선택하면 bridge도 선택한다.
- Fragment catalog dependency가 `framework-spring`, `architecture-modular-monolith`와 일치한다.
- Module 내부 bean·package·table을 다른 module이 직접 참조하지 않는다.
- Transaction과 event 사용 근거가 module ownership 및 일관성 요구와 연결된다.
- 단일 배포 장점을 훼손하는 MSA 유사 abstraction이 기본값으로 추가되지 않는다.

## 현재 범위

이 문서는 bridge 설계와 profile 선택 기준만 제공한다. Spring code, package layout, configuration, module 검사 도구와 MSA migration은 구현하지 않는다.
