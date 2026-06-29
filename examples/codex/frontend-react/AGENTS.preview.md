# DRY-RUN PREVIEW: JavaScript React Frontend 작업 지침

> **Preview example — 실제 `AGENTS.md`가 아닙니다.** `frontend-react` profile과 Codex adapter의 수동 조합 검증용 문서이며 그대로 복사·적용·export하지 않습니다.

## Project Overview (프로젝트 개요)

이 preview는 JavaScript, React와 RESTful API client를 사용하는 가상의 frontend 프로젝트를 전제로 한다. 실제 사용자, 화면 범위, directory 구조, runtime version과 product 요구사항은 입력되지 않았다.

## Tech Stack (기술 스택)

- Language: JavaScript
- Framework/Platform: React
- Database/API/Architecture: RESTful API client, backend 미지정
- Variant: 없음
- Build tool/Package manager/State library: `<실제 프로젝트에서 확인 필요>`
- Required bridge: JavaScript–React
- Adapter target: Codex project instructions preview

## Included Fragments (포함 Fragment)

- Base: `core/global/agents.fragment.md`, `core/project/agents.fragment.md`
- Quality: `core/quality/agents.fragment.md`
- Language: `stacks/language/javascript/agents.fragment.md`
- Frontend/API: `stacks/frontend/react/agents.fragment.md`, `stacks/api/restful-api/agents.fragment.md`
- Bridge: `stacks/bridge/javascript-react/agents.fragment.md`

Fragment 전문은 포함하지 않는다. 아래에는 상시 필요한 조합 판단만 요약한다.

## Included Skills (포함 Skill)

### 기본 작업 Gate

- `incremental-implementation`: UI 변경을 검증 가능한 단계로 나눈다.
- `test-first`: 상태 전이와 rendering 결과를 변경 전에 정의한다.
- `security-review`: 외부 데이터, session과 민감정보 경계를 검토한다.
- `test-scope-selection`: Utility, component, integration과 e2e 범위를 선택한다.

### 필요 시 참조

- Common: `debugging`, `code-review`, `refactoring`
- Frontend: `component-design`, `state-management-review`, `api-client-integration`, `ui-error-handling`

Skill 본문은 inline하지 않는다. 작업 trigger와 일치하는 `SKILL.md`만 참조한다.

## Working Rules (작업 규칙)

### JavaScript와 React

- Project가 선택한 module 체계를 일관되게 사용하고 import 부작용과 순환 의존을 피한다.
- Props와 state object를 직접 변경하지 않고 명시적인 새 참조와 update 경로를 사용한다.
- Effect는 외부 동기화만 담당하며 dependency, cleanup, cancellation과 stale result를 처리한다.
- Loading, empty, failure와 success 상태를 분리하고 derived data를 중복 state로 저장하지 않는다.
- Component는 UI 조합과 lifecycle을 소유하고 framework 독립 변환·검증은 별도 module 경계에 둔다.

### REST API Client

- API client가 endpoint 호출, transport 변환과 오류 정규화를 담당하고 component가 wire format을 직접 처리하지 않게 한다.
- HTTP method, status, error code, pagination과 versioning 의미를 외부 계약으로 취급한다.
- Network, protocol, validation과 authentication 오류를 UI가 결정 가능한 상태로 구분한다.
- 특정 backend framework나 `react-spring-api` bridge는 실제 server 조합이 선택되기 전 추가하지 않는다.

### Project 선택 경계

- React build tool, package manager와 state library는 기존 설정을 확인한 뒤 따른다.
- Props 전달만을 이유로 global state library를 도입하지 않는다.
- 성능 최적화는 profiler와 재현 가능한 측정 근거가 있을 때만 수행한다.

## Validation Commands (검증 명령)

- Build: `<실제 React project build 명령 확인 필요>`
- Test: `<실제 unit/component/integration test 명령 확인 필요>`
- Lint/Format: `<실제 JavaScript lint·format 명령 확인 필요>`
- Additional: `<API contract 및 접근성 검증 명령 확인 필요>`

명령과 도구를 확인하지 않은 상태에서는 검증 성공으로 보고하지 않는다.

## Done Definition (완료 기준)

- Component 책임, props 계약, state 소유권과 effect lifecycle이 명확하다.
- API client와 UI가 분리되고 정상·loading·empty·failure 상태가 검증 가능하다.
- 적용 가능한 build, test, lint와 추가 검증이 통과하거나 미실행 사유가 기록된다.
- Backend, build tool, package manager와 state library를 근거 없이 확정하지 않는다.
- 남은 위험과 실제 project에서 확인할 항목을 보고한다.

## Scope Boundary (범위 경계)

- Allowed: `<실제 프로젝트가 허용한 frontend 변경 범위>`
- Excluded: 특정 backend framework의 암묵적 선택과 확인되지 않은 tool/library 규칙
- Pending: Backend별 API bridge는 실제 server 조합을 선택할 때 검토
- Automation: Repository가 git-auto Stop hook을 사용하면 직접 commit·push하지 않고 `.gitauto/`를 staging하지 않는다. 기존 `.codex/hooks`는 명시 요청 없이 수정하지 않는다.
- Preview limitation: 이 문서는 dry-run example이며 실제 project metadata와 validation command가 확정되지 않았다.
