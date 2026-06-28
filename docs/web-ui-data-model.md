# Web UI Conceptual Data Model

## 목적

Web UI에서 조회·선택·검토 상태를 표현할 개념 entity와 registry YAML mapping을 정의한다. 이 모델은 화면 간 용어를 맞추기 위한 것이며 database schema, API DTO, class 또는 serialization 계약이 아니다.

## 공통 원칙

- Registry source metadata와 UI session 상태를 구분한다.
- Catalog ID와 source path를 임의로 변경하지 않는다.
- Derived field는 원본 catalog field와 계산 근거를 추적할 수 있어야 한다.
- Conflict와 preview는 registry에 쓰지 않는 일시적 검토 결과다.
- Secret, credential와 실제 repository content를 모델에 포함하지 않는다.

## Entity 정의

### Fragment

| 주요 필드 | 의미 | Registry mapping |
| --- | --- | --- |
| `id`, `name`, `category` | 식별자, 표시 이름과 분류 | `fragments.yml` 동일 필드 |
| `path`, `description`, `status` | Source와 설명, lifecycle | `fragments.yml` 동일 필드 |
| `required` | 공통 필수 여부 | `fragments.yml.required` |
| `dependencies`, `conflicts` | 필요한/배타 fragment ID | `depends_on`, `conflicts_with` |
| `priority` | Merge 표시 순서 | `fragments.yml.priority` |
| `selected` | 현재 Builder 선택 상태 | UI session derived field |

### Skill

| 주요 필드 | 의미 | Registry mapping |
| --- | --- | --- |
| `id`, `name`, `category`, `path` | Skill 식별과 source | `skills.yml` 동일 필드 |
| `description`, `status` | Trigger 목적과 상태 | `skills.yml` |
| `triggerKeywords` | 검색·추천 보조 | `trigger_keywords` |
| `recommendedProfiles` | 추천 profile ID | `recommended_profiles` |
| `dependencies`, `conflicts` | Skill 관계 | `depends_on`, `conflicts_with` |
| `recommendationReason`, `selected` | 현재 추천 근거와 선택 | UI session derived field |

### Profile

| 주요 필드 | 의미 | Registry/Profile mapping |
| --- | --- | --- |
| `id`, `name`, `path`, `description` | Catalog 요약 | `profiles.yml` |
| `projectType`, `primaryLanguages` | Profile 분류 | `target_project_type`, `primary_language` |
| `fragmentCount`, `skillCount` | Resolved 구성 요약 | Catalog count field |
| `manifest` | Base/stack/bridge/skill 및 constraint | 선택한 `profile.yml`의 논리 내용 |
| `variantSelections` | 사용자 variant 결정 | UI session state |
| `pendingDecisions` | 보류 항목과 수용 이유 | Manifest와 UI session state |

### Adapter

| 주요 필드 | 의미 | Registry mapping |
| --- | --- | --- |
| `id`, `name`, `path`, `status` | Adapter 식별과 상태 | `adapters.yml` |
| `outputTemplates` | Preview template path | `output_templates` |
| `supportedOutputs` | 개념적 지원 출력 | `supported_outputs` |
| `unsupportedOutputs` | 미지원·수동 항목 | `unsupported_outputs` |
| `priority` | Codex 우선 표시 순서 | `adapters.yml.priority` |

### CompatibilityRule

| 주요 필드 | 의미 | Registry mapping |
| --- | --- | --- |
| `id`, `sourceId`, `targetId` | 관계 식별과 fragment 쌍 | Matrix `id`, `source`, `target` |
| `relation`, `status`, `notes` | 관계 유형, 지원 상태와 근거 | Matrix 동일 필드 |
| `requiredBridgeId` | 필요한 bridge ID 또는 없음 | `required_bridge` |
| `uiState` | Normalized compatible/requires_bridge/pending 등 | Catalog에서 계산 |

### Conflict

| 주요 필드 | 의미 | Source |
| --- | --- | --- |
| `id` | UI session 임시 식별자 | Derived |
| `type`, `severity` | Dependency, conflict, pending, unsupported 등 | Rule 평가 결과 |
| `sourceIds` | 관련 fragment/skill/profile/adapter | Catalog ID |
| `message`, `impact` | 사용자 설명과 preview 영향 | Derived |
| `recommendations` | 제거, bridge, profile 변경, pending 후보 | Derived, 자동 적용 아님 |
| `decision`, `decisionReason` | 사용자 선택과 근거 | UI session state |

### ProjectBinding

| 주요 필드 | 의미 | Source |
| --- | --- | --- |
| `projectName`, `repositoryPath` | 사용자 입력 project 식별 | UI input |
| `primaryLanguage`, `frameworkPlatform`, `architecture` | Project metadata | UI input/Profile comparison |
| `adapterTarget` | 선택 adapter ID | `adapters.yml` 참조 |
| `existingOutputState` | Agent 파일 없음/있음/알 수 없음 | 사용자 입력 |
| `overwritePolicy` | 항상 금지, review 필요 | UI policy |
| `gitAutoEnabled` | 직접 commit·push 금지 안내 여부 | 사용자/프로젝트 입력 |

`repositoryPath`는 실제 filesystem 접근 권한이나 repository content를 의미하지 않는다.

### PreviewResult

| 주요 필드 | 의미 | Source |
| --- | --- | --- |
| `adapterId`, `templatePath` | Preview 대상 | Adapter |
| `selectedFragmentIds`, `selectedSkillIds` | 검토 대상 source | Resolved selection |
| `mergeOrder` | ID와 priority의 논리 순서 | Fragment catalog/merge policy |
| `warnings`, `conflicts` | Pending·unsupported·충돌 | Conflict 결과 |
| `validationChecklist` | 완료·미완료 검토 항목 | Preview policy |
| `outlineSections` | 실제 본문 없는 출력 section | Adapter template |
| `readyState` | Ready/needs decision/blocked | Derived |

## Entity 관계

- Profile은 여러 Fragment와 Skill을 선택한다.
- Fragment는 다른 Fragment에 dependency/conflict를 가질 수 있다.
- CompatibilityRule은 두 Fragment와 선택적 bridge Fragment를 연결한다.
- Adapter는 Profile의 resolved 결과를 PreviewResult template에 mapping한다.
- Conflict는 Profile 선택과 CompatibilityRule 평가에서 생성된다.
- ProjectBinding은 Profile 및 Adapter를 사용자 project metadata에 연결한다.
- PreviewResult는 모든 선택과 conflict를 읽기 전용으로 집계한다.

## Registry YAML Mapping 원칙

- Catalog 필드 이름 변경은 UI 모델에서 숨기지 않고 mapping revision으로 관리한다.
- Pending relation에는 존재하지 않는 path를 생성하지 않는다.
- Profile manifest path 참조와 catalog ID는 수동 대조 상태임을 유지한다.
- UI derived field를 registry YAML에 역으로 저장하지 않는다.

## 현재 범위

이 모델은 conceptual entity와 field 의미만 정의한다. Database table, primary key, API request/response DTO, class, state store와 cache schema는 확정하지 않는다.
