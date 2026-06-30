# MVP Generator 설계 개요

## 목적

MVP generator는 선택한 profile, project metadata와 adapter target을 검증된 논리 입력으로 해석해 agent 설정 preview와 validation report를 만드는 처리 경계를 정의한다. 실제 파일을 쓰기 전에 어떤 source가 선택되고 어떤 warning과 conflict가 남는지 확인하게 하는 것이 목적이다.

Phase 10-2에서 구현 전 decision gate를 확정했지만 generator는 아직 구현하지 않는다. 이 문서는 입력, 처리 순서와 출력 계약만 정의한다.

## 해결하려는 문제

- Profile manifest가 저장소 path를 참조하고 catalog는 ID를 사용해 수동 대조가 필요하다.
- Fragment dependency, conflict, bridge와 merge priority를 일관되게 확인해야 한다.
- Skill을 모두 상시 지침에 넣지 않고 profile 및 작업 유형에 맞게 선택해야 한다.
- Adapter별 template과 미지원 출력 차이를 preview 전에 확인해야 한다.
- 잘못된 조합과 incomplete metadata를 실제 파일 생성 전에 차단할 공통 report가 필요하다.

## 입력 개요

| 입력 | 역할 |
| --- | --- |
| Selected profile ID | `registry/profiles.yml`과 profile manifest 선택 |
| Target adapter | MVP에서는 `codex`만 허용 |
| Project metadata | Project name, stack 확인값, 검증 명령과 scope boundary |
| Variant selection | Profile이 required variant를 가지는 경우 정확히 하나의 option |
| Mode | `dry-run` 또는 `export-plan` |
| Registry/catalog source | ID, path, dependency, conflict, compatibility와 adapter metadata |

입력의 상세 구조와 실패 정책은 `docs/generator-input-contract.md`를 따른다.

## MVP 책임

- Registry, profile, Codex adapter와 template을 읽기 전용으로 load한다.
- Profile path와 catalog ID, dependency, variant와 bridge 참조를 해석한다.
- Compatibility와 conflict를 검증한다.
- Source provenance와 결정적 순서를 가진 merge trace를 구성한다.
- Codex template 기반 `AGENTS.preview.md`와 skill selection을 구성한다.
- Error, warning, info와 readiness를 가진 validation report를 구성한다.
- `export-plan` mode이면 실제 write 없이 적용 대상과 차단 조건을 계획으로 구성한다.

Preview는 검토 산출물이며 완성된 agent 설정 또는 설치 package가 아니다.

## Profile, Registry, Fragment, Skill과 Adapter 관계

1. Profile manifest가 project 유형의 기본 fragment와 skill 조합을 선언한다.
2. Registry catalog가 각 참조의 ID, 실제 path, dependency, conflict와 상태를 제공한다.
3. Compatibility matrix가 stack 관계와 required bridge를 제공한다.
4. Fragment source는 상시 지침의 의미 단위를 제공한다.
5. Skill source는 조건부 workflow와 lazy loading 대상 정보를 제공한다.
6. Codex adapter catalog와 template이 preview shape 및 unsupported output을 제공한다.

Generator는 이 source를 새 정책으로 바꾸지 않고 해석·검증·정렬·mapping한다.

## Codex 전용 MVP

- 첫 MVP target은 Codex project `AGENTS.md` preview로 한정한다.
- Core global/project 분리, fragment merge와 skill 참조를 Codex template 기준으로 먼저 확인한다.
- `.codex/hooks`와 git-auto는 기존 repository 운영 설정으로 취급하고 preview가 자동 수정하지 않는다.
- `adapterId`가 Claude 또는 Gemini이면 unsupported target error로 차단한다.
- Claude/Gemini는 `draft` 후속 범위이며 현재 resolved context나 output을 생성하지 않는다.

## Read-only 원칙

- `dry-run`과 `export-plan` output은 논리 artifact이며 filesystem write를 수행하지 않는다.
- Existing `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`를 읽거나 overwrite하지 않는다.
- Skill 설치, hook 변경, backup, archive와 download를 수행하지 않는다.
- Commit, push, Notion/GitHub publish와 installer를 수행하지 않는다.
- Export plan 가능 상태와 실제 export 가능 상태를 동일시하지 않는다.
- 실제 root `AGENTS.md` write는 초기 MVP에 포함하지 않으며 별도 계약과 명시적 승인 전에는 지원하지 않는다.

## 현재 범위

현재 문서는 preview-only MVP의 계약을 설명한다. Generator code, CLI, API, validator 실행기, Web UI와 file writer는 만들지 않는다.
