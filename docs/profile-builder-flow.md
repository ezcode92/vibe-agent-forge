# Profile Builder Flow

## 목적

사용자가 project 목적에 맞는 fragment, bridge, skill과 adapter를 단계적으로 선택하고 preview 전에 검토 가능한 profile 초안을 만드는 흐름을 정의한다. 자동 생성이 아니라 추천과 사용자 확인 중심의 흐름이다.

## 입력

- 새 profile 또는 `registry/profiles.yml`에서 선택한 기존 profile
- Project type과 project metadata 초안
- Registry catalog 5종
- 선택한 profile manifest의 variant, pending과 constraints

## 단계별 흐름

### 1. Project Type 선택

- Backend, frontend, mobile, fullstack, CLI/automation 등 `target_project_type` 후보를 보여 준다.
- 기존 profile을 선택하면 manifest의 필수 항목을 초기값으로 읽는다.
- 새 조합은 임시 ID와 설명만 가지며 catalog entry로 자동 등록하지 않는다.

검토 질문:

- 하나의 primary project type으로 설명 가능한가?
- 기존 profile을 확장하는가, 별도 profile이 필요한가?

### 2. Language 선택

- `fragments.yml`의 `category: language` 항목을 보여 준다.
- Project type과 기존 profile의 `primary_language`는 추천 근거일 뿐 자동 선택이 아니다.
- `exactly-one` variant가 있으면 허용 option과 대응 bridge 묶음을 함께 표시한다.

### 3. Framework/Platform 선택

- Framework, frontend와 mobile category 후보를 선택한다.
- Language와의 compatibility entry를 즉시 표시한다.
- 필수 bridge가 있으면 추천 상태로 추가하되 사용자가 확인하기 전에는 확정하지 않는다.

### 4. Database/API/Architecture 선택

- Database, API와 architecture category를 독립 선택한다.
- Architecture 배포 형태의 `conflicts_with`를 확인하고 내부 dependency style과 구분한다.
- 현재 matrix에 없는 조합은 compatible로 추정하지 않고 `미등록 관계`로 표시한다.

### 5. Bridge 자동 추천

- 선택 fragment 쌍의 compatibility `required_bridge`를 조회한다.
- Bridge의 `depends_on`이 모두 선택됐는지 확인한다.
- `requires_bridge` 관계는 필수 추천, server 조합에 따른 조건부 bridge는 선택 추천으로 표시한다.
- Pending 관계는 존재하지 않는 bridge를 만들지 않고 보류 사유를 보여 준다.

### 6. Skill 자동 추천

- 선택 profile ID가 있으면 `skills.yml.recommended_profiles`를 사용한다.
- 새 profile이면 category, trigger keyword와 선택 stack을 추천 근거로 사용한다고 가정한다.
- Skill의 `depends_on`을 함께 표시하고 본문을 profile에 복제하지 않는다.
- 추천은 기본 선택이 아니며 실제 작업 유형에 필요한 최소 skill만 확정한다.

### 7. Adapter Target 선택

- `adapters.yml`의 Codex, Claude, Gemini 설계 상태와 output template을 보여 준다.
- Codex를 첫 검토 기준으로 추천하지만 다른 adapter를 미지원 없이 자동 선택하지 않는다.
- `status: draft`와 unsupported outputs를 사용자에게 숨기지 않는다.

### 8. Compatibility 검증

- 선택한 모든 관련 쌍을 matrix와 fragment dependency/conflict에 대조한다.
- Compatible, requires bridge, pending, incompatible와 미등록을 구분한다.
- Transitive compatibility를 자동 추론하지 않는다.

### 9. Conflict 확인

- 누락 dependency, 상호 conflict, 중복 variant, 필수 bridge 누락을 blocking conflict로 분류한다.
- Pending, adapter 미지원과 catalog 미등록 관계를 warning 또는 수동 결정으로 분류한다.
- Conflict Resolver에서 권장 해결안을 검토하고 사용자가 선택을 변경한다.

### 10. Preview 전 검토

- Selected fragment, bridge, skill과 adapter를 최종 목록으로 확인한다.
- Merge priority와 source path를 확인한다.
- Pending과 warning의 수용 근거를 기록한다.
- Project metadata와 validation command가 비어 있는지 확인한다.
- Preview가 실제 파일 생성이 아님을 다시 표시한다.

## 완료 상태

| 상태 | 의미 | Preview 가능 여부 |
| --- | --- | --- |
| Ready | Blocking conflict가 없고 필수 선택 완료 | 가능 |
| Needs decision | Variant, optional 추천 또는 수동 확인 남음 | 결정 후 가능 |
| Pending accepted | 미구현 관계를 명시적으로 보류 | Warning과 함께 가능 |
| Blocked | Conflict, dependency 또는 bridge 누락 | 불가 |

## 현재 범위

이 흐름은 UI에서 수행할 논리적 선택과 검토만 정의한다. Profile YAML 쓰기, catalog 갱신, validator, recommendation engine과 preview generator는 구현하지 않는다.
