# Spring–RDB Bridge Fragment

## 목적

Spring의 transaction·repository lifecycle을 RDB의 무결성, migration과 query 경계에 연결하는 조합 규칙을 정의한다. Spring component 일반 규칙과 관계형 schema 일반 규칙은 반복하지 않는다.

## 적용 대상

- Bridge 식별자: `bridge-spring-rdb`
- 필수 stack: `framework-spring`, `database-rdb`
- 제외 조건: Spring 또는 RDB 중 하나만 선택되거나 persistence가 다른 경계에 있는 구성

## 핵심 규칙

- Spring transaction boundary와 RDB의 원자적 변경 단위를 일치시키고 proxy 호출 경로, rollback 조건과 실제 connection 참여 여부를 확인한다.
- Repository는 aggregate 또는 use case에 필요한 persistence operation을 제공하고 service가 query·mapping 세부사항을 직접 소유하지 않게 한다.
- Entity 또는 query 변경은 schema constraint, index와 migration의 배포 순서를 함께 검토한다.
- Connection, cursor와 streaming result의 소유·종료 시점을 transaction 및 request lifecycle과 일치시킨다.
- Read/write 분리는 consistency, transaction read-your-write, 장애 시 routing과 운영 복잡성의 근거가 있을 때만 도입한다.
- Database 오류는 무결성·경쟁·일시 실패 의미를 보존해 Spring application 경계의 exception 정책으로 변환한다.

## 권장 패턴

- Migration과 application 변경을 호환 가능한 단계로 나누고 이전·새 version이 공존하는 구간을 test한다.
- Repository contract test에서 mapping, constraint와 대표 query를 실제 schema 계약에 대해 검증한다.
- Transaction 안의 query 수, lock 범위와 connection 점유 시간을 관찰 가능한 기준으로 관리한다.
- Read replica를 사용하면 허용 가능한 stale read와 write 후 read 경로를 use case별로 명시한다.

## 금지 패턴

- Spring annotation 존재만으로 self-invocation, async 경계와 모든 repository 호출이 같은 transaction에 참여한다고 가정하지 않는다.
- Entity 변경을 migration 없이 배포하거나 migration을 application compatibility 검토 없이 독립 적용하지 않는다.
- Repository 밖에서 임의 query와 connection을 열어 transaction 및 resource 관리를 우회하지 않는다.
- 성능 추정만으로 read/write 분리를 도입하거나 consistency 차이를 caller에게 숨기지 않는다.

## 검증 기준

- Transaction 호출 경로, connection 참여, commit·rollback과 재시도 결과가 실제 결합 환경에서 확인된다.
- Repository 책임과 query 경계가 service 및 RDB schema 소유권과 일치한다.
- Entity/query/migration 변경의 배포 순서와 혼합 version 호환성이 검증된다.
- Connection과 streaming resource가 성공·실패 경로에서 모두 해제된다.
- Read/write 분리가 있으면 consistency, 장애 전환과 관측 기준이 test된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Spring–RDB transaction, migration 또는 query 진단 skill이 registry에 등록된 이후 해당 조건에서만 참조한다.

## Bridge 필요 조건

- `framework-spring`과 `database-rdb`가 모두 선택되고 Spring이 persistence lifecycle을 관리할 때 적용한다.
- 특정 ORM 또는 RDB 제품 capability가 필요하면 별도 product-specific fragment나 추가 bridge에서 검증한다.
