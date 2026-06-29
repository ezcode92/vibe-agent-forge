# DRY-RUN PREVIEW: Python CLI Automation 작업 지침

> **Preview example — 실제 `AGENTS.md`가 아닙니다.** `python-cli-automation` profile과 Codex adapter의 수동 조합 검증용 문서이며 그대로 복사·적용·export하지 않습니다.

## Project Overview (프로젝트 개요)

이 preview는 Python 기반 CLI 및 automation 프로젝트를 전제로 한다. 실제 목적, 사용자, command 구조, package 경계와 실행 환경은 입력되지 않았으므로 적용 전에 project metadata로 확정해야 한다.

## Tech Stack (기술 스택)

- Language: Python
- Framework/Platform: `<확인된 CLI framework 또는 해당 없음>`
- Database/API/Architecture: CLI Automation Architecture
- Variant: 없음
- Package manager: `<실제 프로젝트에서 확인 필요>`
- Adapter target: Codex project instructions preview

## Included Fragments (포함 Fragment)

- Base: `core/global/agents.fragment.md`, `core/project/agents.fragment.md`
- Quality: `core/quality/agents.fragment.md`
- Language: `stacks/language/python/agents.fragment.md`
- Architecture: `stacks/architecture/cli-automation/agents.fragment.md`
- Bridge: 없음

Fragment 전문은 포함하지 않는다. 아래에는 profile 조합에서 상시 필요한 판단만 요약한다.

## Included Skills (포함 Skill)

### 기본 작업 Gate

- `incremental-implementation`: 복합 변경을 검증 가능한 단계로 나눈다.
- `test-first`: 동작 변경 전에 기대 결과와 실패 조건을 정한다.
- `security-review`: 외부 입력, 경로, command, secret과 권한 경계를 검토한다.
- `commit-worklog`: Git-auto 저장소에서는 직접 commit·push하지 않고 변경·검증 결과를 정리한다.
- `test-scope-selection`: 변경 책임에 맞는 test 범위를 선택한다.

### 필요 시 참조

- Common: `debugging`, `code-review`, `refactoring`
- Automation: `git-auto-workflow`

Skill 본문은 inline하지 않는다. 현재 작업의 trigger가 맞을 때 해당 `SKILL.md`만 참조한다.

## Working Rules (작업 규칙)

### 공통 작업

- 현재 요청과 project 지침을 먼저 확인하고 관련 context만 좁혀 읽는다.
- 기존 구조와 사용자 변경을 보존하며 필요한 최소 변경만 수행한다.
- 외부 입력, shell command, file path와 credential을 신뢰 경계로 취급한다.
- 관련성이 높은 좁은 검증부터 수행하고 미실행 사유를 명시한다.

### Python

- Public 함수와 경계 객체에는 runtime 동작과 일치하는 type hint를 사용한다.
- 숨은 전역 상태와 import 부작용을 피하고 module의 공개 책임을 좁게 유지한다.
- Path는 `pathlib.Path`로 표현하고 외부 입력 경로의 기준 위치와 허용 범위를 검증한다.
- 구체적인 exception만 처리하고 원인 chain을 보존하며 실패를 빈 값으로 숨기지 않는다.
- 핵심 판단은 I/O, 환경 변수, 시간과 외부 service에서 분리해 결정적으로 검증 가능하게 한다.

### CLI 및 Automation 경계

- CLI framework, command 선언 방식과 package manager는 실제 project 설정을 확인하기 전 확정하지 않는다.
- Command entrypoint는 입력 변환과 결과 전달을 조정하고 domain/service 판단과 side effect를 직접 소유하지 않게 한다.
- Configuration, input/output, filesystem, network와 process 실행의 경계를 명시한다.
- One-shot, batch와 workflow의 성공·부분 실패·중단·재개 의미를 구분하고 idempotency와 retry 조건을 정한다.
- Diagnostic logging, user-facing output, machine-readable 결과와 exit status의 계약을 구분한다.
- 작은 CLI에는 변화 축이 확인되지 않은 layer, interface와 범용 workflow abstraction을 추가하지 않는다.

## Validation Commands (검증 명령)

- Build/Package: `<실제 프로젝트 package 또는 build 명령 확인 필요>`
- Test: `<실제 프로젝트 test 명령 확인 필요>`
- Lint/Format: `<실제 프로젝트 lint·format 명령 확인 필요>`
- Type Check: `<실제 프로젝트 type check 명령 또는 해당 없음>`

명령과 도구를 확인하지 않은 상태에서는 검증 성공으로 보고하지 않는다.

## Done Definition (완료 기준)

- 요청 결과가 확인된 CLI/automation 책임과 허용 범위를 충족한다.
- Python type, exception, path와 resource 경계가 유지된다.
- 적용 가능한 검증이 통과하거나 미실행 사유와 대체 확인이 기록된다.
- CLI automation architecture 경계와 미확정 framework/package manager가 구분된다.
- 남은 위험과 실제 project에서 확인할 항목을 보고한다.

## Scope Boundary (범위 경계)

- Allowed: `<실제 프로젝트가 허용한 변경 범위>`
- Excluded: 확정되지 않은 CLI framework·package manager 규칙과 요청 밖 기능
- Pending: Profile 기준 없음; 실제 command, package와 실행 환경은 project metadata 확인 필요
- Automation: Git-auto Stop hook을 사용하는 저장소에서는 직접 commit·push하지 않고 `.gitauto/`를 staging하지 않는다. `git-auto-workflow`은 hook 운영 또는 pending publish 복구 작업에서만 참조한다.
- Preview limitation: 이 문서는 dry-run example이며 실제 project metadata와 validation command가 확정되지 않았다.
