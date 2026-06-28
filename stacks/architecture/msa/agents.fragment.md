# MSA Fragment

## 목적

독립 배포 service의 책임, 통신 실패, 데이터 소유권과 운영 독립성을 다루는 분산 architecture 원칙을 정의한다. 특정 protocol, framework, database와 infrastructure 제품은 다루지 않는다.

## 적용 대상

- Stack 식별자: `architecture-msa`
- 적용 조건: 독립 배포, 확장, 팀 소유권 또는 장애 격리가 복잡성 비용보다 중요한 시스템
- 제외 조건: 단일 배포로 요구를 충족하며 독립 운영 필요성이 확인되지 않은 시스템

## 핵심 규칙

- Service boundary는 business capability와 독립 변경·배포 책임을 기준으로 정하고 기술 계층만으로 분리하지 않는다.
- Service 간 dependency는 명시적 계약을 통해서만 형성하고 순환 동기 호출과 연쇄 가용성 의존을 제한한다.
- 각 service는 자신의 data를 소유하며 다른 service가 저장소를 직접 읽거나 쓰지 않게 한다.
- 분산 transaction을 기본으로 가정하지 않고 일관성 시점, 보상, 재시도와 중복 처리 정책을 정의한다.
- Network 지연, timeout, 부분 실패, 중복 message와 순서 변경을 정상 설계 조건으로 취급한다.
- Test는 service 내부, consumer-provider 계약과 대표 장애를 포함한 통합 흐름을 구분한다.

## 권장 패턴

- Service별 소유 팀, 배포 단위, SLO와 관측 가능한 경계를 함께 정의한다.
- 호출 수와 동기 의존 깊이를 제한하고 비동기 통신은 순서·재처리·유실 요구를 명시한다.
- 변경 가능한 계약에는 호환 기간과 consumer migration 절차를 둔다.
- End-to-end test는 핵심 흐름으로 제한하고 대부분의 실패를 service 및 contract 수준에서 검증한다.

## 금지 패턴

- 배포·소유권 요구 없이 작은 code 단위마다 service를 만들지 않는다.
- Shared database, 공통 domain model package 또는 직접 table 접근으로 service 경계를 우회하지 않는다.
- Timeout, retry와 idempotency를 고려하지 않은 원격 호출을 추가하지 않는다.
- 모든 검증을 느리고 불안정한 end-to-end 환경에 의존하지 않는다.
- 중앙 shared service가 모든 domain 판단을 소유하게 하지 않는다.

## 검증 기준

- Service별 capability, 소유 팀, 독립 배포 이유와 공개 계약이 명확하다.
- Dependency graph, 장애 전파와 동기 호출 깊이가 검토된다.
- Data ownership, consistency, 중복 처리와 보상 정책이 use case별로 정의된다.
- Service test, contract test와 제한된 통합 test가 실패 경계를 검증한다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Service boundary, contract 또는 resilience review skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- RESTful API를 service 계약으로 채택하거나 특정 database를 service 소유권에 연결할 때 architecture bridge가 필요하다.
- Framework lifecycle과 통신·관측 정책을 연결할 때 framework–MSA bridge가 필요하다.
