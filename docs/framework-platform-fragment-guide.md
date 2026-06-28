# Framework 및 Platform Fragment 가이드

## 목적

Framework/platform fragment는 선택한 실행 환경이 추가하는 component, lifecycle, 상태, 설정과 test 경계를 정의한다. 기반 language의 관례를 반복하지 않고 framework/platform을 선택했기 때문에 달라지는 규칙만 제공한다.

각 fragment는 database 제품, API protocol과 architecture 형태를 기본값으로 가정하지 않는다. 다른 stack과 함께 사용할 때만 필요한 규칙은 독립 fragment를 오염시키지 않고 bridge로 분리한다.

## Language Fragment와의 분리

Language fragment는 타입, module, 오류와 표준 비동기 표현처럼 실행 환경과 무관한 규칙을 소유한다. Framework/platform fragment는 container, component/widget lifecycle, state, rendering과 framework test context를 소유한다.

예를 들어 언어의 nullability나 비동기 기능 자체는 language 책임이고, 해당 기능이 component lifecycle이나 framework proxy와 만나는 방식은 bridge 책임이다. 이렇게 분리하면 같은 framework가 지원하는 여러 language 조합과 같은 language가 사용되는 다른 환경을 독립적으로 변경할 수 있다.

## Database, API 및 Architecture Fragment와의 경계

- Database fragment는 데이터 모델, consistency, constraint, index, migration과 query 검증을 책임진다. Framework fragment는 특정 저장 기술이나 ORM을 기본 전제로 삼지 않는다.
- API fragment는 resource, method, status, request·response·error와 versioning 계약을 책임진다. Framework/platform fragment는 controller 또는 client 경계까지만 정의하고 protocol 계약을 재정의하지 않는다.
- Architecture fragment는 module, layer, service, port·adapter와 배포 단위의 의존 방향을 책임진다. Framework/platform fragment의 component 구분은 선택된 architecture를 암묵적으로 확정하지 않는다.

Framework의 transaction, UI의 API client처럼 다른 영역과 접점이 있는 규칙은 해당 framework 내부 경계까지만 설명한다. Persistence semantics, wire contract와 전체 dependency 방향까지 결정해야 하면 bridge를 사용한다.

## Bridge Fragment가 필요한 경우

| Bridge 예시 | 연결 책임의 예시 |
| --- | --- |
| `java-spring` | Java type·exception 계약과 Spring bean·proxy lifecycle 연결 |
| `kotlin-spring` | Kotlin nullability·coroutine과 Spring component·transaction lifecycle 연결 |
| `javascript-react` | JavaScript module·async·immutable update와 React rendering·effect 경계 연결 |
| `dart-flutter` | Dart Future·Stream·model과 Flutter widget·state lifecycle 연결 |
| `spring-rdb` | Spring transaction 경계와 RDB transaction·persistence 규칙 연결 |
| `react-spring-api` | React API client와 Spring 기반 backend의 request·response·error 계약 연결 |
| `flutter-rest-api` | Flutter API client 상태와 REST request·response·error 계약 연결 |

위 표는 조합 책임의 예시이며 실제 bridge fragment의 세부 규칙이 아니다. 각 bridge는 관련 항목이 모두 선택된 경우에만 적용하며 한쪽 fragment에 그 내용을 복제하지 않는다.

## Framework 및 Platform Fragment에 넣지 않는 내용

- 기반 language의 null 처리, collection, module, exception 문법과 비동기 기능 자체의 사용법
- Database schema, ORM mapping, index, migration, query와 제품별 transaction semantics
- HTTP resource, method, status, pagination, versioning과 wire-level error schema
- Monolith, MSA, clean/hexagonal 등 전체 architecture 선택과 module dependency 정책
- 특정 build tool, package manager, plugin과 dependency 설치 절차
- 둘 이상의 stack 조합에서만 성립하는 annotation, type mapping, serialization과 lifecycle 연결 규칙
- 조건부 debugging, migration과 성능 분석의 긴 작업 절차

구체적인 프로젝트 설정과 명령은 project 지침에, 전문 workflow는 skill에 둔다. Fragment에는 framework/platform 선택 시 항상 필요한 짧고 검증 가능한 규칙만 유지한다.

## 작성 및 검증 기준

- `templates/agents-fragment.template.md`의 필수 section을 유지한다.
- 각 규칙이 framework/platform 선택으로 인해 추가되는 책임인지 확인한다.
- Language, database, API와 architecture fragment의 규칙을 반복하거나 선점하지 않는다.
- 조합 없이는 판단할 수 없는 규칙은 bridge 필요 조건으로 이동한다.
- Project가 선언한 framework/platform 버전, test와 build 설정을 근거로 검증한다.

## 현재 범위

현재 문서는 Spring, React와 Flutter fragment 초안의 책임만 정의한다. 실제 bridge, database/API/architecture fragment, skill, profile YAML, registry catalog, generator와 adapter 구현은 아직 만들지 않는다.
