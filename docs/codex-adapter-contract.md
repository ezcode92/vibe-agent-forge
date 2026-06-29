# Codex Adapter 공식 계약

## 목적과 상태

이 문서는 MVP generator가 Codex project instruction preview를 구성할 때 따라야 할 공식 adapter 계약이다. 계약 상태는 `mvp-contract`이며 입력 source, 논리 출력, section mapping, validation과 unsupported feature 처리 경계를 확정한다. 실제 adapter, generator, validator, CLI 또는 file writer 구현을 선언하지 않는다.

## 입력 Source

| Source | 계약상 역할 |
| --- | --- |
| Registry catalog | Adapter, profile, fragment, skill, compatibility ID·path·상태의 기준 |
| Profile manifest | 선택 fragment·bridge·skill, constraint, required section과 size budget |
| Fragment files | Project 상시 규칙과 stack 조합 책임의 원본 |
| Skill files | Skill ID, trigger, 역할, dependency와 lazy-load 참조의 원본 |
| Codex template | `templates/codex/AGENTS.md.template`의 section 순서와 필수 slot |
| Project metadata | 프로젝트 목적, 실제 기술 정보, 허용 범위, 완료 기준, automation 정책과 검증 명령 |

입력은 catalog에서 추적 가능해야 하며 required path, dependency, variant와 bridge가 해소돼야 한다. Project metadata가 없는 값은 추정하지 않는다. Preview에 필수가 아닌 환경별 값은 `확인 필요` 또는 `해당 없음`으로 명시할 수 있지만, 필수 선택 자체를 이 표기로 우회할 수 없다.

`templates/codex/AGENTS.md.template`는 `mvp-contract compatible` 상태의 preview/export 구조다. Template 자체의 placeholder는 입력 slot을 표시하며 실제 project instruction이나 생성 완료 artifact를 뜻하지 않는다.

## 출력 Target

| Target | 필수 내용 |
| --- | --- |
| `AGENTS.preview.md` | 8개 필수 section으로 구성된 Codex project instruction preview |
| Merge trace | Ordered fragment source, priority, deduplication, override와 conflict 근거 |
| Skill selection report | 선택 skill, source path, trigger, dependency, lazy-load와 미지원 상태 |
| Validation report | Check, severity, status, source, 영향, 조치와 preview readiness |

Target 이름은 논리 artifact 식별자다. MVP에서는 파일 생성이나 export를 수행하지 않으며 output metadata의 `writePerformed`는 항상 `false`다.

## 실제 출력 금지 대상

- Repository root `AGENTS.md`
- 사용자 전역 `~/.codex/AGENTS.md`
- Repository `.codex/hooks.json`
- `.codex/hooks` 내부 파일과 hook script
- 사용자 또는 repository skill directory

금지 대상에 대한 생성, 수정, 병합, overwrite, backup과 설치는 모두 계약 밖이다. Preview content가 실제 파일에 적용 가능하다는 보장도 하지 않는다.

## Section Mapping

| Section | 주 Source | 계약 |
| --- | --- | --- |
| Project Overview | Profile name·description, project metadata | 목적, 현재 단계, 사용자와 허용 작업 범위를 간결히 표현 |
| Tech Stack | Profile stack·bridge·variant, registry metadata | 선택 기술과 해소된 조합을 표시하고 미선택 기술은 추가하지 않음 |
| Included Fragments | Profile fragment groups, fragment catalog | Category와 source reference를 표시하고 전문은 넣지 않음 |
| Included Skills | Profile skills, skill catalog/file metadata | 선택 ID, 역할·trigger와 reference만 표시하고 본문은 넣지 않음 |
| Working Rules | Resolved fragment 규칙, merge result | 중복·충돌을 해소한 상시 규칙을 책임별로 요약 |
| Validation Commands | Project metadata, profile required section | 확인된 명령만 기록하고 미확정 값은 명시적 확인 필요로 표시 |
| Done Definition | Core/project/quality 규칙, project metadata | 결과, 검증 증거, 계약·문서 갱신과 미실행 보고 기준 |
| Scope Boundary | Profile constraints, project metadata, hook policy | Allowed, Excluded, Pending, Automation과 preview 제한 |

세부 mapping과 content 제한은 `docs/codex-output-mapping.md`를 따른다.

## Validation Severity

| Severity | 의미 | Preview 영향 |
| --- | --- | --- |
| `error` | 입력 해석, 필수 의미 보존 또는 안전한 preview를 보장할 수 없음 | `blocked` |
| `warning` | Preview는 가능하지만 선택적 미지원 기능 또는 명시된 수동 검토가 필요함 | `ready-with-warnings` |
| `info` | 통과 결과, provenance, deduplication 또는 사용하지 않은 capability 설명 | 영향 없음 |

같은 root cause를 중복 집계하지 않는다. Unsupported라는 이유만으로 항상 warning을 만들지 않으며, 선택 입력이 해당 기능을 요구하는지와 preview 의미에 미치는 영향으로 severity를 정한다.

## Preview 가능 조건

- Profile과 registry YAML parse가 성공한다.
- 선택 adapter, template, required fragment와 skill path가 존재한다.
- Required dependency, variant, compatibility와 bridge가 해소된다.
- 8개 필수 section이 완전하고 source provenance를 유지한다.
- 필수 placeholder가 남지 않고 미확정 비필수 metadata는 명시적으로 구분된다.
- Fragment 전문과 skill 본문이 inline되지 않는다.
- 적용 output size error threshold를 넘지 않는다.
- 실제 file write가 없고 보호 대상이 untouched다.
- Validation report를 완성할 수 있다.

Error가 없고 warning도 없으면 `ready`, error 없이 warning만 있으면 `ready-with-warnings`다.

## Preview 차단 조건

- 필수 YAML을 parse할 수 없거나 ID/path reference가 모호하다.
- Required fragment, skill, template, dependency, variant 또는 bridge가 누락된다.
- Incompatible 조합 또는 해소되지 않은 semantic conflict가 있다.
- 필수 section이나 source provenance가 누락된다.
- 필수 placeholder가 남거나 skill 본문이 inline된다.
- Output size error threshold를 넘거나 필수 규칙을 잘라야 한다.
- 실제 설정 파일 또는 보호 대상을 썼다.
- Profile이 필수로 요구한 hook·global config·skill 설치 등 미지원 output이 있다.

차단 시 완성 preview를 반환하지 않고 partial outline과 validation report만 검토 자료로 둘 수 있다.

## Unsupported Feature 처리

실제 파일 export, global config, hook 생성·병합, skill 설치, agent version 판정과 다른 agent 형식 변환은 지원하지 않는다. 선택 profile이 사용하지 않으면 capability 설명은 info이며 readiness를 낮추지 않는다. Optional 요구이면 영향과 수동 조치를 warning으로 기록한다. 필수 요구이면 error로 차단한다.

## 계약 우선순위와 현재 한계

Codex adapter 의미는 이 문서, `docs/codex-output-mapping.md`, `docs/codex-adapter-validation.md`, `adapters/codex/adapter.md` 순으로 구체화한다. Template은 `mvp-contract`와 호환되는 section 구조를 제공하지만 adapter 구현이나 실제 file write를 의미하지 않는다. Repository root `AGENTS.md`를 포함한 보호 대상의 생성·수정 금지 원칙은 계속 적용한다.
