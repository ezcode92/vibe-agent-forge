# Codex Adapter 계약

## 상태와 목적

- Agent 식별자: `codex`
- 계약 상태: `mvp-contract`
- 공식 계약: `docs/codex-adapter-contract.md`
- 출력 mapping: `docs/codex-output-mapping.md`
- 검증 규칙: `docs/codex-adapter-validation.md`

이 문서는 에이전트 중립 profile, registry, fragment와 skill 선택 결과를 Codex용 project 지침 preview로 표현하는 adapter 경계를 정의한다. `mvp-contract`는 MVP generator가 따라야 할 입력·출력·검증 의미가 확정됐다는 뜻이며 adapter, generator, validator 또는 file writer가 구현됐다는 뜻이 아니다.

## 입력 계약

Adapter는 다음 입력이 registry와 profile 규칙에 따라 해소된 상태를 받는다.

- Registry catalog의 Codex adapter, fragment, skill, profile과 compatibility 항목
- 선택된 profile manifest와 해당 output 제약
- Profile이 참조하는 core, stack, bridge, quality fragment file
- Profile이 참조하는 common 및 stack-specific skill file
- `templates/codex/AGENTS.md.template`
- 프로젝트 목적, 기술 구성, 작업 범위와 확인된 validation command를 포함한 project metadata
- Merge 결과의 source 순서, 중복 제거, 충돌, 미지원 기능과 수동 결정 기록

필수 YAML parse, path, dependency, variant, compatibility와 required bridge가 adapter 진입 전에 해소돼야 한다. 선택 입력의 provenance는 preview와 report에서 다시 추적할 수 있어야 한다.

## 출력 계약

MVP의 논리적 출력은 다음 preview artifact로 제한한다.

| 출력 | 책임 |
| --- | --- |
| `AGENTS.preview.md` | Codex project `AGENTS.md` 구조를 검토하기 위한 preview |
| Merge trace | Fragment 선택, 순서, authority, deduplication과 conflict 기록 |
| Skill selection report | 선택 skill, trigger, 참조 path, dependency와 lazy-load 상태 |
| Validation report | Check별 severity, 근거와 최종 preview status |

모든 출력은 filesystem export 계약이 아닌 review용 논리 결과다. `writePerformed`는 항상 `false`이며 root `AGENTS.md`, 전역 `~/.codex/AGENTS.md`, `.codex/hooks.json`과 skill directory를 생성하거나 수정하지 않는다.

## Profile → Codex AGENTS Preview Mapping

- Profile `name`, `description`과 project metadata는 `Project Overview`를 구성한다.
- Profile의 stack 선택과 해소된 variant·bridge는 `Tech Stack`을 구성한다.
- `base_fragments`, `stacks`, `bridges`, `quality_rules`는 `Included Fragments`에서 category와 source path로 추적한다.
- `skills`는 `Included Skills`에서 식별자, 역할, trigger와 참조 path만 표시한다.
- 선택 fragment의 상시 적용 규칙은 중복과 충돌을 해소해 `Working Rules`에 요약한다.
- Profile required section 중 검증 명령은 `Validation Commands`, 완료 조건은 `Done Definition`, constraint와 automation 제한은 `Scope Boundary`에 대응한다.
- Profile `output.size_budget`은 section content가 아니라 validation report의 적용 기준이 된다.

정확한 section별 source와 누락 처리 규칙은 `docs/codex-output-mapping.md`를 따른다.

## Fragment → AGENTS Section Mapping

- Core project·quality fragment는 `Working Rules`의 공통 기준으로 요약한다.
- Language, framework, database, API와 architecture fragment는 `Tech Stack`, `Included Fragments` 및 해당 `Working Rules` 하위 주제로 mapping한다.
- Bridge fragment는 관련 stack 조합의 교차 책임만 `Working Rules`에 반영한다.
- Global fragment는 project preview에 필요한 우선순위·작업 원칙만 포함하며 전역 파일 출력을 만들지 않는다.
- Fragment 전문, 배경 설명과 반복 규칙은 inline하지 않는다. 의미가 같은 규칙은 하나로 요약하고 merge trace에 provenance를 보존한다.

