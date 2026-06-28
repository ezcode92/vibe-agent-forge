# Database, API 및 Architecture Fragment 가이드

## 목적

Database fragment는 저장 모델과 일관성, API fragment는 외부 전송 계약, architecture fragment는 system 경계와 dependency direction을 정의한다. 세 분류는 language 문법이나 framework lifecycle과 분리된 상태로 독립 선택 및 조합할 수 있어야 한다.

RDB와 NoSQL은 저장소 유형의 일반 원칙, RESTful API는 HTTP 계약, architecture 5종은 배포 또는 내부 의존성 style의 판단 기준만 제공한다. 특정 제품이나 구현 기술의 지원을 암묵적으로 의미하지 않는다.

## Language 및 Framework Fragment와의 경계

- Language fragment는 타입, module, 오류와 비동기 표현을 책임지며 schema, HTTP 계약이나 system topology를 결정하지 않는다.
- Framework/platform fragment는 component lifecycle, 설정, 상태와 framework test 경계를 책임지며 database 제품, API contract와 architecture 선택을 전제하지 않는다.
- Database/API/architecture fragment는 구현 code, annotation, library와 framework adapter 방식을 포함하지 않는다.

한 규칙이 framework transaction과 RDB transaction처럼 양쪽 의미를 함께 알아야만 완성되면 독립 fragment 중 하나에 넣지 않고 bridge로 분리한다.

## Database, API 및 Architecture 사이의 경계

- Database는 data integrity, consistency, query와 migration을 소유하지만 service/module 배포 경계나 transport response를 결정하지 않는다.
- API는 resource와 HTTP contract를 소유하지만 내부 data model, database schema와 service 구현을 노출하지 않는다.
- Architecture는 module/service boundary, dependency direction, data ownership과 test 격리를 소유하지만 구체 schema와 endpoint 계약은 해당 fragment에 맡긴다.
- Monolith·Modular Monolith·MSA는 배포 및 운영 경계를, Clean·Hexagonal Architecture는 내부 dependency style을 주로 다루며 함께 선택할 수 있다. 중복 책임은 profile 또는 bridge에서 진단한다.

## Bridge Fragment가 필요한 경우

| Bridge 예시 | 연결 책임의 예시 |
| --- | --- |
| `spring-rdb` | Spring transaction lifecycle과 RDB transaction·persistence 경계 연결 |
| `react-spring-api` | React API client와 Spring backend 사이의 request·response·error 계약 연결 |
| `flutter-rest-api` | Flutter async UI 상태와 RESTful API response·error 계약 연결 |
| `msa-restful-api` | Service ownership, 장애 경계와 RESTful API contract·versioning 연결 |
| `modular-monolith-spring` | Modular Monolith module 경계와 Spring bean·configuration 경계 연결 |

위 표는 bridge 책임의 설계 예시이며 실제 bridge fragment나 구현 규칙이 아니다. 관련 stack이 모두 선택된 경우에만 적용하고 원본 fragment에 조합 규칙을 복제하지 않는다.

## Product-specific Fragment 분리 원칙

- 특정 database의 query 언어, index 유형, transaction capability와 운영 설정은 product-specific fragment로 분리한다.
- 특정 framework의 routing, validation, persistence annotation과 container 동작은 framework 또는 bridge fragment에서 다룬다.
- 특정 client library, driver와 serialization 규칙은 language/framework와 API/database를 연결하는 bridge에서 다룬다.
- 일반 fragment는 제품 capability를 사실로 가정하지 않고 확인해야 할 consistency, 성능과 운영 조건을 제시한다.

Product-specific fragment나 bridge가 아직 없으면 일반 규칙만으로 세부 구현을 추정하지 않고 미지원 또는 추가 확인 필요 상태로 진단한다.

## 공통 작성 및 검증 기준

- `templates/agents-fragment.template.md`의 필수 section을 유지한다.
- 규칙이 해당 분류 선택 때문에 달라지는 판단인지 확인하고 다른 fragment의 책임을 반복하지 않는다.
- Data ownership, contract와 dependency direction 사이의 충돌을 profile 조합 시 검토한다.
- 실제 제품·framework·language 이름은 bridge 예시나 분리 경계를 설명하는 수준으로 제한한다.
- Project의 요구사항, 지원 버전과 검증 환경이 없으면 제품별 동작을 확정하지 않는다.

## 현재 범위

현재 문서는 RDB, NoSQL, RESTful API와 5개 architecture fragment 초안의 책임만 정의한다. 실제 bridge, product-specific fragment, skill, profile YAML, registry catalog, generator와 실행 구현은 아직 만들지 않는다.
