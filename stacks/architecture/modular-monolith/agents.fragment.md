# Modular Monolith Architecture Fragment

## 목적

하나의 배포 단위를 유지하면서 기능 module의 공개 계약, 의존 방향과 데이터 소유권을 강제하는 원칙을 정의한다. 특정 framework의 module 기능과 저장 제품은 다루지 않는다.

## 적용 대상

- Stack 식별자: `architecture-modular-monolith`
- 적용 조건: 단일 배포의 운영 단순성과 강한 내부 module 경계가 모두 필요한 시스템
- 제외 조건: Module별 독립 배포와 장애 격리가 필수인 구조

## 핵심 규칙

- Module boundary는 business capability와 변경 책임을 기준으로 정하고 각 module의 공개 API와 내부 구현을 구분한다.
- Dependency direction은 명시적이고 비순환이어야 하며 module 내부 type이나 저장 구조를 우회 참조하지 않는다.
- Data는 module이 소유하고 다른 module은 공개 operation 또는 합의된 event를 통해 변경을 요청한다.
- Cross-module transaction은 일관성 요구를 근거로 제한하고 module 결합 비용을 함께 검토한다.
- Test는 module 내부 규칙, 공개 계약과 module 간 조합을 서로 다른 범위로 검증한다.

## 권장 패턴

- Module 공개 surface를 작게 유지하고 소비자가 내부 package에 접근할 수 없도록 경계를 검증한다.
- Shared kernel은 의미와 변경 주기가 실제로 동일한 최소 요소로 제한한다.
- Module 간 동기 호출과 event는 일관성, 순서 및 실패 요구에 따라 선택하고 의미를 문서화한다.

## 금지 패턴

- 디렉터리만 나누고 내부 type, table 또는 service에 자유롭게 접근하는 명목상 module을 만들지 않는다.
- Common module을 우회 의존 통로 또는 모든 domain model의 저장소로 사용하지 않는다.
- 양방향 module 의존이나 순환 event 흐름을 허용하지 않는다.
- 독립 배포되지 않는 module에 분산 시스템 복잡성을 근거 없이 도입하지 않는다.

## 검증 기준

- Module별 책임, 공개 API, 허용 의존과 금지 접근이 식별된다.
- Data 소유자와 module 간 변경·조회 경로가 명확하다.
- Dependency graph가 비순환이며 shared 요소가 최소다.
- Module 단위 test와 module 간 contract/integration test가 경계를 검증한다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Module boundary 또는 dependency review skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Framework의 module/container 경계와 연결하거나 database schema를 module 소유권에 연결할 때 bridge가 필요하다.
- API 또는 event 계약으로 module 간 통신을 구체화할 때 해당 조합 bridge가 필요하다.
