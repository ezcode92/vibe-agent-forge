# PARTIAL DRY-RUN PREVIEW: Spring React Fullstack 작업 지침

> **진단용 preview example — 실제 `AGENTS.md`가 아닙니다.** Backend language 선택이 필요해 완성 preview는 `blocked` 상태이며, 이 문서를 그대로 복사·적용·export하지 않습니다.

## Project Overview (프로젝트 개요)

이 partial preview는 Spring backend, JavaScript React frontend, RDB, RESTful API와 Modular Monolith를 사용하는 가상의 fullstack 프로젝트를 전제로 한다. Backend language와 실제 project metadata가 입력되지 않아 최종 instruction으로 사용할 수 없다.

## Tech Stack (기술 스택)

- Backend: Spring, RDB, Modular Monolith
- Backend language: `selection-required` — Java 또는 Kotlin 중 정확히 하나
- Frontend: JavaScript, React
- API: RESTful API, React–Spring contract
- Required common bridges: Spring–RDB, Spring–Modular Monolith, JavaScript–React, React–Spring API
- Required language bridge: Java–Spring 또는 Kotlin–Spring 중 선택 language와 대응하는 하나
- Build tool/Package manager/State library/DB product: `<실제 프로젝트에서 확인 필요>`
- Adapter target: Codex project instructions partial preview

## Included Fragments (포함 Fragment)

- Base: `core/global/agents.fragment.md`, `core/project/agents.fragment.md`
- Quality: `core/quality/agents.fragment.md`
- Backend: `stacks/framework/spring/agents.fragment.md`, `stacks/database/rdb/agents.fragment.md`, `stacks/architecture/modular-monolith/agents.fragment.md`
- Frontend/API: `stacks/language/javascript/agents.fragment.md`, `stacks/frontend/react/agents.fragment.md`, `stacks/api/restful-api/agents.fragment.md`
- Common bridges: `stacks/bridge/spring-rdb/agents.fragment.md`, `stacks/bridge/spring-modular-monolith/agents.fragment.md`, `stacks/bridge/javascript-react/agents.fragment.md`, `stacks/bridge/react-spring-api/agents.fragment.md`
- Java option: `stacks/language/java/agents.fragment.md` + `stacks/bridge/java-spring/agents.fragment.md`
- Kotlin option: `stacks/language/kotlin/agents.fragment.md` + `stacks/bridge/kotlin-spring/agents.fragment.md`

필수 공통 fragment는 13개다. 최종 resolved 집합은 language option 하나의 fragment·bridge 2개를 더한 15개이며 두 option을 동시에 포함하지 않는다. Fragment 전문은 inline하지 않는다.

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

### Backend와 Module

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

### Backend Language Selection

- Java/Kotlin을 관례나 기본값으로 선택하지 않는다.
- Java 선택 시 Java + Java–Spring, Kotlin 선택 시 Kotlin + Kotlin–Spring을 원자적으로 적용한다.
- 선택 전에는 language-specific null, exception, proxy와 coroutine 규칙을 완성 instruction으로 표현하지 않는다.

## Validation Commands (검증 명령)

- Backend Build/Test: `<실제 backend build 및 test 명령 확인 필요>`
- Frontend Build/Test: `<실제 frontend build 및 test 명령 확인 필요>`
- Lint/Format: `<실제 backend/frontend lint·format 명령 확인 필요>`
- Contract/Integration: `<실제 API contract 및 fullstack integration 검증 명령 확인 필요>`
- Database/Module: `<실제 migration 및 module dependency 검증 명령 확인 필요>`

명령과 도구를 확인하지 않은 상태에서는 검증 성공으로 보고하지 않는다.

## Done Definition (완료 기준)

- Backend language option과 대응 Spring bridge가 정확히 하나 선택된다.
- Spring module·transaction·RDB 책임, React UI/API client 책임과 REST 계약 경계가 유지된다.
- Client/server contract의 정상·validation·인증·목록·호환성 결과가 함께 검증된다.
- 적용 가능한 build, test, lint, contract와 migration 검증이 통과하거나 미실행 사유가 기록된다.
- 미확정 tool, library, DB 제품과 project metadata를 실제 값처럼 표현하지 않는다.

## Scope Boundary (범위 경계)

- Allowed: `<실제 프로젝트가 허용한 backend/frontend/contract 변경 범위>`
- Excluded: Java와 Kotlin 동시 선택, 확인되지 않은 build tool·package manager·state library·DB 제품 규칙
- Pending: `backend_language`가 `selection-required`; 선택 전 완성 preview와 export 차단
- Automation: Git-auto Stop hook을 사용하면 직접 commit·push하지 않고 `.gitauto/`를 staging하지 않는다. 기존 `.codex/hooks`는 명시 요청 없이 수정하지 않는다.
- Preview limitation: 이 문서는 공통 규칙과 두 variant 후보를 보여 주는 partial dry-run example이며 실제 project instruction이 아니다.
