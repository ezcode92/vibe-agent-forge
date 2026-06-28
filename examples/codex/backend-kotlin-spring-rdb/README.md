# Backend Kotlin Spring RDB Codex Dry-run

> 이 디렉터리는 수동 dry-run을 위한 preview example입니다. 실제 Codex 설정이 아니며 repository root `AGENTS.md`, 전역 `~/.codex/AGENTS.md`와 `.codex/hooks.json`을 생성하거나 변경하지 않습니다.

## 목적

Generator 구현 없이 `backend-kotlin-spring-rdb` profile의 fragment·skill 구성이 Codex project `AGENTS.md` preview 구조로 조합 가능한지 검증한다. Path, dependency, compatibility, merge order, adapter template과 output warning을 사람이 추적할 수 있는지 확인한다.

## Dry-run 대상

- Profile: `profiles/backend-kotlin-spring-rdb/profile.yml`
- Profile ID: `backend-kotlin-spring-rdb`
- Adapter: `adapters/codex/adapter.md`
- Adapter ID: `codex`
- Template: `templates/codex/AGENTS.md.template`
- Preview 상태: `ready-with-warnings`

## 주요 Source

- Registry: `registry/fragments.yml`, `registry/skills.yml`, `registry/profiles.yml`, `registry/adapters.yml`, `registry/compatibility-matrix.yml`
- Merge/selection: `docs/fragment-merge-strategy.md`, `docs/merge-policy.md`, `docs/skill-selection-strategy.md`
- Validation/output: `docs/generator-validation-report.md`, `docs/generator-output-contract.md`
- Fragment: Profile이 참조하는 core 3개, stack 5개, bridge 2개
- Skill: Profile이 참조하는 common 7개, backend 4개, database 2개, testing 1개, automation 1개

전체 fragment와 skill path는 `merge-trace.md`와 `skill-selection.md`에서 추적한다.

## 산출물

| 파일 | 역할 |
| --- | --- |
| `AGENTS.preview.md` | Codex project 지침의 압축된 preview example |
| `merge-trace.md` | Fragment 선택, 표시 순서, authority priority와 중복·충돌 기록 |
| `skill-selection.md` | Profile skill 15개의 역할과 lazy loading 구분 |
| `validation-report.md` | 수동 check, severity, warning과 preview readiness |

## 실제 Export가 아닌 이유

- Project name, 실제 build/test/lint 명령과 repository architecture 세부값이 입력되지 않았다.
- Codex adapter와 template은 설계 초안이며 generator가 없다.
- Compatibility matrix에 Spring–Modular Monolith 관계가 pending이다.
- Output size budget이 정량화되지 않았다.
- Existing project 파일과의 diff, backup, overwrite 검토를 수행하지 않았다.

따라서 `AGENTS.preview.md`는 copy·install·export 대상이 아니라 설계 검증 예시다.

## 실제 프로젝트 적용 전 검토 항목

- 프로젝트 목적, module 경계, 실제 package/directory 책임
- 지원 Kotlin/Spring/JDK 및 build tool 설정
- 실제 RDB 제품, schema, migration과 transaction capability
- REST API consumer, 인증·인가와 versioning 정책
- Build, test, lint, format과 run 명령
- Spring–Modular Monolith bridge 또는 pending 수용 정책
- Output size/token budget
- 기존 `AGENTS.md`, skill, `.codex/hooks.json`의 ownership과 충돌
- Git-auto 사용 시 직접 commit·push 금지 및 `.gitauto/` 제외 정책

## 현재 범위

이 example 작성 과정에서 실제 agent 설정, generator, validator, CLI와 export 기능을 만들지 않았다.
