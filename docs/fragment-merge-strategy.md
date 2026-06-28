# Fragment Merge 전략

## 목적

Resolved fragment를 agent 중립적인 논리 지침으로 구성할 때 section 배치, priority, 중복과 충돌을 다루는 MVP 기준을 구체화한다. 기본 원칙은 `docs/merge-policy.md`를 따르며 이 문서는 generator 입출력 관점의 검토 단계를 추가한다.

## 두 종류의 순서

MVP는 출력 가독성을 위한 section 구성 순서와 conflict 해결을 위한 authority priority를 구분한다.

### 출력 Section 구성 순서

1. Core
2. Language
3. Framework/platform
4. Database/API/architecture
5. Bridge
6. Project override

이 순서는 preview에서 선택 내용을 읽기 쉽게 보여 주기 위한 논리 구조다. 뒤에 표시된 section이 앞 section을 자동으로 덮어쓴다는 의미가 아니다.

### Conflict 해결 Priority

- `registry/fragments.yml.priority`와 `docs/merge-policy.md`를 source of truth로 사용한다.
- 현재 catalog는 core 기본 원칙, language, database/API/architecture, framework/platform, bridge, project 순으로 높은 구체성을 표현한다.
- Project 지침과 사용자 현재 요청은 생성 결과 밖에서도 최종 권한을 가진다.
- Section 구성 순서와 numeric priority가 달라지는 지점은 validation report에 source와 근거를 표시한다.
- Catalog와 merge policy가 서로 다르면 자동 정렬하지 않고 error 또는 수동 검토 대상으로 처리한다.

## Merge 단위

각 규칙은 최소한 다음 metadata로 추적한다.

- Source fragment ID와 path
- Category와 priority
- 대상 section 및 의미 영역
- 적용 조건과 요구·금지 효과
- Dependency와 bridge 관계
- Override 여부와 근거

Markdown heading과 문자열만으로 동일 규칙 여부를 판단하지 않는다.

## 중복 제거 기준

- 대상, 조건과 요구 동작이 동일하면 하나의 규칙만 출력한다.
- 일반 규칙과 더 구체적인 규칙이 양립하면 일반 규칙을 반복하지 않고 구체적인 차이만 남긴다.
- 같은 용어 설명은 최초 정의 section에 두고 다른 규칙은 이를 참조한다.
- 표현만 비슷하고 강도·조건·scope가 다르면 중복으로 제거하지 않는다.
- 제거된 source도 preview의 provenance와 validation info에는 남긴다.

## 충돌 탐지 기준

- 같은 조건에서 하나는 요구하고 다른 하나는 금지한다.
- 동일 책임이나 데이터 소유자를 서로 다른 boundary에 배정한다.
- 양립할 수 없는 architecture, lifecycle과 도구를 동시에 필수로 선택한다.
- 낮은 authority가 project/user 금지 범위를 허용한다.
- Priority와 적용 조건으로 대체 관계를 설명할 수 없다.
- Required bridge가 없거나 bridge dependency가 선택되지 않았다.

안전한 대체가 가능하면 유지 규칙, 대체 source와 이유를 report에 남긴다. 근거가 없으면 preview를 차단한다.

## Bridge Fragment 우선순위

- Bridge는 독립 stack의 일반 규칙보다 조합 조건이 구체적일 때 해당 의미 영역을 보완한다.
- Bridge가 독립 fragment 전체를 삭제하거나 관련 없는 section을 override할 수 없다.
- 둘 이상의 bridge가 같은 경계에 다른 소유자·lifecycle을 요구하면 conflict다.
- Profile에 없는 stack을 bridge dependency로 암묵 추가하지 않는다.
- Pending bridge는 source content가 없으므로 merge 대상이 아니라 warning이다.

## Project Override

- Override는 대상 section, 값, 적용 조건과 근거를 가져야 한다.
- User/project 보안·금지 정책을 약화할 수 없다.
- 단일 profile에만 필요한 구체화에 사용하고 재사용 가능한 stack 규칙을 복제하지 않는다.
- Priority 숫자 자체를 사용자 입력으로 변경하지 않는다.

## 과도하게 긴 출력 방지

- 항상 필요한 상시 규칙만 agent 지침 preview에 포함한다.
- Skill 본문, 긴 배경과 조건부 workflow를 상시 문서에 펼치지 않는다.
- 동일 원칙, 용어와 검증 문장을 category 사이에서 반복하지 않는다.
- `docs/output-size-budget.md`의 output type별 line, heading과 estimated token 기준을 적용한다.
- Profile의 구조화된 `output.size_budget`이 더 엄격하면 profile 값을 우선한다.
- 길이 초과 시 중복 설명, background, optional 절차 순으로 분리 후보를 제안한다.
- Skill 본문 inline과 공통 error 기준 초과는 preview를 차단한다.
- 필수 규칙을 유지하고도 목표 budget을 만족하지 못하면 절단하지 않고 warning과 manual review로 처리한다.

## 수동 검토가 필요한 경우

- Catalog priority와 merge policy가 일치하지 않는다.
- Semantic conflict를 자동으로 분류할 근거가 없다.
- Profile override가 여러 fragment 책임을 동시에 변경한다.
- Pending/unregistered compatibility가 포함된다.
- Output이 warning threshold를 초과하거나 token 추정 정확도가 낮다.
- Adapter가 규칙 의미를 대상 형식에 보존할 수 없다.

## 현재 범위

이 전략은 merge engine algorithm이나 Markdown parser를 구현하지 않는다. Rule extraction, semantic equivalence와 token 계산은 향후 구현 및 검증 대상이다.
