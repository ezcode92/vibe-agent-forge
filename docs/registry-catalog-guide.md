# Registry Catalog 가이드

## 목적

Registry catalog는 AgentForge가 현재 관리하는 fragment, skill, profile과 adapter를 안정된 ID로 조회하고 의존·충돌·호환 관계를 수동 검토하기 위한 metadata 원본이다. Catalog 등록은 파일의 존재와 설계 상태를 나타내며 generator 또는 특정 agent 지원 완료를 의미하지 않는다.

모든 catalog는 YAML mapping과 항목 목록으로 구성하고 현재 존재하는 source만 `path`로 참조한다. 아직 없는 조합은 실제 path를 만들지 않고 compatibility 항목의 `status: pending`과 설명으로 구분한다.

## Catalog 파일별 역할

| 파일 | 역할 |
| --- | --- |
| `registry/fragments.yml` | Core, stack와 bridge fragment의 ID, 경로, 의존·충돌, merge priority와 상태 관리 |
| `registry/skills.yml` | Common·stack-specific skill의 trigger, 추천 profile, 의존·충돌과 상태 관리 |
| `registry/profiles.yml` | 6개 profile manifest의 프로젝트 유형, 언어, 구성 개수와 adapter 대상 요약 |
| `registry/adapters.yml` | Codex·Claude·Gemini adapter 계약, template, 지원·미지원 출력과 우선순위 관리 |
| `registry/compatibility-matrix.yml` | Fragment 조합의 지원 관계, 필수 bridge와 pending 조합 관리 |

Catalog의 `version`은 문서 구조 revision을 식별하는 초안 필드다. 현재 schema versioning이나 migration 기능은 제공하지 않는다.

## Catalog와 Profile Manifest의 차이

Catalog는 전체 자산을 검색하고 관계를 검증하기 위한 목록이다. Profile manifest는 특정 프로젝트 유형에 필요한 일부 fragment와 skill을 선택한 조합 선언이다.

- Catalog는 source의 안정된 ID, path, category와 전역 관계를 소유한다.
- Profile은 project 목적에 맞는 선택, variant, pending과 output constraint를 소유한다.
- Profile은 catalog 본문을 복제하지 않고 향후 path 참조를 catalog ID로 전환한다.
- Catalog는 profile의 실제 project 설정, 명령과 override를 소유하지 않는다.

현재 profile은 registry 구축 전 작성되어 저장소 상대 path를 참조한다. Generator 구현 전까지 catalog ID와 profile path를 수동으로 대조한다.

## Fragment Catalog 기준

- `required: true`는 모든 profile의 공통 기반인 core 항목에만 사용한다.
- `priority`는 `docs/merge-policy.md`의 낮은 우선순위에서 높은 우선순위 순서를 숫자로 표현한다.
- `depends_on`과 `conflicts_with`는 catalog ID를 참조한다.
- Bridge는 결합하는 독립 fragment를 `depends_on`에 모두 선언한다.
- Architecture의 배포 형태 충돌은 명시하되 Clean·Hexagonal 같은 내부 의존성 style은 함께 선택 가능하게 둔다.

## Skill Catalog 기준

- `trigger_keywords`는 검색·추천 보조 metadata이며 `SKILL.md` frontmatter의 description을 대체하지 않는다.
- `recommended_profiles`는 기본 설치나 자동 실행을 뜻하지 않고 수동 선택 후보를 나타낸다.
- `depends_on`은 workflow를 함께 적용할 때 필요한 common skill ID를 참조한다.
- Profile은 실제 작업 유형에 필요한 최소 skill만 선택하고 catalog 추천 전체를 복제하지 않는다.

## Profile Count 기준

`included_fragment_count`는 `base_fragments`, `quality_rules`, `stacks`, `bridges`의 resolved 합계다. Fullstack profile은 Spring–Modular Monolith bridge를 포함한 필수 13개에 backend language variant에서 선택되는 fragment와 bridge 2개를 더한 15개로 기록한다.

`included_skill_count`는 manifest의 `skills` 목록 개수다. Count는 manifest 변경 시 함께 갱신하고 수동 검토에서 큰 불일치가 없는지 확인한다.

## Compatibility Matrix 사용 기준

- `source`와 `target`은 `fragments.yml`의 ID를 참조한다.
- 기존 bridge가 필수면 `relation: requires-bridge`와 `required_bridge` ID를 기록한다.
- Bridge 없이 직접 결합 가능한 경우 `required_bridge: null`로 둔다.
- 필요한 bridge가 아직 없으면 `status: pending`, `required_bridge: null`로 두고 notes에 누락 책임을 설명한다.
- Pending 관계를 지원 완료로 해석하거나 profile에 존재하지 않는 bridge path를 추가하지 않는다.

Matrix는 방향성 있는 검토 entry이며 모든 가능한 stack 조합을 자동 추론하지 않는다. 역방향 조회나 transitive compatibility는 향후 validator 책임이다.

## 수동 검토 기준

- 모든 catalog YAML이 파싱되고 각 목록의 ID가 중복되지 않는다.
- `status`가 pending이 아닌 항목의 source path와 output template이 실제 존재한다.
- `depends_on`, `conflicts_with`, `recommended_profiles`, compatibility source·target·bridge가 해당 catalog ID로 해석된다.
- Profile count가 manifest 목록과 variant 규칙에 맞는다.
- Catalog에 아직 생성되지 않은 fragment, skill, profile과 adapter를 등록하지 않는다.

## 향후 Validator와 Generator 사용 방식

향후 validator는 catalog schema, path, ID 참조, dependency, conflict, profile count와 compatibility를 검사한다. Generator는 검증된 profile 선택을 catalog ID로 resolve하고 merge priority와 adapter capability를 적용한 뒤 출력 후보를 만든다.

현재는 validator, dependency resolver, merge engine과 generator가 없다. Catalog YAML은 사람이 source와 관계를 대조하기 위한 설계 초안이며 실제 파일 생성이나 설치를 수행하지 않는다.

## 현재 범위

현재는 5개 catalog YAML과 수동 검토 규칙만 정의한다. 자동 validator, generator, installer, adapter 구현과 Web UI는 만들지 않는다.

Catalog 항목의 `draft`, `mvp-contract`와 compatibility의 `pending` 해석은 `lifecycle-status-policy.md`를 따른다. 현재 pending relation의 보류 근거는 `compatibility-pending-items.md`에서 관리한다.
