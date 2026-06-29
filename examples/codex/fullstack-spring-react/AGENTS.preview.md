# DRY-RUN PREVIEW: Kotlin Spring React Fullstack 작업 지침

> **Preview example — 실제 `AGENTS.md`가 아닙니다.** `fullstack-spring-react` profile의 Kotlin variant와 Codex adapter를 수동 조합한 문서이며 그대로 복사·적용·export하지 않습니다.

## Project Overview (프로젝트 개요)

이 preview는 Kotlin Spring backend, JavaScript React frontend, RDB, RESTful API와 Modular Monolith를 사용하는 가상의 fullstack 프로젝트를 전제로 한다. 실제 project 목적, 구조, version과 운영 제약은 입력되지 않았다.

## Tech Stack (기술 스택)

- Backend: Kotlin, Spring, RDB, Modular Monolith
- Backend language variant: `kotlin` 선택됨
- Frontend: JavaScript, React
- API: RESTful API, React–Spring contract
- Required common bridges: Spring–RDB, Spring–Modular Monolith, JavaScript–React, React–Spring API
- Required language bridge: Kotlin–Spring
- Build tool/Package manager/State library/DB product: `<실제 프로젝트에서 확인 필요>`
- Adapter target: Codex project instructions preview

## Included Fragments (포함 Fragment)

- Base: `core/global/agents.fragment.md`, `core/project/agents.fragment.md`
- Quality: `core/quality/agents.fragment.md`
- Backend: `stacks/language/kotlin/agents.fragment.md`, `stacks/framework/spring/agents.fragment.md`, `stacks/database/rdb/agents.fragment.md`, `stacks/architecture/modular-monolith/agents.fragment.md`
- Frontend/API: `stacks/language/javascript/agents.fragment.md`, `stacks/frontend/react/agents.fragment.md`, `stacks/api/restful-api/agents.fragment.md`
- Bridge: `stacks/bridge/kotlin-spring/agents.fragment.md`, `stacks/bridge/spring-rdb/agents.fragment.md`, `stacks/bridge/spring-modular-monolith/agents.fragment.md`, `stacks/bridge/javascript-react/agents.fragment.md`, `stacks/bridge/react-spring-api/agents.fragment.md`

Resolved fragment는 공통 13개와 Kotlin option 2개를 합한 15개다. Java option은 이번 preview에 포함하지 않으며 fragment 전문도 inline하지 않는다.

## Included Skills (포함 Skill)

### 기본 작업 Gate

- `incremental-implementation`, `test-first`: Backend, frontend와 contract 변경을 작은 검증 단위로 나눈다.
- `api-design-review`, `security-review`: 양쪽 API 의미, 인증·인가와 민감정보 경계를 검토한다.
- `commit-worklog`, `test-scope-selection`: Git-auto 종료 정책과 unit/integration/contract/e2e 범위를 정한다.

### 필요 시 참조

- Common: `debugging`, `code-review`, `refactoring`
- Backend: `service-layer-implementation`, `repository-query-review`, `transaction-boundary-review`, `restful-api-design`
- Database: `schema-change-review`, `query-performance-review`
- Frontend: `component-design`, `state-management-review`, `api-client-integration`, `ui-error-handling`
- Automation: `git-auto-workflow`

Skill 본문은 inline하지 않는다. 현재 변경 책임과 trigger가 일치하는 `SKILL.md`만 lazy load한다.

## Working Rules (작업 규칙)

### Kotlin Backend와 Module

- Kotlin nullability와 Spring binding의 필수값·기본값을 일치시키고 proxy와 coroutine 경계를 명시적으로 검토한다.
- Spring controller는 transport 변환, application service는 use case, repository는 persistence 책임을 소유한다.
- Transaction은 operation과 data를 소유한 module의 application service 경계에 두고 외부 호출을 포함하지 않는다.
- Module 공개 API와 내부 bean·type·table을 구분하고 다른 module의 내부 저장 구조를 우회 참조하지 않는다.
- Schema, migration, index와 query는 실제 RDB 제품을 추정하지 않고 integrity·호환성·비용 기준으로 검토한다.

### Frontend

- Component는 UI 조합과 interaction, API client는 transport·오류 정규화, 별도 model 경계는 데이터 변환을 소유한다.
- Props와 state를 직접 mutate하지 않고 effect dependency, cleanup, cancellation과 stale result를 처리한다.
- Loading, empty, failure와 success를 구분하며 state library는 실제 project 선택 전 확정하지 않는다.

### REST API Contract

- URI, HTTP method, status, request/response/error와 versioning을 client/server가 공유하는 외부 계약으로 관리한다.
- Backend entity, exception과 RDB schema를 response로 직접 노출하지 않는다.
- 인증 실패와 권한 부족, token 갱신, pagination/filter/sort와 CORS의 양쪽 의미를 일치시킨다.
- Contract 변경은 frontend/backend 배포 순서와 호환 구간을 함께 검토한다.

### Backend Language Variant

- 이 preview는 Kotlin fragment와 Kotlin–Spring bridge만 적용한다.
- Java fragment와 Java–Spring bridge를 동시에 포함하지 않는다.
- Java alternative를 검증할 때는 Kotlin 묶음을 제거하고 Java 묶음으로 교체한 별도 dry-run을 수행한다.

## Validation Commands (검증 명령)

- Backend Build/Test: `<실제 backend build 및 test 명령 확인 필요>`
- Frontend Build/Test: `<실제 frontend build 및 test 명령 확인 필요>`
- Lint/Format: `<실제 backend/frontend lint·format 명령 확인 필요>`
- Contract/Integration: `<실제 API contract 및 fullstack integration 검증 명령 확인 필요>`
- Database/Module: `<실제 migration 및 module dependency 검증 명령 확인 필요>`

명령과 도구를 확인하지 않은 상태에서는 검증 성공으로 보고하지 않는다.

## Done Definition (완료 기준)

- Kotlin language fragment와 Kotlin–Spring bridge가 정확히 하나의 variant 묶음으로 적용된다.
- Spring module·transaction·RDB 책임, React UI/API client 책임과 REST 계약 경계가 유지된다.
- Client/server contract의 정상·validation·인증·목록·호환성 결과가 함께 검증된다.
- 적용 가능한 build, test, lint, contract와 migration 검증이 통과하거나 미실행 사유가 기록된다.
- 미확정 tool, library, DB 제품과 project metadata를 실제 값처럼 표현하지 않는다.

## Scope Boundary (범위 경계)

- Allowed: `<실제 프로젝트가 허용한 backend/frontend/contract 변경 범위>`
- Excluded: Java와 Kotlin 동시 선택, 확인되지 않은 build tool·package manager·state library·DB 제품 규칙
- Pending: Profile 기준 없음; 실제 project metadata와 validation command 확인 필요
- Alternative: Java backend는 profile에 남아 있지만 이번 preview에는 포함하지 않으며 별도 variant 선택이 필요
- Automation: Git-auto Stop hook을 사용하면 직접 commit·push하지 않고 `.gitauto/`를 staging하지 않는다. 기존 `.codex/hooks`는 명시 요청 없이 수정하지 않는다.
- Preview limitation: 이 문서는 Kotlin variant 기준 dry-run example이며 실제 project instruction이나 export 결과가 아니다.
