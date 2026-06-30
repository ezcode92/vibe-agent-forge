# MVP Acceptance Criteria

## 목적

Phase 11 read-only MVP의 완료 조건을 검증 가능한 결과로 정의한다. 모든 기준은 Codex-only, no-write와 deterministic report 계약을 전제로 한다.

## Source Load와 구조

- Registry YAML 5개를 load·parse하고 version, root type과 필수 field를 검증한다.
- Profile YAML 6개를 load·parse하고 catalog ID/path 및 count를 대조한다.
- Codex adapter가 `mvp-contract`이고 contract/template path가 존재함을 확인한다.
- Claude/Gemini 선택은 unsupported target error로 보고한다.

## 선택 조합 검증

- Selected profile과 `adapterId: codex`를 resolved context로 만들 수 있다.
- 존재하지 않는 profile/adapter/fragment/skill과 missing path는 error/blocked다.
- Fragment/skill dependency와 conflict를 검증한다.
- Fullstack Java/Kotlin exactly-one variant 미선택·복수 선택은 error/blocked다.
- Required bridge 누락은 error/blocked다.
- Selected pending/unregistered compatibility는 error/blocked다.
- Unselected `spring-msa`, `restful-api-msa`는 ignored이며 실행을 차단하지 않는다.

## Readiness와 Report

- Dry-run coverage가 정확히 일치하면 `reviewed-for-mvp` info를 기록한다.
- Coverage가 없는 유효 draft 조합은 `ready-candidate` warning을 기록한다.
- Error/warning/info, check status, source, pipeline stage와 `not-run`을 가진 canonical machine-readable logical report를 반환한다.
- Machine-readable report를 source of truth로 삼고 사람이 읽는 Markdown report는 같은 결과에서 파생한다.
- `ready`, `ready-with-warnings`, `blocked` 판정이 lifecycle 정책과 일치한다.
- 동일 입력과 catalog version은 가변 metadata를 제외하고 동일 결과를 만든다.

## Output Planning과 Size

- Codex preview context와 artifact 목록을 filesystem write 없이 계획할 수 있다.
- `docs/output-size-budget.md`의 line, heading과 estimated token threshold를 평가해 info/warning/error를 보고한다.
- `export-plan`은 예정 target과 보호 상태만 반환하고 `writePerformed: false`를 유지한다.
- 초기 MVP는 preview/report/export-plan file을 materialize하지 않고 논리 content와 계획만 반환한다.

## 보호와 Side Effect

- Root `AGENTS.md`, `.codex/hooks`, `.codex/hooks.json`, `.gitauto/`, registry/profile/template/fragment/skill/example을 수정하지 않는다.
- Target project file, Git state, secret과 local config를 읽거나 쓰지 않는다.
- File creation, overwrite, backup, installer, commit, push와 network publish를 수행하지 않는다.
- 실제 root `AGENTS.md` write는 acceptance criteria와 MVP 범위에 포함하지 않는다.

## Test Scenario 최소 집합

- 정상 registry/profile load
- Unknown selected profile
- Missing selected source path
- Fullstack variant 미선택과 복수 선택
- Required bridge 누락
- Selected pending compatibility
- Unselected pending compatibility
- Codex 외 adapter 선택
- Output 목표 budget 초과와 error threshold 초과
- Protected-file write invariant 위반 감지

## 완료 판정

모든 정상 scenario가 기대 결과를 만들고 error scenario가 silent fallback 없이 blocked가 되며, repository와 target filesystem에 write가 없을 때 Phase 11 read-only MVP를 완료로 판정한다. Markdown materialization, CLI와 실제 export는 완료 조건이 아니다.
