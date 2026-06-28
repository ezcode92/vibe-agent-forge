# MVP Generator 설계 개요

## 목적

MVP generator는 선택한 profile, project metadata와 adapter target을 검증된 논리 입력으로 해석해 agent 설정 preview와 validation report를 만드는 처리 경계를 정의한다. 실제 파일을 쓰기 전에 어떤 source가 선택되고 어떤 warning과 conflict가 남는지 확인하게 하는 것이 목적이다.

현재 단계에서는 generator를 구현하지 않는다. 이 문서는 입력, 처리 순서와 출력 계약만 정의한다.

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
| Target adapter | Codex, Claude 또는 Gemini 출력 계약 선택 |
| Project metadata | Project name, stack 확인값, 검증 명령과 scope boundary |
| Optional selections | 선택 fragment, skill 및 variant 결정 |
| Override values | Project 수준에서 허용된 제한적 구체화와 근거 |
| Registry/catalog source | ID, path, dependency, conflict, compatibility와 adapter metadata |

입력의 상세 구조와 실패 정책은 `docs/generator-input-contract.md`를 따른다.

## 출력 개요

- Adapter template 기반 preview content
- Included fragment와 skill 목록
- Merge order와 source 추적 정보
- Warning, conflict와 unsupported feature
- Validation checklist 및 severity별 report
- 실제 파일 생성이 제외됐다는 명시적 상태

Preview는 검토 산출물이며 완성된 agent 설정 또는 설치 package가 아니다.

## Profile, Registry, Fragment, Skill과 Adapter 관계

1. Profile manifest가 project 유형의 기본 fragment와 skill 조합을 선언한다.
2. Registry catalog가 각 참조의 ID, 실제 path, dependency, conflict와 상태를 제공한다.
3. Compatibility matrix가 stack 관계와 required bridge를 제공한다.
4. Fragment source는 상시 지침의 의미 단위를 제공한다.
5. Skill source는 조건부 workflow와 lazy loading 대상 정보를 제공한다.
6. Adapter catalog와 template이 target agent의 preview shape 및 unsupported output을 제공한다.

Generator는 이 source를 새 정책으로 바꾸지 않고 해석·검증·정렬·mapping한다.

## Codex 우선 전략

- 첫 MVP 검증 target은 Codex project `AGENTS.md` preview다.
- Core global/project 분리, fragment merge와 skill 참조를 Codex template 기준으로 먼저 확인한다.
- `.codex/hooks`와 git-auto는 기존 repository 운영 설정으로 취급하고 preview가 자동 수정하지 않는다.
- Codex 결과를 Claude/Gemini 입력으로 사용하지 않고 세 adapter 모두 같은 resolved context를 사용한다.
- Claude/Gemini는 capability와 의미 동등성 검증이 완료되기 전까지 draft warning을 유지한다.

## Preview-only 원칙

- Output은 memory상 논리 결과를 뜻하는 설계 개념이며 filesystem write를 수행하지 않는다.
- Existing `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`를 읽거나 overwrite하지 않는다.
- Skill 설치, hook 변경, backup, archive와 download를 수행하지 않는다.
- Commit, push, Notion/GitHub publish와 installer를 수행하지 않는다.
- Preview 가능 상태와 실제 export 가능 상태를 동일시하지 않는다.

## 현재 범위

현재 문서는 preview-only MVP의 계약을 설명한다. Generator code, CLI, API, validator 실행기, Web UI와 file writer는 만들지 않는다.
