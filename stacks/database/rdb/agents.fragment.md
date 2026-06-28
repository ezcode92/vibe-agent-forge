# RDB Fragment

## 목적

관계형 데이터의 schema, transaction, index, migration, query 경계와 무결성에 공통으로 적용할 원칙을 정의한다. 특정 database 제품, ORM, framework와 언어의 구현 방식은 다루지 않는다.

## 적용 대상

- Stack 식별자: `database-rdb`
- 적용 조건: 관계 모델과 transaction을 사용하는 영속 데이터 저장소
- 제외 조건: 제품별 SQL 문법, driver 설정과 framework persistence lifecycle

## 핵심 규칙

- Schema는 domain의 식별자, 관계, cardinality와 필수 여부를 명시하고 중복 데이터에는 동기화 책임을 둔다.
- Data integrity는 application 검증만 믿지 않고 가능한 범위에서 key, uniqueness, reference와 값 제약으로 보호한다.
- Transaction은 하나의 일관된 변경 단위를 기준으로 최소 범위에 적용하고 실패 시 원자성 및 재시도 영향을 정의한다.
- Index는 실제 query의 filter, join, sort와 cardinality를 근거로 선택하며 쓰기·저장 비용을 함께 검토한다.
- Migration은 순서, 이전 버전과의 호환 구간, 실패 복구와 대용량 데이터 영향을 포함한 배포 가능한 변경 단위로 설계한다.
- Query 책임은 데이터를 소유한 경계에 두고 호출자가 저장 구조와 join 세부사항에 결합되지 않게 한다.

## 권장 패턴

- 정규화를 기본으로 하되 측정된 조회 요구 때문에 비정규화하면 원본과 갱신 책임을 기록한다.
- 읽기와 쓰기 경로를 함께 검토하고 실행 계획 및 대표 데이터 규모로 query 비용을 확인한다.
- 호환성이 필요한 schema 변경은 추가, 전환, 제거 단계로 나누고 각 단계의 완료 조건을 둔다.
- Transaction 밖의 외부 작업은 중복 실행과 부분 실패를 견딜 수 있는 별도 경계로 분리한다.

## 금지 패턴

- 모든 무결성을 application 코드에만 두거나 제약 없이 nullable column을 기본값으로 사용하지 않는다.
- 근거 없이 모든 column에 index를 추가하거나 운영 query 확인 없이 index를 제거하지 않는다.
- 파괴적 migration과 application 전환을 복구 계획 없이 한 단계로 수행하지 않는다.
- 화면이나 transport 요구에 맞춘 임시 query가 저장소 경계를 우회해 확산되게 하지 않는다.
- 긴 transaction 안에 사용자 대기, network 호출 또는 대량 연산을 포함하지 않는다.

## 검증 기준

- Schema의 관계, 필수값, key와 data integrity 제약이 domain 규칙과 일치한다.
- Transaction 범위, 격리 요구, 실패와 재시도 결과가 설명된다.
- Index마다 대상 query와 비용 근거가 있고 실행 계획 또는 동등한 방법으로 검토된다.
- Migration의 forward·rollback 또는 roll-forward 전략과 호환 구간이 명시된다.
- Query가 소유 경계를 지키고 대표 데이터에서 기능·성능 검증이 가능하다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: RDB migration 또는 query 검토 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Framework transaction lifecycle이나 ORM mapping을 RDB 규칙과 연결할 때 framework–RDB bridge가 필요하다.
- 분산 architecture의 데이터 소유권과 transaction 범위를 연결할 때 architecture–RDB bridge가 필요하다.
