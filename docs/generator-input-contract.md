# Generator 입력 계약

## 목적

Preview 생성 요청이 제공해야 할 사용자 선택과 repository source를 구분하고, pipeline 진입 전에 확인할 형식·참조·조합 규칙을 정의한다. 이 계약은 API DTO나 CLI option schema가 아니다.

## 요청 입력

### Selected Profile ID

- 필수 문자열이다.
- `registry/profiles.yml`의 유일한 profile ID와 일치해야 한다.
- Catalog entry의 `path`가 실제 profile manifest를 가리켜야 한다.

### Target Adapter

- 필수 adapter ID다.
- `registry/adapters.yml`에 존재하고 `status`가 preview 대상으로 해석 가능해야 한다.
- Unsupported output과 draft 상태를 사용자에게 숨기지 않는다.

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

Repository path는 Project Binding의 별도 metadata이며 MVP preview 필수 입력이 아니다. Secret과 credential은 입력으로 받지 않는다.

### Selected Optional Fragments

- Catalog fragment ID 목록이다.
- Profile 필수 fragment를 제거하는 용도로 사용하지 않는다.
- Variant option은 option ID와 함께 선택해 대응 bridge 묶음을 유지한다.
- Dependency와 conflict는 전체 resolved fragment 집합에서 다시 검증한다.

### Selected Optional Skills

- Catalog skill ID 목록이다.
- Profile 기본 skill과 중복되면 하나로 정규화한다.
- Skill dependency를 함께 확인하고 선택하지 않은 skill 본문을 load하지 않는다.

### Override Values

- Project 수준에서 허용된 section, 값, 근거와 source를 가진 제한적 목록이다.
- User 현재 요청과 project 지침의 금지 범위를 완화할 수 없다.
- Fragment 본문 전체 교체나 임의 priority 변경은 허용하지 않는다.
- 근거와 대상 section이 없는 override는 error다.

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
- Profile ID, adapter ID와 optional ID가 catalog에 존재한다.
- Pending이 아닌 catalog path와 adapter template이 실제 파일을 가리킨다.
- Profile path 참조가 catalog source path와 대응한다.
- Required dependency와 bridge가 resolved 선택에 포함된다.
- `conflicts_with` 및 compatibility 위반이 없다.
- Variant가 `exactly-one`이면 정확히 하나가 선택된다.
- Override가 허용 scope와 priority를 넘지 않는다.

## 오류 처리 정책

### 존재하지 않는 Path

- 필수 source 또는 template path면 error로 처리하고 preview를 생성하지 않는다.
- `status: pending`이고 path를 참조하지 않는 항목은 warning/info로 유지한다.
- 임의 기본 path나 유사 이름으로 대체하지 않는다.

### 중복 ID

- 같은 catalog 안의 중복 ID는 error다.
- Catalog 종류가 다른 동일 문자열은 namespace가 명확하지 않으면 error 또는 수동 검토 대상이다.
- 첫 번째 항목을 임의로 선택하지 않는다.

### Incompatible 조합

- Fragment `conflicts_with` 또는 명시적 incompatible relation은 error다.
- Required bridge 누락은 error이며 bridge가 존재하지 않는 pending 관계와 구분한다.
- Pending 또는 unregistered relation은 사용자가 명시적으로 수용한 경우에만 warning과 함께 preview 후보가 된다.

### 미해결 Optional 항목

- Required variant 또는 선택 의존성이 미해결이면 error다.
- 단순 추천 optional skill/bridge를 선택하지 않은 경우 영향이 설명 가능하면 info 또는 warning이다.

## 현재 범위

입력 계약은 논리 field와 검증 결과만 정의한다. JSON/YAML request schema, CLI flag, API endpoint와 form component는 설계하지 않는다.