## Skill → AGENTS Reference Mapping

- 선택된 skill만 `Included Skills`에 표시한다.
- 각 항목은 skill ID, 짧은 역할 또는 trigger와 source reference로 제한한다.
- 작업 유형별 lazy loading 조건을 유지하고 `SKILL.md` 본문, checklist와 예시는 inline하지 않는다.
- Adapter가 skill 설치 위치를 결정하거나 skill file을 복사하지 않는다.
- Required skill path 또는 dependency가 없으면 preview를 차단한다. Optional 또는 adapter 미지원 기능은 영향에 따라 warning으로 보고한다.

## Hook Policy

- 현재 저장소의 `.codex/hooks`와 `.codex/hooks.json`은 git-auto 운영 설정이며 adapter 입력이나 수정 대상이 아니다.
- Git-auto 사용 사실과 직접 commit·push 금지, `.gitauto/` 제외 정책은 project metadata에 명시된 경우 `Scope Boundary`의 `Automation` 항목에 요약한다.
- Hook script, hook declaration과 credential을 preview에 inline하지 않는다.
- 기존 hook의 생성, 병합, 교체, 실행과 유효성 판정은 지원하지 않는다.
- Profile이 실제 hook output을 요구하면 미지원 필수 출력이므로 error로 처리한다. 운영 정책 문구의 preview 반영만 요구하면 지원 범위다.

## Unsupported Feature Policy

- 실제 설정 파일 쓰기, overwrite, backup과 설치
- Root 또는 전역 `AGENTS.md` export
- `.codex/hooks.json` 및 hook script 생성·병합·실행
- Skill directory 선택, 복사와 설치
- Pending·variant·semantic conflict의 자동 추정 해소
- Codex version별 capability 자동 판정
- Claude/Gemini output으로의 변환 또는 기능 동등성 보장

미지원 기능은 조용히 생략하지 않는다. 필수 output 또는 의미 보존에 필요하면 `error`로 preview를 차단하고, 선택 기능이며 preview 의미에 영향이 없으면 `warning`, 사용하지 않은 capability 설명은 `info`로 기록한다.

## Validation Checklist

- Registry와 profile YAML이 parse되는가
- 필수 fragment, skill과 template path가 존재하는가
- Required dependency, variant, compatibility와 bridge가 해소됐는가
- 8개 필수 output section이 모두 존재하고 source를 추적할 수 있는가
- 필수 placeholder가 치환되고 미확정 선택값이 명시적으로 표시됐는가
- Fragment 전문과 skill 본문이 inline되지 않았는가
- Profile 및 공통 output size budget을 충족하는가
- Unsupported feature와 수동 검토 항목이 보고됐는가
- Root `AGENTS.md`, `~/.codex/AGENTS.md`, `.codex/hooks.json`, `.codex/hooks`와 `.gitauto/`가 untouched인가
- Validation report의 severity와 `ready`, `ready-with-warnings`, `blocked` 판정이 일치하는가

세부 severity와 상태 판정은 `docs/codex-adapter-validation.md`를 따른다.

## MVP 지원 범위

- Resolved profile과 catalog를 기준으로 한 Codex project instruction preview 계약
- 정해진 8개 section의 source mapping
- Fragment 요약 및 provenance trace
- Skill reference와 selection report
- Output size, protected file과 unsupported feature 진단
- 결정적인 logical output과 수동 dry-run 검토

## MVP 제외 범위

- Adapter, generator, validator, CLI, API와 renderer 구현
- 실제 filesystem export와 agent 설정 설치
- Global Codex 설정, hook와 skill 설치 계약
- Existing file diff, merge, migration과 rollback
- Agent version 탐지와 runtime 검증
- Claude/Gemini adapter 계약 확정
