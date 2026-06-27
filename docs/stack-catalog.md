# Stack Catalog 설계

## 목적

Stack catalog는 AgentForge가 조합할 수 있는 기술 요소를 책임 단위별로 분류한다. 각 항목은 다른 분류의 지침을 복제하지 않고 자신의 선택으로 인해 달라지는 규칙만 제공한다.

## 분류와 책임 범위

### Language

| 항목 | 책임 범위 |
| --- | --- |
| Java | 패키지·타입 설계, 예외 처리, 빌드 생태계와 Java 관용구 |
| Kotlin | null safety, data class·sealed type, coroutine 등 Kotlin 관용구와 Java 상호운용 경계 |
| Python | module·package 구조, typing, 가상환경, Python 관용구와 도구 기준 |
| JavaScript | module 체계, 비동기 처리, 런타임 경계, lint·format·테스트 생태계 기준 |
| Dart | null safety, package 구조, 비동기 처리와 Dart 관용구 |

Language 항목은 특정 프레임워크의 디렉터리나 실행 모델을 전제하지 않는다.

### Framework / Platform

| 항목 | 책임 범위 |
| --- | --- |
| Spring | bean 책임, 계층 경계, 설정·transaction·validation·test 관례 |
| React | component·hook·state 책임, 렌더링과 접근성, frontend test 관례 |
| Flutter | widget·state·navigation 책임, platform 경계와 Flutter test 관례 |

Framework/platform 항목은 기반 language 항목을 참조할 수 있지만 language 공통 규칙을 반복하지 않는다.

### Database

| 항목 | 책임 범위 |
| --- | --- |
| RDB | 관계 모델, transaction, constraint, index, migration과 query 검증 원칙 |
| NoSQL | 데이터 모델과 접근 패턴, consistency·partition·index 선택, 저장소별 제약 확인 원칙 |

Database 항목은 특정 ORM이나 제품을 기본값으로 가정하지 않는다. 제품 또는 library 고유 규칙은 후속 catalog 항목이나 bridge로 분리한다.

### Architecture

| 항목 | 책임 범위 |
| --- | --- |
| monolith | 단일 배포 단위 안의 단순한 모듈 경계와 불필요한 분산 방지 |
| modular-monolith | 단일 배포를 유지하면서 모듈별 공개 경계와 의존 방향 통제 |
| MSA | 서비스 책임, 독립 배포, 데이터 소유권, 통신 실패와 관측 가능성 |
| clean architecture | use case 중심 의존성 방향과 외부 기술 세부사항 격리 |
| hexagonal architecture | port·adapter 경계와 domain의 외부 의존성 차단 |

배포 형태(monolith, modular-monolith, MSA)와 내부 의존성 스타일(clean, hexagonal)은 함께 선택될 수 있다. 조합 시 중복되거나 충돌하는 경계 규칙은 profile 또는 bridge에서 명시한다.

### API

| 항목 | 책임 범위 |
| --- | --- |
| RESTful API | resource 중심 URI, HTTP method·status 의미, request·response·error 계약, pagination·versioning 원칙 |

RESTful API 항목은 전송 계약을 다루며 Spring controller나 React client 구현 방식은 다루지 않는다.

### Quality Principles

| 항목 | 책임 범위 |
| --- | --- |
| SOLID | 변경 이유와 의존성 방향을 기준으로 한 책임 분리 판단 |
| OOP | 캡슐화, 응집도, 결합도, 객체 협력과 불변식 보호 |
| maintainability | 읽기 쉬운 구조, 명시적 책임, 변경 영향 범위 축소 |
| extensibility | 실제 확장 가능성이 있는 경계에 한정한 교체·추가 지점 |
| testability | 격리 가능한 책임, 결정적 동작, 관찰 가능한 결과와 테스트 seam |

Quality principle은 모든 스택에 적용 가능한 판단 기준이다. 패턴이나 abstraction을 의무화하지 않으며 언어·프레임워크의 관용적 방식보다 형식적으로 우선하지 않는다.

## 조합 기준

- profile은 최소 하나의 language 또는 platform을 선택하고 필요한 framework, database, architecture, API, quality 항목을 추가한다.
- 동일 분류에서 양립할 수 없는 항목은 profile이 선택 근거를 명시해야 한다.
- 둘 이상의 항목 사이에만 필요한 규칙은 어느 한 catalog 항목에 넣지 않고 bridge fragment로 관리한다.
- catalog 등록은 지원 의도를 뜻하며 실제 fragment나 skill 구현 완료를 뜻하지 않는다.
