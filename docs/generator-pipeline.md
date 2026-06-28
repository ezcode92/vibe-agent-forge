# Generator 처리 Pipeline

## 목적

검증되지 않은 사용자 선택과 repository source를 adapter별 preview 및 validation report로 변환하는 순차 단계를 정의한다. 각 단계는 입력, 출력과 실패 조건이 명확해야 하며 오류 상태에서 후속 단계를 성공으로 처리하지 않는다.

## 단계별 계약

| 단계 | 입력 | 출력 | 실패 조건 |
| --- | --- | --- | --- |
| 1. Profile load | Selected profile ID, `profiles.yml` | Catalog entry와 parsed profile manifest | ID 중복·누락, YAML 오류, manifest path 없음 |
| 2. Registry load | `registry/*.yml` | ID별 fragment/skill/profile/adapter/compatibility index | YAML 오류, 중복 ID, 필수 field 누락 |
| 3. Fragment reference resolve | Profile fragment path, optional/variant 선택, fragment catalog | Resolved fragment ID·path·category 집합 | Path mapping 실패, dependency 누락, required variant 미해결 |
| 4. Skill reference resolve | Profile skill path, optional skill, skill catalog | Resolved 기본·optional skill와 dependency 집합 | Path mapping 실패, skill dependency 누락 |
| 5. Compatibility validation | Resolved stack, compatibility matrix | Relation, required bridge, pending·unregistered 목록 | Incompatible 관계 또는 존재하는 필수 bridge 누락 |
| 6. Conflict detection | Fragment/skill 관계, profile constraint, adapter capability | Severity가 지정된 conflict 목록 | Blocking conflict 발견 시 resolved context 확정 불가 |
| 7. Merge order calculation | Conflict 없는 fragment, priority, override | Source 추적 가능한 논리 merge order | Priority 의미 충돌, unresolved semantic conflict |
| 8. Adapter template selection | Target adapter, adapter catalog | Adapter contract와 template path | Adapter/템플릿 누락, 지원 불가 target |
| 9. Output context construction | Merge order, skill selection, project metadata, adapter | Placeholder별 context와 unsupported 목록 | 필수 project metadata·template section 누락 |
| 10. Preview generation | Output context, template | Preview content와 included source metadata | 미치환 필수 placeholder, blocking conflict 잔존 |
| 11. Validation report generation | 모든 단계 결과 | Error/warning/info, checklist와 preview readiness | Report 자체 누락은 전체 실패 |

## 단계 상세

### 1–2. Profile과 Registry Load

- Profile catalog entry와 manifest의 ID를 대조한다.
- Catalog version을 기록하고 source를 수정하지 않는다.
- Registry load가 실패하면 path 추정이나 일부 catalog만으로 계속하지 않는다.

### 3. Fragment 참조 해석

- Profile path를 fragment catalog path에 역 mapping해 catalog ID를 얻는다.
- Base, quality, stack, bridge와 variant source를 구분한다.
- Optional fragment를 합친 뒤 dependency와 중복을 다시 확인한다.
- Pending은 실제 fragment로 해석하지 않는다.

### 4. Skill 참조 해석

- Profile 기본 skill과 optional skill을 ID 기준으로 합치고 중복 제거한다.
- Hard dependency가 없는 추천 관계를 dependency로 승격하지 않는다.
- Lazy loading을 위해 skill 본문은 preview 상시 지침과 분리한다.

### 5–6. Compatibility와 Conflict

- Matrix의 source/target 방향을 유지한다.
- Required bridge, `conflicts_with`, variant와 adapter unsupported를 구분한다.
- Pending 수용은 blocking conflict를 자동 해소하지 않는다.
- 동일 문제의 여러 증상은 하나의 root conflict와 관련 source로 묶는다.

### 7. Merge Order 계산

- 출력 section 구성 순서와 conflict 해결 priority를 구분한다.
- Catalog numeric priority와 `docs/merge-policy.md`를 기준으로 source authority를 계산한다.
- Project override는 근거와 대상 section을 가진 경우에만 적용한다.
- 의미 충돌은 문자열 정렬이나 마지막 항목 우선으로 해결하지 않는다.

### 8–9. Adapter와 Output Context

- Adapter entry, contract 문서와 output template을 함께 확인한다.
- Project metadata, selected source, warnings와 unsupported feature를 placeholder context로 정리한다.
- Agent 전용 기능이 중립 input에 없으면 adapter가 새로 추가하지 않는다.

### 10. Preview 생성

- MVP preview는 template section, source summary와 논리적 merge 결과를 표현한다.
- 실제 filesystem path에 쓰지 않고 완성된 설치 산출물로 표시하지 않는다.
- 기존 agent 설정과 diff 또는 overwrite 판단은 Project Binding 단계로 남긴다.

### 11. Validation Report

- 모든 단계의 진단을 severity, code, source와 해결 방향으로 집계한다.
- Error가 있으면 `blocked`, warning만 있으면 조건부 preview, 모두 해소되면 ready로 표시한다.
- Report는 preview 생성 여부와 무관하게 반환돼야 한다.

## 실패 전파 원칙

- Load·parse·필수 path 오류는 이후 resolve와 preview를 차단한다.
- Conflict error는 merge와 preview를 차단하되 진단 가능한 source 목록은 유지한다.
- Warning은 사용자 수용 또는 후속 검토 조건을 붙여 preview를 허용할 수 있다.
- 실패 단계 뒤의 결과는 `not-run`으로 표시하고 성공으로 추정하지 않는다.

## 현재 범위

이 pipeline은 설계 계약이다. 실행 graph, class, function, CLI command, API와 generator implementation은 만들지 않는다.
