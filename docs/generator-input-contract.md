# Generator 입력 계약

## 목적

Preview 또는 export plan 요청이 제공해야 할 사용자 선택과 repository source를 구분하고, pipeline 진입 전에 확인할 형식·참조·조합 규칙을 정의한다. 이 계약은 API DTO나 CLI option schema가 아니다.

## MVP 요청 필드

| 필드 | 필수 여부 | 계약 |
| --- | --- | --- |
| `profileId` | 필수 | `registry/profiles.yml`의 유일한 ID |
| `adapterId` | 필수 | MVP에서는 `codex`만 허용 |
| `variantSelection` | 조건부 필수 | Profile이 required variant를 가지면 option ID를 제공 |
| `projectMetadata` | 필수 | Project 개요, 확인된 stack, scope와 검증 정보 |
| `mode` | 필수 | `dry-run` 또는 `export-plan` |

## 요청 입력

### Selected Profile ID

- 필수 문자열이다.
- `registry/profiles.yml`의 유일한 profile ID와 일치해야 한다.
- Catalog entry의 `path`가 실제 profile manifest를 가리켜야 한다.

### Target Adapter

- 필수 adapter ID다.
- `registry/adapters.yml`에 존재해야 하며 MVP에서는 `codex`만 지원한다.
- Claude/Gemini ID는 catalog에 존재해도 `draft`이므로 unsupported target error다.

### Variant Selection

- Profile에 required variant가 없으면 생략한다.
- `fullstack-spring-react`의 `backend_language`는 `java` 또는 `kotlin` 중 정확히 하나를 선택한다.
- 미선택, 알 수 없는 option과 둘 이상의 선택은 error이며 preview를 `blocked`로 만든다.
- 선택 language fragment와 대응 Spring bridge를 하나의 option 묶음으로 해석하고 다른 option은 resolved 집합에서 제외한다.

### Mode

- `dry-run`은 preview, merge trace, skill selection과 validation report를 구성한다.
- `export-plan`은 같은 artifact에 write 없는 export plan을 추가한다.
- 실제 `export` 또는 write mode는 MVP에서 허용하지 않으며 unsupported mode error다.

### Project Metadata

| 항목 | 필수 여부 | 의미 |
| --- | --- | --- |
| Project name | 필수 | Preview 표시와 project overview |
| Project type | 필수 | Profile `target_project_type` 대조 |
| Primary language | 조건부 필수 | Profile 또는 variant와 일치 확인 |
| Framework/platform | 선택 | 선택 stack과 일치 확인 |
| Database/API/architecture | 선택 | Profile 및 compatibility 검증 |
| Validation commands | 선택 | Template의 검증 section 입력, 미입력 시 warning |
| Scope boundary | 필수 | 허용·제외·pending 작업 범위 |

Repository path는 provenance용 선택 metadata이며 MVP preview 필수 입력이 아니다. Generator는 해당 path의 파일을 자동 탐색하지 않는다. Secret과 credential은 입력으로 받지 않는다.

### MVP에서 받지 않는 선택 입력

- Profile 밖의 ad-hoc optional fragment와 skill 선택은 받지 않는다.
- Fragment 본문 교체, priority 변경과 project-level override는 받지 않는다.
- 확장이 필요하면 profile 또는 별도 후속 입력 계약에서 명시적으로 설계한다.

## Repository 입력 Source

| Source | 사용 목적 |
| --- | --- |
| `registry/fragments.yml` | Fragment ID, path, category, dependency, conflict, priority |
| `registry/skills.yml` | Skill ID, path, trigger, profile 추천과 dependency |
| `registry/profiles.yml` | Profile ID, manifest path와 count |
| `registry/adapters.yml` | Adapter path, template, output capability |
| `registry/compatibility-matrix.yml` | Stack relation, required bridge와 pending |
| `profiles/*/profile.yml` | Base/stack/bridge/skill, variant, pending과 output constraint |
| `templates/*` | Adapter별 preview section과 placeholder |
| Fragment source | `agents.fragment.md` 상시 규칙 |
| Skill source | `SKILL.md` trigger와 조건부 workflow |

MVP는 source를 수정하지 않고 읽기 전용으로 해석한다.

## 입력 검증 기준

- 모든 YAML이 파싱 가능하고 예상 root mapping/list를 가진다.
- Catalog별 ID가 중복되지 않는다.
- Profile ID와 adapter ID가 catalog에 존재한다.
- Pending이 아닌 catalog path와 adapter template이 실제 파일을 가리킨다.
- Profile path 참조가 catalog source path와 대응한다.
- Required dependency와 bridge가 resolved 선택에 포함된다.
- `conflicts_with` 및 compatibility 위반이 없다.
- Variant가 `exactly-one`이면 정확히 하나가 선택된다.
- Mode가 `dry-run` 또는 `export-plan`이다.
- Resolved compatibility에 `pending`이 없다.

## 오류 처리 정책

### 존재하지 않는 Path

- 필수 source 또는 template path면 error로 처리하고 preview를 생성하지 않는다.
- 선택되지 않은 `status: pending` catalog entry에 path가 없는 것은 오류가 아니다. Resolved 조합이 해당 relation을 선택하면 compatibility error로 처리한다.
- 임의 기본 path나 유사 이름으로 대체하지 않는다.

존재하지 않는 profile, adapter, fragment 또는 skill ID와 path는 모두 error다. Profile이 참조한 source를 조용히 제외하거나 유사 이름으로 대체하지 않는다.

### 중복 ID

- 같은 catalog 안의 중복 ID는 error다.
- Catalog 종류가 다른 동일 문자열은 namespace가 명확하지 않으면 error 또는 수동 검토 대상이다.
- 첫 번째 항목을 임의로 선택하지 않는다.

### Incompatible 조합

- Fragment `conflicts_with` 또는 명시적 incompatible relation은 error다.
- Required bridge 누락은 error이며 bridge가 존재하지 않는 pending 관계와 구분한다.
- Pending 또는 unregistered relation은 초기 MVP에서 error다. `spring-msa`, `restful-api-msa`를 supported로 추정하거나 사용자 수용만으로 진행하지 않는다.

### 미해결 Optional 항목

- Required variant 또는 선택 의존성이 미해결이면 error다.
- 단순 추천 optional skill/bridge를 선택하지 않은 경우 영향이 설명 가능하면 info 또는 warning이다.

## 현재 범위

입력 계약은 논리 field와 검증 결과만 정의한다. 별도 JSON Schema, CLI flag, API endpoint와 form component는 설계하지 않는다.
