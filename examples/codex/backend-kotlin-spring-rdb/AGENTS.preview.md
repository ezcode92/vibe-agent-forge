# DRY-RUN PREVIEW: Kotlin Spring RDB Backend 작업 지침

> **Preview example — 실제 `AGENTS.md`가 아닙니다.** `backend-kotlin-spring-rdb` profile과 Codex adapter의 수동 조합 검증용 문서이며 그대로 복사·적용·export하지 않습니다.

## Project Overview (프로젝트 개요)

이 preview는 Kotlin, Spring, RDB, RESTful API와 Modular Monolith를 사용하는 가상의 backend 프로젝트를 전제로 한다. 실제 프로젝트 목적, 사용자, directory 구조, version과 운영 제약은 입력되지 않았으므로 적용 전에 project `AGENTS.md`에서 구체화해야 한다.

## Tech Stack (기술 스택)

- Language: Kotlin
- Framework/Platform: Spring
- Database/API/Architecture: RDB, RESTful API, Modular Monolith
- Variant: 없음
- Required bridges: Kotlin–Spring, Spring–RDB, Spring–Modular Monolith
- Adapter target: Codex project instructions preview

## Included Fragments (포함 Fragment)

- Base: `core/global/agents.fragment.md`, `core/project/agents.fragment.md`
- Quality: `core/quality/agents.fragment.md`
- Language: `stacks/language/kotlin/agents.fragment.md`
- Framework: `stacks/framework/spring/agents.fragment.md`
- Database/API/Architecture: `stacks/database/rdb/agents.fragment.md`, `stacks/api/restful-api/agents.fragment.md`, `stacks/architecture/modular-monolith/agents.fragment.md`
- Bridge: `stacks/bridge/kotlin-spring/agents.fragment.md`, `stacks/bridge/spring-rdb/agents.fragment.md`, `stacks/bridge/spring-modular-monolith/agents.fragment.md`

Fragment 전문은 반복하지 않는다. 아래 규칙은 profile 조합에서 항상 필요한 판단만 압축한 preview다.

## Included Skills (포함 Skill)

### 기본 작업 Gate

- `incremental-implementation`: 큰 변경을 작은 검증 단위로 나눈다.
- `test-first`: 동작 변경 전에 기대 결과와 실패 조건을 고정한다.
- `security-review`: 입력, 권한, secret과 실행 경계를 검토한다.
- `commit-worklog`: Git-auto 저장소에서 변경·검증 결과를 정리하고 직접 commit·push하지 않는다.
- `test-scope-selection`: 변경 책임에 맞춰 unit/integration/contract 범위를 선택한다.

### 작업 유형별 참조

- Common: `debugging`, `code-review`, `refactoring`
- Backend: `service-layer-implementation`, `repository-query-review`, `transaction-boundary-review`, `restful-api-design`
- Database: `schema-change-review`, `query-performance-review`
- Automation: `git-auto-workflow`

Skill 본문은 상시 포함하지 않는다. 현재 작업의 trigger가 맞을 때 해당 `SKILL.md`만 읽는다.

## Working Rules (작업 규칙)

### 공통 작업

- 사용자 요청과 project 지침을 먼저 확인하고 관련 context만 좁혀 읽는다.
- 기존 구조와 사용자 변경을 보존하며 요청을 충족하는 최소 변경을 선택한다.
- 변경 전 영향 경계와 검증 방법을 확인하고, 관련성이 가장 높은 좁은 검사부터 실행한다.
- Secret, credential과 민감정보를 출력·저장·commit하지 않는다.

### Kotlin–Spring

- Nullability, configuration binding의 필수값·기본값과 bean 생성 계약을 일치시킨다.
- Proxy가 필요한 component는 Kotlin final 특성과 실제 가로채기 조건을 확인한다.
- Coroutine 경계에서 transaction, 취소와 context 전파가 자동 보존된다고 가정하지 않는다.
- Controller, service, domain과 repository 책임을 구분하고 framework 제약의 확산을 제한한다.

### Spring–RDB

- Business operation과 transaction 범위를 일치시키고 외부 호출과 장시간 작업을 분리한다.
- Repository는 persistence operation과 query 경계를 소유하고 service가 저장 세부사항을 직접 다루지 않게 한다.
- Entity/query 변경은 schema constraint, index, migration 순서와 혼합 version 호환성을 함께 검토한다.
- Connection과 streaming resource의 생성·해제 책임을 transaction lifecycle과 맞춘다.

### RESTful API

- URI는 resource 중심으로 설계하고 HTTP method, status와 멱등성 의미를 지킨다.
- Request/response/error 계약에서 필수값, null/부재, validation과 호환성을 명시한다.
- Pagination/filter/sort에는 허용 범위, 기본값, 최대 크기와 안정된 정렬을 둔다.
- 내부 entity, exception과 저장 구조를 외부 계약에 그대로 노출하지 않는다.

### Modular Monolith

- Module은 business capability와 변경 책임을 기준으로 경계를 정하고 공개 API와 내부 구현을 분리한다.
- Module dependency는 비순환이어야 하며 다른 module의 내부 type과 저장 구조를 우회 참조하지 않는다.
- Data owner를 module별로 명시하고 cross-module 접근은 공개 operation 또는 합의된 event를 사용한다.
- Spring bean과 configuration은 소유 module 안에 두고 다른 module은 공개 application API를 통해 협력한다.
- Transaction은 operation과 data를 소유한 module의 application service 경계에 두며 cross-module write를 일반화하지 않는다.
- Application service와 event는 일관성·시점·실패 요구로 선택하고 단일 배포를 MSA처럼 과잉 설계하지 않는다.

## Validation Commands (검증 명령)

- Build: `<실제 프로젝트 build 명령 확인 필요>`
- Test: `<관련 test 명령 확인 필요>`
- Lint/Format: `<Kotlin 및 프로젝트 lint·format 명령 확인 필요>`
- Additional: `<Schema/migration, API contract와 module dependency 검증 명령 확인 필요>`

명령을 확인하지 않은 상태에서는 검증 성공으로 보고하지 않는다.

## Done Definition (완료 기준)

- 요청 결과가 project 목표와 module 책임 안에서 충족된다.
- Kotlin–Spring, transaction, RDB 및 API 계약 경계가 의도대로 유지된다.
- 적용 가능한 build, test, lint와 추가 검증이 통과하거나 미실행 사유가 기록된다.
- 공개 계약, schema 또는 migration 변경 시 관련 문서와 호환성 검토가 함께 갱신된다.
- 남은 warning, pending과 실제 프로젝트에서 확인할 항목을 최종 결과에 보고한다.

## Scope Boundary (범위 경계)

- Allowed: `<실제 프로젝트가 허용한 변경 범위>`
- Excluded: 확인되지 않은 framework/database 제품 규칙, 무관한 리팩터링과 요청 밖 기능
- Pending: 대상 profile의 필수 fragment·bridge 기준 없음
- Automation: Repository가 git-auto Stop hook을 사용하면 직접 commit·push하지 않고 `.gitauto/`를 staging하지 않는다. 기존 `.codex/hooks`는 명시 요청 없이 수정하지 않는다.
- Preview limitation: 이 문서는 dry-run example이며 실제 project metadata와 검증 명령이 확정되지 않았다.
